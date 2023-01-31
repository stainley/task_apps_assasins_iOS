//
//  NoteViewControler.swift
//  TaskAppsAssasinsIOS
//
//  Created by Jayesh Khistria on 2023-01-13.
//

import UIKit
import AVFoundation
import CoreLocation

class NoteDetailViewController: UIViewController, AVAudioPlayerDelegate,  AVAudioRecorderDelegate {
    
    @IBOutlet weak var audioGroupView: CustomUIView!
    @IBOutlet weak var mapButton: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var catagory: UIButton!
    @IBOutlet var catagoryCollection: [UIButton]!
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    @IBOutlet weak var recordAudioButton: UIBarButtonItem!
    @IBOutlet var noteTextField: UITextView!
    @IBOutlet weak var imageSectionLabel: UILabel!
    @IBOutlet weak var audioTableView: UITableView!
    
    var scrubber: [UISlider] = []
    var audioPlayButton: [UIButton] = []
    var audioTimeLabel: [UILabel] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var delegate: NoteViewController?
    
    var timer = Timer()

    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder?
    
    var note: NoteEntity?
    var pictureEntity: PictureEntity?
    var pictureEntities: [PictureEntity] = []
    
    var pictures: [UIImage] = []
    var newPictures: [UIImage] = []
    
    var audioPath: [String] = []
    var newAudioPath: [String] = []
    var soundURL: String?
    
    var locationManager: CLLocationManager = CLLocationManager()
    var coordinate: CLLocationCoordinate2D?
    
    var player: AVAudioPlayer?
    
    var placeholderLabel : UILabel!
    
    var doubleTapGesture: UITapGestureRecognizer!
    
    @IBAction func takePhotoButton(_ sender: UIBarButtonItem) {
        takePhotoOrUpload()
    }
    
    // MARK: Show in the map the note
    @IBAction func showNoteInMapButton(_ sender: UIBarButtonItem) {
        
        let mapViewController = storyboard?.instantiateViewController(withIdentifier: "mapStorryboardID") as! MapTaskNoteViewController
        mapViewController.coordinate = coordinate
        show(mapViewController, sender: nil)
        
    }
    
    // MARK: Audio recording
    @IBAction func recordAudioButton(_ sender: UIBarButtonItem) {
        recordTapped()
    }

    @objc func scrubleAction(_ sender: UISlider) {
        sender.maximumValue = Float(player!.duration)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pictureCollectionView.delegate = self
        pictureCollectionView.dataSource = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let nib = UINib(nibName: "PictureCollectionViewCell", bundle: nil)
        pictureCollectionView.register(nib, forCellWithReuseIdentifier: "pictureCell")

        audioTableView.delegate = self
        audioTableView.dataSource = self
        
       
        let nibAudioTable = UINib(nibName: "AudioCustomTableViewCell", bundle: nil)
        audioTableView.register(nibAudioTable, forCellReuseIdentifier: "audioPlayerCell")
        
        imageSectionLabel.isHidden = true
        pictureCollectionView.superview?.isHidden = true
        setUpDoubleTap()
        
        titleTextField.delegate = self
        noteTextField.delegate = self
        
        // PREPARE FOR RECORDING AUDIO
        loadRecordingFuntionality()
        

      
        if pictures.count > 0 {
            pictureCollectionView.reloadData()
            imageSectionLabel.isHidden = false
            imageSectionLabel.isHidden = false
            pictureCollectionView.superview?.isHidden = false
        }
        
        if audioPath.count > 0 {
            audioTableView.reloadData()
        }
        
        noteTextField.layer.cornerRadius = 6
        noteTextField.layer.borderWidth = 0.25
        noteTextField.layer.borderColor = UIColor.lightGray.cgColor
        noteTextField.contentInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        noteTextField.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter some text for desciption..."
        placeholderLabel.font = .italicSystemFont(ofSize: (noteTextField.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        noteTextField.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (noteTextField.font?.pointSize)! / 2)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !noteTextField.text.isEmpty

        guard let note = note else {
            return
        }
        
        titleTextField.text = note.title
        noteTextField.text = note.noteDescription
        placeholderLabel.text = ""
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        mapButton.isEnabled = false
        if note != nil {
            mapButton.isEnabled = true
        }
        
        if audioPath.count == 0 {
            audioGroupView.isHidden = true
        } else {
            audioGroupView.isHidden = false
        }
    }
     
    // Send to NoteViewController and persist into Core Data
    override func viewWillDisappear(_ animated: Bool) {
       
 
        
        let savingWorker = DispatchWorkItem {
            var newNote = Note(title: self.titleTextField.text ?? "", description: self.noteTextField.text)
            
            if self.pictures.count > 0 {
                for imageData in self.pictures {
                    newNote.pictures.append(imageData.pngData()!)
                }
            }
            
            if self.audioPath.count > 0 {
                for audioData in self.audioPath {
                    newNote.audios.append(audioData)
                }
            }
            
            if self.coordinate != nil {
                newNote.setCoordinate(latitude: self.coordinate?.latitude, longitude: self.coordinate?.longitude)
            }
            
            self.delegate?.saveNote(note: newNote, oldNoteEntity: self.note, newPictures: self.newPictures, newAudioPath: self.newAudioPath)
        }
                
        DispatchQueue.main.async(execute: savingWorker)

    }
    
    @objc func updateScrubber(sender: Timer) {
        let index = sender.userInfo as! Int
        let audioTime = Float(player!.currentTime)
        scrubber[index].value = audioTime
        audioTimeLabel[index].text =  player!.currentTime.stringFromTimeInterval()
        
        if scrubber[index].value == scrubber[index].minimumValue {
 
            audioPlayButton[index].setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            print("show button play")
        }
        
        if scrubber[index].value == 0.0 {
            timer.invalidate()
        }
    }

}
    
extension NoteDetailViewController : UITextViewDelegate, UITextFieldDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension TimeInterval{

    func stringFromTimeInterval() -> String {

            let time = NSInteger(self)

            //let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
            let seconds = time % 60
            let minutes = (time / 60) % 60

            return String(format: "%0.2d:%0.2d",minutes,seconds)

        }
    }

