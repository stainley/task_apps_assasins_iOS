//
//  TaskDetailViewController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Ann Robles on 1/17/23.
//

import UIKit
import CoreData

class TaskDetailViewController: UIViewController {

    var task: Task?
    var categorySelected: String = ""
    var categories: [CategoryEntity] = [CategoryEntity]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var completedTaskCounterLabel: UILabel!
    @IBOutlet var catagoryCollection: [UIButton] = []
    @IBOutlet weak var categoryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories  = self.fetchAllCategory()
        for category in categories {
            let categoryItemButton = UIButton(frame: CGRect(x: 0, y: 0, width: categoryButton.frame.width, height: 40))
            categoryItemButton.setTitle("\(category.name ?? "")", for: .normal)
            categoryItemButton.setTitleColor(.black, for: .normal)
            categoryItemButton.addTarget(self, action: #selector(categoryItemButtonTapped), for: .touchUpInside)
            
            if categorySelected == category.name {
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
        
        categoryButton.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        categoryButton.layer.cornerRadius = 6
        categoryButton.contentHorizontalAlignment = .left
        categoryButton.setTitle("Category: \(categorySelected)", for: .normal)
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
    
    @objc func categoryItemButtonTapped(sender: UIButton!) {

        catagoryCollection.forEach{ (btn) in
            btn.backgroundColor = .none
        }
        sender.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        categorySelected = sender.titleLabel?.text ?? ""
        categoryButton.setTitle("Category: \(categorySelected)", for: .normal)
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
