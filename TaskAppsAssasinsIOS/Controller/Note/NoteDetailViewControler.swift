//
//  NoteViewControler.swift
//  TaskAppsAssasinsIOS
//
//  Created by Jayesh Khistria on 2023-01-13.
//

import UIKit
import AVFoundation

class NoteDetailViewController: UIViewController {
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    weak var recordButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    @IBOutlet weak var noteTexxtField: UITextView!
    
    @IBAction func takePhotoButton(_ sender: UIBarButtonItem) {
        takePhotoOrUpload()
    }
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var catagory: UIButton!
    
    @IBOutlet var catagoryCollection: [UIButton]!
 
    @IBOutlet weak var photoImageView: UIImageView!
    
    weak var delegate: NoteViewController?
    
    var note: NoteEntity?
    var pictureEntity: PictureEntity?
    
    var imageNote: UIImage?
    var pictures: [UIImage] = []
    var audios: [AVAudioRecorder] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        catagoryCollection.forEach{ (btn) in
            btn.isHidden = true
            btn.alpha = 0
        }*/
        
        guard let note = note else {
            return
        }
        
        titleTextField.text = note.title
        noteTexxtField.text = note.noteDescription
       
        if pictures.count > 0 {
            photoImageView.image =  pictures[0]

        }
        
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
     
    override func viewWillDisappear(_ animated: Bool) {
       
        var note = Note(title: titleTextField.text ?? "", description: noteTexxtField.text, audios: audios)
        
        if let imageData = photoImageView.image?.pngData() {
            note.image = imageData
        }
        
        delegate?.saveNote(note: note)
    }
}
    
    
    
    
    

