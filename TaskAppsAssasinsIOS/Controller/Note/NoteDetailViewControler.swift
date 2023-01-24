//
//  NoteViewControler.swift
//  TaskAppsAssasinsIOS
//
//  Created by Jayesh Khistria on 2023-01-13.
//

import UIKit
import AVFoundation

class NoteDetailViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!    
    weak var recordButton: UIButton!
  
    
    @IBOutlet weak var noteTextField: UITextView!
    
    @IBAction func takePhotoButton(_ sender: UIBarButtonItem) {
        takePhotoOrUpload()
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pictureCollectionView.delegate = self
        pictureCollectionView.dataSource = self
        
        let nib = UINib(nibName: "PictureCollectionViewCell", bundle: nil)
        pictureCollectionView.register(nib, forCellWithReuseIdentifier: "pictureCell")
                
        /*
        catagoryCollection.forEach{ (btn) in
            btn.isHidden = true
            btn.alpha = 0
        }*/
        
        if pictures.count > 0 {
            //photoImageView.image =  pictures[0]
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
        
        //if let imageData = photoImageView.image?.pngData() {
            //note.image = imageData
            //note.pictures.append(imageData)
        //}
        
        if pictures.count > 0 {
            for imageData in pictures {
                note.pictures.append(imageData.pngData()!)
            }
        }
        delegate?.saveNote(note: note)
    }
}
    
    
    
    
    

