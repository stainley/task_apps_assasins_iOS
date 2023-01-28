//
//  ChangeCategoryMenu.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-28.
//

import UIKit

class ChangeCategoryMenu: UIViewController {
    
    var taskViewControllerDelegate: TaskViewController!
    var noteViewControllerDelegate: NoteViewController!
    
    var categories: [CategoryEntity] = []
    var noteToChange: NoteEntity!
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select Category", for: .normal)
        button.backgroundColor = UIColor.tintColor
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.bounds = CGRect(x: 8, y: 8, width: 300, height: 20)
        button.showsMenuAsPrimaryAction = true
        button.menu = menu
        return button
    }()
    
    func categoryOptions(handler: AnyObject? = nil) -> [UIAction] {
        var actions: [UIAction] = []
        
        for category in categories {
            // remove actual category from menu
            if category.name == noteViewControllerDelegate.selectedCategory!.name {
                continue
            }
            
            let action = UIAction(title: category.name ?? "", image: UIImage(systemName: "folder.circle"), handler: { (action) in
                
                self.noteViewControllerDelegate.changeNoteCategory(noteEntity: self.noteToChange, for: category)                
            })
            actions.append(action)
        }
        
        return actions
    }
    
    //private lazy var elements: [UIAction] = [first, second]
    private lazy var elements: [UIAction] = categoryOptions()
    private lazy var menu = UIMenu(title: "Category", children: elements)
    
    override func viewDidLoad() {
        
        view.addSubview(categoryButton)
        categoryButton.menu = menu
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)

        navigationItem.rightBarButtonItem?.menu = menu
    }
}
