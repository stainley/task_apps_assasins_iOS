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
    var task: TaskEntity?
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
            //let categoryItemButton = UIButton(frame: CGRect(x: 0, y: 0, width: categoryButton.frame.width, height: 40))
            //categoryItemButton.setTitle("\(category.name ?? "")", for: .normal)
            //categoryItemButton.setTitleColor(.black, for: .normal)
            //categoryItemButton.addTarget(self, action: #selector(categoryItemButtonTapped), for: .touchUpInside)
            /*
            if categorySelected == category.name {
                categoryItemButton.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
            }
            catagoryCollection.append(categoryItemButton)
            if let stackView = categoryButton.superview as? UIStackView{
                stackView.addArrangedSubview(categoryItemButton)
            }*/
        }
        
        /*
        catagoryCollection.forEach{ (btn) in
            btn.isHidden = true
            btn.alpha = 0
        }
        
        categoryButton.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        categoryButton.layer.cornerRadius = 6
        categoryButton.contentHorizontalAlignment = .left
        categoryButton.setTitle("Category: \(categorySelected)", for: .normal)
        */
        let subTaskTableViewCell = UINib(nibName: "SubTaskTableViewCell", bundle: nil)
        subTaskTableView.register(subTaskTableViewCell, forCellReuseIdentifier: "SubTaskTableViewCell")
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
        var textField = UITextField()
        var dueDatePicker = UIDatePicker()
        
        let alert = UIAlertController(title: "New Subtask", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let subtaskTitle = self.subTasksEntity.map {$0.title?.lowercased()}
            
            let newSubTask = SubTaskEntity(context: self.context)
            newSubTask.title = textField.text!
            newSubTask.creationDate = Date()
            newSubTask.dueDate = Date()
            self.subTasksEntity.append(newSubTask)
            //self.saveSubTask()
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.orange, forKey: "titleTextColor")
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Subtask Name"
        }
        
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

extension TaskDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subTasksEntity.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = subTaskTableView.dequeueReusableCell(withIdentifier: "SubTaskTableViewCell", for: indexPath) as? SubTaskTableViewCell
        
        cell?.subtask = subTasksEntity[indexPath.row]
        cell?.subTaskTitleLabel?.text = subTasksEntity[indexPath.row].title
        cell?.datePickerButton?.setTitle(subTasksEntity[indexPath.row].dueDate?.toString(dateFormat: "MM/DD/YYY"), for: .normal)
        cell?.delegate = self
        return cell ?? UITableViewCell()    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, completionHandler) in
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subtask = self.subTasksEntity[indexPath.row]
    }
}

extension TaskDetailViewController: SubTaskTableViewCellDelegate {
    func selectDate(subTaskEntity: SubTaskEntity) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.minimumDate = Date()
        
        let alert = UIAlertController(title: "Due Date", message: "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        datePicker.frame = CGRect(x: 0, y: 40, width: alert.view.frame.width, height: 320)
        alert.view.addSubview(datePicker)

        let selectAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            subTaskEntity.dueDate = datePicker.date
            if let position = self.subTasksEntity.firstIndex(where: { subtask in
                return subtask.id == subTaskEntity.id
            }){
                self.subTasksEntity[position] = subTaskEntity
                //self.saveSubTask()
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(selectAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self as Date)
    }

}



