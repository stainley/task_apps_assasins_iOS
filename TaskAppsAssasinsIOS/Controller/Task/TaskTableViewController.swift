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
        var totalSubtaskCompleted = 0
        
        cell.titleLabel.text = filteredTasks[indexPath.row].title
        
        if let creation = filteredTasks[indexPath.row].creationDate {
            cell.creationDateLabel?.text = "Created: \(creation.toString(dateFormat: "MMMM dd, yyyy 'on' h:mm:ss a"))"
        }
    
        // DUE DATE TASK is the last due date from subtask
        //print("\(tasks[indexPath.row].title) \(tasks[indexPath.row].taskDueDate)")
        
        if let dueDate =  tasks[indexPath.row].taskDueDate {
            if filteredTasks[indexPath.row].subtasks?.count == 0 {
                cell.dueDateLabel.text = "Due: \(dueDate.toString(dateFormat: "MMMM dd, yyyy 'on' h:mm:ss a"))"
            }
            else {
                let lastDate = getSubTaskDueDate(predicate: NSPredicate(format: "task_parent.title=%@", filteredTasks[indexPath.row].title!))
                
                if lastDate != nil {
                    cell.dueDateLabel.text = "Due: \(lastDate!.toString(dateFormat: "MMMM dd, yyyy 'on' h:mm:ss a"))"
                    
                    if tasks[indexPath.row].isCompleted == true {
                        cell.taskColorIndicatorView?.backgroundColor = .systemGreen
                    }
                    else {
                        cell.taskColorIndicatorView?.backgroundColor = .systemBlue
                        
                        if (lastDate!.timeIntervalSinceNow.sign == .minus) {
                            cell.taskColorIndicatorView?.backgroundColor = .systemRed
                        }
                    }
                }
            }
        }
        
        if let subtasks = filteredTasks[indexPath.row].subtasks {
            for subtask in subtasks {
                if (subtask as! SubTaskEntity).status == true {
                    totalSubtaskCompleted += 1
                }
            }
            
            if filteredTasks[indexPath.row].subtasks?.count == 0 {
                cell.completedCounterLabel.text = ""
            }
            else {
                cell.completedCounterLabel.text = "\(totalSubtaskCompleted)/\(filteredTasks[indexPath.row].subtasks?.count ?? 0)"
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
