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
        
        cell.subtask = subTasksEntity[indexPath.row]
        cell.subTaskTitleLabel?.text = subTasksEntity[indexPath.row].title
        cell.datePickerButton?.setTitle(subTasksEntity[indexPath.row].dueDate?.toString(dateFormat: "MM/DD/YYY"), for: .normal)
        //cell?.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, completionHandler) in
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let subtask = self.subTasksEntity[indexPath.row]
        
        
    }
}

/*
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
*/
