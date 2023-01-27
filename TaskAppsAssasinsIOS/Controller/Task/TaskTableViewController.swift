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

        //print(filteredTasks[indexPath.row].title!)
        
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
        
        let action = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, completionHandler) in
            // TODO: implement functionality t

        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = self.filteredTasks[indexPath.row]
        
        if let taskDetailViewController = self.storyboard!.instantiateViewController(withIdentifier: "taskDetailStoryboardID") as? TaskDetailViewController {
            taskDetailViewController.delegate = self
            taskDetailViewController.task = task
        
            subTasks = loadSubTasksByTask(title: tasks[indexPath.row].title ?? "")
            print(subTasks.count)
            taskDetailViewController.subTasksEntity = subTasks
            //self.storyboard?.instantiateViewController(withIdentifier: "taskDetailStoryboardID")
            self.navigationController?.pushViewController(taskDetailViewController, animated: true)
            //self.show(taskDetailViewController, sender: self)
        }
    }
}
