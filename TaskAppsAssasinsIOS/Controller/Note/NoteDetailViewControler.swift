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
    
    @IBAction func takePhotoButton(_ sender: UIBarButtonItem) {
        //takePhotoOrUpload()
        takePhotoOrUpload()
    }
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var catagory: UIButton!
    
    @IBOutlet var catagoryCollection: [UIButton]!
 
    @IBOutlet weak var photoImageView: UIImageView!
    
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        catagoryCollection.forEach{ (btn) in
            btn.isHidden = true
            btn.alpha = 0
                        
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
    
    
    
    
    
    
    
    
    
    
}
    
    
    
    
    

