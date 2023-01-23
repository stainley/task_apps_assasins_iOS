//
//  NoteViewControler.swift
//  TaskAppsAssasinsIOS
//
//  Created by Jayesh Khistria on 2023-01-13.
//

import UIKit

class NoteDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var catagory: UIButton!
    
    @IBOutlet var catagoryCollection: [UIButton]!
 
    
    var note: Note?
    var placeholderLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        catagoryCollection.forEach{ (btn) in
            btn.isHidden = true
            btn.alpha = 0
                        
        }
        
        descriptionTextField.layer.cornerRadius = 8
        descriptionTextField.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextField.layer.borderWidth = 0.25

        descriptionTextField.delegate = self

        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter some text for desciption..."
        placeholderLabel.font = .italicSystemFont(ofSize: (descriptionTextField.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        descriptionTextField.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (descriptionTextField.font?.pointSize)! / 2)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !descriptionTextField.text.isEmpty
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
    
extension NoteDetailViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

