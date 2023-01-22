//
//  TaskSearchViewController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Ann Robles on 1/17/23.
//

import UIKit

class TaskSearchViewController: UIViewController {

    @IBOutlet weak var taskTableView: UITableView!
    
    var items = [Task]()
    var taskReferenceCell: TaskNibTableViewCell!
    var passingData: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let data = passingData else {
            return
        }
        print(data)
        
        
        //TO BE REMOVE - DUMMY DATA
        items.append(Task(title: "Do Grocery", description: "Buy fruits, veggies, and meat", creationDate: NSDate(), dueDate: NSDate(), dateCompleted: NSDate(), pictures: [], audios: [], isComplete: false))
        items.append(Task(title: "Visit Parents", description: "Spend sunday with parents", creationDate: NSDate(), dueDate: NSDate(), dateCompleted: NSDate(), pictures: [], audios: [], isComplete: true))
        items.append(Task(title: "Play with the cats", description: "Play for 1 hour with the cat", creationDate: NSDate(), dueDate: NSDate(), dateCompleted: NSDate(), pictures: [], audios: [], isComplete: false))
        items.append(Task(title: "Visit Bank", description: "Get February rent cheque", creationDate: NSDate(), dueDate: NSDate(), dateCompleted: NSDate(), pictures: [], audios: [], isComplete: true))
        
        let cellNib = UINib(nibName: "TaskNibTableViewCell", bundle: Bundle.main)
        taskTableView.register(cellNib, forCellReuseIdentifier: "TaskNibTableViewCell")
        
    }

}

extension TaskSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskTableView.dequeueReusableCell(withIdentifier: "TaskNibTableViewCell", for: indexPath) as? TaskNibTableViewCell

        cell?.titleLabel?.text = items[indexPath.row].getTitle()
        cell?.descriptionLabel?.text = items[indexPath.row].getDescription()
        cell?.creationDateLabel?.text = items[indexPath.row].getCreationDate().toString(dateFormat: "MM/DD/YYY")
        print(items[indexPath.row].getCreationDate())
        if items[indexPath.row].getIsComplete() == true {
            cell?.taskColorIndicatorView?.backgroundColor = .systemGreen
        }
        else {
            cell?.taskColorIndicatorView?.backgroundColor = .systemBlue
            
            //TO BE REPLACE - Due date and current date comparison
            if (indexPath.row == 2) {
                cell?.taskColorIndicatorView?.backgroundColor = .systemRed
            }
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, completionHandler) in
            print("a")
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = self.items[indexPath.row]
        
        if let taskDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "TaskDetailViewController") as? TaskDetailViewController {
            taskDetailViewController.task = task
            self.navigationController?.pushViewController(taskDetailViewController, animated: true)
        }
    }
}
