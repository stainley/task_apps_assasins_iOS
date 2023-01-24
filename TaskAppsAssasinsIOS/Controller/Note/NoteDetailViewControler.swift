//
//  NoteViewControler.swift
//  TaskAppsAssasinsIOS
//
//  Created by Jayesh Khistria on 2023-01-13.
//

import UIKit
import CoreData

protocol NoteDetailViewControllerDelegate {
    func reloadTableview()
}

class NoteDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var audioView: UIView!
    @IBOutlet weak var imageView: UIStackView!
    @IBOutlet var catagoryCollection: [UIButton] = []
    
    var note: NoteEntity?
    var placeholderLabel : UILabel!
    var categorySelected: CategoryEntity?
    var categories: [CategoryEntity] = [CategoryEntity]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var delegate: NoteDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories  = self.fetchAllCategory()
        for category in categories {
            let categoryItemButton = UIButton(frame: CGRect(x: 0, y: 0, width: categoryButton.frame.width, height: 40))
            categoryItemButton.setTitle("\(category.name ?? "")", for: .normal)
            categoryItemButton.setTitleColor(.black, for: .normal)
            categoryItemButton.addTarget(self, action: #selector(categoryItemButtonTapped), for: .touchUpInside)
            
            if categorySelected?.name == category.name {
                categoryItemButton.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
            }
            
            catagoryCollection.append(categoryItemButton)
            if let stackView = categoryButton.superview as? UIStackView{
                stackView.addArrangedSubview(categoryItemButton)
            }
        }
        
        catagoryCollection.forEach{ (btn) in
            btn.isHidden = true
            btn.alpha = 0
        }
        
        descriptionTextField.layer.cornerRadius = 6
        descriptionTextField.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextField.layer.borderWidth = 0.25

        descriptionTextField.delegate = self

        placeholderLabel = UILabel()
        placeholderLabel.font = .italicSystemFont(ofSize: (descriptionTextField.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        descriptionTextField.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (descriptionTextField.font?.pointSize)! / 2)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !descriptionTextField.text.isEmpty
        
        if note == nil {
            placeholderLabel.text = "Enter some text for desciption..."
        }
        
        categoryButton.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        categoryButton.layer.cornerRadius = 6
        categoryButton.contentHorizontalAlignment = .left
        categoryButton.setTitle("Category: \(String(describing: categorySelected?.name))", for: .normal)
        
        if let note = note {
            titleTextField.text = note.title
            descriptionTextField.text = note.noteDescription
        }
    }
    
    deinit {
        if note == nil {
            let newNote = NoteEntity(context: self.context)
            newNote.title = titleTextField.text ?? ""
            newNote.noteDescription = descriptionTextField.text ?? ""
            newNote.category_parent = categorySelected
            newNote.creationDate = Date()
        }
        else {
            note?.title = titleTextField.text ?? ""
            note?.noteDescription = descriptionTextField.text ?? ""
        }
        self.saveNote()
        delegate?.reloadTableview()
    }
    
    @IBAction func categoryButtonTapped(_ sender: Any) {
        catagoryCollection.forEach{ (btn) in
            UIView.animate(withDuration: 0.7, animations: loadViewIfNeeded) {_ in
                btn.layer.borderColor = UIColor.lightGray.cgColor
                btn.layer.borderWidth = 0.25
                btn.isHidden = !btn.isHidden
                btn.alpha = btn.alpha == 0 ? 1 : 0
                btn.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        print("sdfsdf")
    }
    
    @objc func categoryItemButtonTapped(sender: UIButton!) {

        catagoryCollection.forEach{ (btn) in
            btn.backgroundColor = .none
        }
        sender.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        //categorySelected = sender.titleLabel?.text ?? ""
        categoryButton.setTitle("Category: \(categorySelected?.name)", for: .normal)
        categoryButtonTapped(sender!)
    }
    
    func fetchAllCategory() -> Array<CategoryEntity> {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error loading categories \(error.localizedDescription)")
        }
        
        return Array<CategoryEntity>()
    }
}

extension NoteDetailViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

