//
//  TaskTableViewController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-26.
//

import UIKit


extension TaskViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(filteredTasks.count)
        return filteredTasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskTableView.dequeueReusableCell(withIdentifier: "taskViewCell", for: indexPath) as! TaskNibTableViewCell
        
        cell.titleLabel.text = filteredTasks[indexPath.row].title
        cell.creationDateLabel.text = "\(filteredTasks[indexPath.row].creationDate!)"
        
        print(tasks[indexPath.row].creationDate!)
        
        if tasks[indexPath.row].isCompleted == true {
            cell.taskColorIndicatorView?.backgroundColor = .systemGreen
        }
        else {
            cell.taskColorIndicatorView?.backgroundColor = .systemBlue
            
            //TO BE REPLACE - Due date and current date comparison
            if (indexPath.row == 2) {
                cell.taskColorIndicatorView?.backgroundColor = .systemRed
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil, handler: {(action, view, completionHandler) in
            let alertController = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .actionSheet)
           
                     
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                tableView.beginUpdates()
                //Remove contact from DB
                self.deleteTask(taskEntity: self.filteredTasks[indexPath.row])
                self.saveTask()
                
                self.filteredTasks.remove(at: indexPath.row)
                self.tasks.remove(at: indexPath.row)
            
                self.taskTableView.deleteRows(at: [indexPath], with: .fade)
                self.taskTableView.endUpdates()
                
                self.taskTableView.reloadData()
            }))
            self.present(alertController, animated: true)
            completionHandler(true)
        })
              
        deleteAction.image = UIImage(systemName: "trash")
        
        let edit = UIContextualAction(style: .normal, title: "Edit", handler: {(action, view, completionHandler) in
            // TODO: Implement Change Category
            
            completionHandler(true)
        })
        edit.backgroundColor = UIColor.systemBlue
        edit.image = UIImage(systemName: "square.and.pencil")
        
        let  preventSwipe = UISwipeActionsConfiguration(actions: [deleteAction, edit])
        preventSwipe.performsFirstActionWithFullSwipe = false
        return preventSwipe
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = self.filteredTasks[indexPath.row]
        
        if let taskDetailViewController = self.storyboard!.instantiateViewController(withIdentifier: "taskDetailStoryboardID") as? TaskDetailViewController {
            taskDetailViewController.delegate = self
            taskDetailViewController.task = task
        
            subTasks = loadSubTasksByTask(title: tasks[indexPath.row].title ?? "")
            taskDetailViewController.subTasksEntity = subTasks
            
            self.navigationController?.pushViewController(taskDetailViewController, animated: true)
        }
    }
}
