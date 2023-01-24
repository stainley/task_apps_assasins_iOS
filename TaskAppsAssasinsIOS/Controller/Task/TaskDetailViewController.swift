//
//  TaskDetailViewController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Ann Robles on 1/17/23.
//

import UIKit
import CoreData

class TaskDetailViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var task: Task?
    var categorySelected: String = ""
    var categories: [CategoryEntity] = [CategoryEntity]()
    var subTasksEntity: [SubTaskEntity] = [SubTaskEntity]()

    @IBOutlet weak var completedTaskCounterLabel: UILabel!
    @IBOutlet var catagoryCollection: [UIButton] = []
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var subTaskTableView: UITableView!
    
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
    
    @IBAction func addSubtaskButtonTapped(_ sender: UIButton) {
        let textField = UITextField()
        
        let alert = UIAlertController(title: "New Subtask", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let subtaskTitle = self.subTasksEntity.map {$0.title?.lowercased()}
            
            let newSubTask = SubTaskEntity(context: self.context)
            newSubTask.title = textField.text!
            newSubTask.creationDate = Date()
            newSubTask.dueDate = Date()
            self.subTasksEntity.append(newSubTask)
            self.saveSubTask()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.orange, forKey: "titleTextColor")
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
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
