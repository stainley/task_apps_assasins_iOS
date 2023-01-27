//
//  TaskTableViewController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-26.
//

import UIKit

extension TaskDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subTasksEntity.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = subTaskTableView.dequeueReusableCell(withIdentifier: "subTaskTableViewCell", for: indexPath) as! SubTaskTableViewCell
       /*
        if cell.isCompleteButton.isSelected {
            cell.isCompleteButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        } else {
            cell.isCompleteButton.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        }
        */
        //cell.isCompleteButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        cell.isCompleteButton.isSelected = subTasksEntity[indexPath.row].status
        cell.subtask = subTasksEntity[indexPath.row]
        cell.subTaskTitleLabel?.text = subTasksEntity[indexPath.row].title
        cell.datePickerButton?.setTitle(subTasksEntity[indexPath.row].dueDate?.toString(dateFormat: "MM/DD/YYY hh:mm:ss"), for: .normal)
        //cell?.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, completionHandler) in
            
            //Remove contact from DB
        
            self.delegate?.deleteSubTask(subTaskEntity: self.subTasksEntity[indexPath.row])
            //self.saveTask()
            self.delegate?.saveTask()
   
            self.subTasksEntity.remove(at: indexPath.row)
            
            self.subTaskTableView.deleteRows(at: [indexPath], with: .fade)
            self.subTaskTableView.endUpdates()
            
            self.subTaskTableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let subtask = self.subTasksEntity[indexPath.row]
        
        
    }
    

}
