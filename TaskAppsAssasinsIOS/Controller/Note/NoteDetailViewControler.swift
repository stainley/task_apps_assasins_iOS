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
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var catagory: UIButton!
    @IBOutlet var catagoryCollection: [UIButton]!
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    @IBOutlet weak var recordAudioButton: UIBarButtonItem!
    @IBOutlet var noteTextField: UITextView!
    @IBOutlet weak var imageSectionLabel: UILabel!
    @IBOutlet weak var audioTableView: UITableView!
    
    weak var scrubber: UISlider!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var delegate: NoteViewController?
    
    // timer to update my scrubber
    var timer = Timer()

    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder?
    
    var note: NoteEntity?
    var pictureEntity: PictureEntity?
    
    //var imageNote: UIImage?
    var pictures: [UIImage] = []
    //var audios: [AVAudioRecorder] = []
    
    var audioPath: [String] = []
    var soundURL: String?
    
    var locationManager: CLLocationManager = CLLocationManager()
    var coordinate: CLLocationCoordinate2D?
    
    var player: AVAudioPlayer?
    
    var placeholderLabel : UILabel!
    
    @IBAction func takePhotoButton(_ sender: UIBarButtonItem) {
        takePhotoOrUpload()
    }
    
    // MARK: Show in the map the note
    @IBAction func showNoteInMapButton(_ sender: UIBarButtonItem) {
        
        let mapViewController = storyboard?.instantiateViewController(withIdentifier: "mapStorryboardID") as! MapTaskNoteViewController
        mapViewController.coordinate = coordinate
        present(mapViewController, animated: true)
        
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
        
        /// PREPARE FOR RECORDING AUDIO
        loadRecordingFuntionality()
        if let scrubber = scrubber {
            scrubber.minimumValue = 0
        }
      
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
        
    @IBAction func CatagaryDropDown(_ sender: Any) {
        catagoryCollection.forEach{ (btn) in
            UIView.animate(withDuration: 0.7, animations: loadViewIfNeeded) {_ in
                btn.isHidden = !btn.isHidden
                btn.alpha = btn.alpha == 0 ? 1 : 0
                btn.layoutIfNeeded()
            }
        }
    }
        
    @IBAction func Catagary(_ sender: Any) {
        
    }
     
    // Send to NoteViewController and persist into Core Data
    override func viewWillDisappear(_ animated: Bool) {
       
        var newNote = Note(title: titleTextField.text ?? "", description: noteTextField.text)
        
        if pictures.count > 0 {
            for imageData in pictures {
                newNote.pictures.append(imageData.pngData()!)
            }
        }
        
        if audioPath.count > 0 {
            for audioData in audioPath {
                newNote.audios.append(audioData)
            }
        }
        
        if coordinate != nil {
            newNote.setCoordinate(latitude: coordinate?.latitude, longitude: coordinate?.longitude)
        }
        
        self.delegate?.saveNote(note: newNote, oldNoteEntity: note)
    }
    
    @objc func updateScrubber() {
        scrubber.value = Float(player!.currentTime)
        if scrubber.value == scrubber.minimumValue {
            //  isPlaying = false
            //playBtn.image = UIImage(systemName: "play.fill")
        }
    }

}
    
extension NoteDetailViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

