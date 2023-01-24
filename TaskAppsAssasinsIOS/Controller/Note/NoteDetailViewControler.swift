//
//  NoteViewControler.swift
//  TaskAppsAssasinsIOS
//
//  Created by Jayesh Khistria on 2023-01-13.
//

import UIKit
import AVFoundation
import CoreLocation

class NoteDetailViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!    
    weak var recordButton: UIButton!
  
    
    @IBOutlet weak var noteTextField: UITextView!
    
    @IBAction func takePhotoButton(_ sender: UIBarButtonItem) {
        takePhotoOrUpload()
    }
    
    @IBAction func showNoteInMapButton(_ sender: UIBarButtonItem) {
        
        let mapViewController = storyboard?.instantiateViewController(withIdentifier: "mapStorryboardID") as! MapTaskNoteViewController
        mapViewController.coordinate = coordinate
        present(mapViewController, animated: true)
        
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var catagory: UIButton!
    
    @IBOutlet var catagoryCollection: [UIButton]!
     
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    
    weak var delegate: NoteViewController?
    
    var note: NoteEntity?
    var pictureEntity: PictureEntity?
    
    var imageNote: UIImage?
    var pictures: [UIImage] = []
    var audios: [AVAudioRecorder] = []
    
    var locationManager: CLLocationManager = CLLocationManager()
    var coordinate: CLLocationCoordinate2D?
    
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
                
        /*
        catagoryCollection.forEach{ (btn) in
            btn.isHidden = true
            btn.alpha = 0
        }*/
        
        if pictures.count > 0 {
            pictureCollectionView.reloadData()
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
     
    // Send to preview view and persist into Core Data
    override func viewWillDisappear(_ animated: Bool) {
       
        var note = Note(title: titleTextField.text ?? "", description: noteTextField.text, audios: audios)
        
        if pictures.count > 0 {
            for imageData in pictures {
                note.pictures.append(imageData.pngData()!)
            }
        }
        
        if coordinate != nil {
            note.setCoordinate(latitude: coordinate?.latitude, longitude: coordinate?.longitude)
        }
        
        delegate?.saveNote(note: note)
    }
}
    
    
    
    
    

