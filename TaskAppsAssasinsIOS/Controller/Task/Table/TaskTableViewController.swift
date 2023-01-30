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
        var isAllSubtaskCompleted = true
        
        cell.taskCheckmarkImage.image = UIImage(systemName: "checkmark.square")
        cell.titleLabel.text = filteredTasks[indexPath.row].title
        
        if let creation = filteredTasks[indexPath.row].creationDate {
            cell.creationDateLabel?.text = "Created: \(creation.toString(dateFormat: "MMMM dd, yyyy 'on' h:mm:ss a"))"
        }
        
        if let subtasks = filteredTasks[indexPath.row].subtasks {
            if (subtasks.count > 0) {
                for subtask in subtasks {
                    if (subtask as! SubTaskEntity).status == false {
                        isAllSubtaskCompleted = false
                        cell.taskCheckmarkImage?.image = UIImage(systemName: "square")
                    }
                }
            }
            else {
                cell.taskCheckmarkImage?.image = UIImage(systemName: "square")
            }
        }

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
        
        var totalSubtaskCompleted = 0
        var actions: [UIContextualAction] = [UIContextualAction]()
        
        if let subtasks = filteredTasks[indexPath.row].subtasks {
            for subtask in subtasks {
                if (subtask as! SubTaskEntity).status == true {
                    totalSubtaskCompleted += 1
                }
            }
            
            if totalSubtaskCompleted == filteredTasks[indexPath.row].subtasks?.count {
                let deleteAction = UIContextualAction(style: .destructive, title: nil, handler: {(action, view, completionHandler) in
                    let alertController = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .actionSheet)
                   
                             
                    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] action in
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
                actions.append(deleteAction)
            }
        }
        
        let  preventSwipe = UISwipeActionsConfiguration(actions: actions)
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
            guard let taskTitle = task.title else {
                return
            }
            let byParent  =  NSPredicate(format: "task_parent.title == %@", taskTitle)
            taskDetailViewController.pictureEntities = loadImagesByTask(predicate: byParent)
            
            for pic in picturesEntity {
                taskDetailViewController.pictures.append(UIImage(data: pic.picture!)!)
            }
            
            loadAudiosByTask(predicate: byParent)
            for audio in audiosEntity {
                taskDetailViewController.audioPath.append(audio.audioPath!)
            }
            
            self.navigationController?.pushViewController(taskDetailViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let changeCategoryMenu = ChangeCategoryMenu()
        changeCategoryMenu.taskViewControllerDelegate = self
        changeCategoryMenu.categories = self.fetchAllCategory()
        changeCategoryMenu.taskToChange = self.filteredTasks[indexPath.row]
        
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider:  { _ -> UIMenu? in
            
            let menu = UIMenu(title: "Chance Category", image: UIImage(systemName: "pencil.circle") ,children: changeCategoryMenu.categoryOptions())
            return menu
        })
        return config
        
        
    }
}
