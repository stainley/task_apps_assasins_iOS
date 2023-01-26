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
    @IBOutlet weak var noteTextField: UITextView!
    
    @IBOutlet weak var audioTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    weak var delegate: NoteViewController?

    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder?
    
    var note: NoteEntity?
    var pictureEntity: PictureEntity?
    
    var imageNote: UIImage?
    var pictures: [UIImage] = []
    var audios: [AVAudioRecorder] = []
    
    var audioPath: [String] = []
    var soundURL: String?
    
    var locationManager: CLLocationManager = CLLocationManager()
    var coordinate: CLLocationCoordinate2D?
    
    var player: AVAudioPlayer?
    
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

    // MARK: Play audio button
    @objc func playAudio(_ sender: UIButton) {
        if audioRecorder == nil {
            do {
                var documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                
                // pass the index of record to play
                print("Index passed: \(sender.tag)")
                documentPath.append("/\(audioPath[sender.tag])")

                let url = NSURL(fileURLWithPath: documentPath)
                
                try player = AVAudioPlayer(contentsOf: url as URL)
                player?.volume = 1.0
                player?.play()
                print("Audio is playing \(String(describing: player?.isPlaying))")
            } catch {
                print(error.localizedDescription)
            }
        }
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
        
        /*
        catagoryCollection.forEach{ (btn) in
            btn.isHidden = true
            btn.alpha = 0
        }*/
        
        /// PREPARE FOR RECORDING AUDIO
        loadRecordingFuntionality()
        
        if pictures.count > 0 {
            pictureCollectionView.reloadData()
        }
        
        if audioPath.count > 0 {
            audioTableView.reloadData()
        }
        
        guard let note = note else {
            return
        }
        
        titleTextField.text = note.title
        noteTextField.text = note.noteDescription
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
       
        var note = Note(title: titleTextField.text ?? "", description: noteTextField.text)
        
        if pictures.count > 0 {
            for imageData in pictures {
                note.pictures.append(imageData.pngData()!)
            }
        }
        
        if audioPath.count > 0 {
            for audioData in audioPath {
                note.audios.append(audioData)
            }
        }
        
        if coordinate != nil {
            note.setCoordinate(latitude: coordinate?.latitude, longitude: coordinate?.longitude)
        }
        
        delegate?.saveNote(note: note)
    }
    
    func loadRecordingFuntionality() {

        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.recordAudioButton.isEnabled = true
                    } else {
                        self.recordAudioButton.isEnabled = false
                    }
                }
            }
        } catch {
            print("An error had ocurred configuring the Audio Rec functionality \(error.localizedDescription)")
        }
    }
    
    // TODO: Aswin
    func startRecording() {
        
        let directoryURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in:
                    FileManager.SearchPathDomainMask.userDomainMask).first
                
        let audioFileName = UUID().uuidString + ".m4a"
                let audioFileURL = directoryURL!.appendingPathComponent(audioFileName)
                soundURL = audioFileName       // Sound URL to be stored in CoreData

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            recordAudioButton.image = UIImage(systemName: "stop.circle.fill")
        } catch {
            finishRecording(success: false)
        }
    }
}
    
    
    
    
    

