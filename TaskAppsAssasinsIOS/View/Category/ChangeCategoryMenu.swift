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
    var taskToChange: TaskEntity!
    
    func categoryOptions(handler: AnyObject? = nil) -> [UIAction] {
        var actions: [UIAction] = []
        
        for category in categories {
            // remove actual category from menu
            
            if noteViewControllerDelegate != nil {
                if category.name == noteViewControllerDelegate.selectedCategory!.name {
                    continue
                }
            }
            
            if taskViewControllerDelegate != nil {
                if category.name == taskViewControllerDelegate.selectedCategory!.name {
                    continue
                }
            }
            
            let action = UIAction(title: category.name ?? "", image: UIImage(systemName: "folder.circle"), handler: { (action) in
                
                if self.noteViewControllerDelegate != nil {
                    self.noteViewControllerDelegate.changeNoteCategory(noteEntity: self.noteToChange, for: category)
                }
                
                if self.taskViewControllerDelegate != nil {
                    self.taskViewControllerDelegate.changeTaskCategory(taskEntity: self.taskToChange, for: category)
                }
                
            })
            actions.append(action)
        }
        
        return actions
    }

}
