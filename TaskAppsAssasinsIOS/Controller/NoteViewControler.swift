//
//  NoteViewControler.swift
//  TaskAppsAssasinsIOS
//
//  Created by Jayesh Khistria on 2023-01-13.
//

import UIKit

class NoteViewControler: UIViewController {
    
    @IBOutlet weak var titleLbl: UITextField!
    
    @IBOutlet weak var catagoryBtn: UIButton!
    
    @IBOutlet weak var workBtn: UIButton!
    
    @IBOutlet weak var schoolBtn: UIButton!
    
    @IBOutlet weak var shoppingBtn: UIButton!
    
    @IBOutlet weak var groceryBtn: UIButton!
    
    @IBOutlet weak var addFilesBtn:UIButton!
    
    @IBOutlet weak var addPhotoBtn:UIButton!
    
    @IBOutlet weak var addVideoBtn:UIButton!
    
    @IBOutlet weak var addaudioBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    
    
    @IBAction func selectCatagory(_ sender: UIButton) {
        
        if sender.currentTitle == "Work" {
            schoolBtn.isHidden = true
            shoppingBtn.isHidden = true
            groceryBtn.isHidden = true
            print(sender)
        } else if sender.currentTitle == "School" {
            workBtn.isHidden = true
            shoppingBtn.isHidden = true
            groceryBtn.isHidden = true
            print(sender)
        } else if sender.currentTitle == "Shopping" {
            workBtn.isHidden = true
            schoolBtn.isHidden = true
            groceryBtn.isHidden = true
            print(sender)
        } else if sender.currentTitle == "Grocery" {
            workBtn.isHidden = true
            schoolBtn.isHidden = true
            shoppingBtn.isHidden = true
            print(sender)
        }
        
       
    }
    
    @IBAction func addFIle(_ sender: UIButton) {
        
        
        
        
        if sender.currentTitle == "Add Photo" {
            addVideoBtn.isHidden == true
            addaudioBtn.isHidden == true
        } else if sender.currentTitle == "Add Video" {
            addPhotoBtn.isHidden == true
            addaudioBtn.isHidden == true
        } else if sender.currentTitle == "Add Recordings" {
            addPhotoBtn.isHidden == true
            addVideoBtn.isHidden == true
        }
    }
    
    
    
    
    
    
    
    
    
    
}
    
    
    
    
    

