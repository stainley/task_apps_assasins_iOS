//
//  NoteTaskTabBarController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Ann Robles on 1/17/23.
//

import UIKit

class NoteTaskTabBarController: UITabBarController {

    var categorySelected: CategoryEntity!
    var delegateCategory: CategoryViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)], for: .normal)
      
        guard let categoryTitle = categorySelected else {
            return
        }
        self.title = categoryTitle.name
        let vc = viewControllers?[Category.note.rawValue] as! NoteViewController
        vc.selectedCategory = self.categorySelected
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        var category = Category.note
        
        if item.title == "Note" {
            category = .note
            selectTabItem(category: category)
        } else {
            category = .task
            selectTabItem(category: category)
        }              
    }
    
    func selectTabItem(category: Category) {
        switch category {
            case .note:
                let vc = viewControllers?[category.rawValue] as! NoteViewController
            
                vc.selectedCategory = self.categorySelected
            
            case .task:
                let vc = viewControllers?[category.rawValue] as!  TaskViewController
                vc.selectedCategory = self.categorySelected
        }
    }
    

}
