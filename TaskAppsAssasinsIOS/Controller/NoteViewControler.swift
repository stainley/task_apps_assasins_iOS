//
//  NoteViewControler.swift
//  TaskAppsAssasinsIOS
//
//  Created by Jayesh Khistria on 2023-01-13.
//

import UIKit

class NoteDetailViewController: UIViewController {
    
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var catagory: UIButton!
    
    @IBOutlet var catagoryCollection: [UIButton]!
    
    @IBOutlet weak var upload: UIButton!
    
    @IBOutlet var uploadCatagory: [UIButton]!
 
    
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        catagoryCollection.forEach{ (btn) in
            btn.isHidden = true
            btn.alpha = 0
                        
        }
        
        uploadCatagory.forEach{ (btn) in
            btn.isHidden = true
            btn.alpha = 0
            
        }
        
    }
    
    
    
    @IBAction func CatagaryDropDown(_ sender: Any) {
        catagoryCollection.forEach{ (btn) in
            UIView.animate(withDuration: 1, animations: loadViewIfNeeded) {_ in
                btn.isHidden = !btn.isHidden
                btn.alpha = btn.alpha == 0 ? 1 : 0
                btn.layoutIfNeeded()
            }
        }
    }
        
    @IBAction func Catagary(_ sender: Any) {
        
        
    }
    
    @IBAction func uploadDropDown(_ sender: Any) {
        uploadCatagory.forEach{ (btn) in
            UIView.animate(withDuration: 1, animations: loadViewIfNeeded) {_ in
                btn.isHidden = !btn.isHidden
                btn.alpha = btn.alpha == 0 ? 1 : 0
                btn.layoutIfNeeded()
            }
        }
    }
    
    
    
    @IBAction func addCaragory(_ sender: Any) {
        

    }
    
    
}
    
    
    
    
    

