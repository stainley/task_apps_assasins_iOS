//
//  TaskTableViewController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-26.
//

import UIKit

extension TaskDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == audioTableView {
          return audioPath.count
        } else {
          return subTasksEntity.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == audioTableView {
            let audioPlayerCell = tableView.dequeueReusableCell(withIdentifier: "audioPlayerCell", for: indexPath) as! AudioCustomTableViewCell
        
            // number of audio
            audioPlayerCell.audioIndexLabel.text = "\(indexPath.row + 1)"
            let audioTime = audioPlayerCell.audioLongLabel
            
            let scrubble = audioPlayerCell.scrubber
            scrubble?.value = 0
            let play = audioPlayerCell.audioPlayButton

            play!.tag = indexPath.row
            play!.addTarget(self, action: #selector(playAudio(_ : )), for: .touchDown)
            audioPlayButton.append(play!)
            scrubber.append(scrubble!)
            
            audioTimeLabel.append(audioTime!)
            return audioPlayerCell
        } else {
            let cell = subTaskTableView.dequeueReusableCell(withIdentifier: "subTaskTableViewCell", for: indexPath) as! SubTaskTableViewCell
           
            if subTasksEntity[indexPath.row].status {
                cell.checkmarkImage?.image = UIImage(systemName: "checkmark.square")
            } else {
                cell.checkmarkImage?.image = UIImage(systemName: "square")
            }
            
            cell.isCompleteButton.isSelected = subTasksEntity[indexPath.row].status
            cell.subtask = subTasksEntity[indexPath.row]
            cell.subTaskTitleLabel?.text = subTasksEntity[indexPath.row].title
            cell.datePickerButton?.setTitle(subTasksEntity[indexPath.row].dueDate?.toString(dateFormat: "MM/DD/YYY hh:mm:ss"), for: .normal)
            
            cell.cellIndex = indexPath.row
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == audioTableView {
            let deleteAction = UIContextualAction(style: .destructive, title: nil, handler: {(action, view, completionHandler) in
                let alertController = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .actionSheet)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    tableView.beginUpdates()
                    self.deleteAudio(audioPath: self.audioPath[indexPath.row])
                    self.audioPath.remove(at: indexPath.row)
                    self.audioTableView.deleteRows(at: [indexPath], with: .fade)
                    self.audioTableView.endUpdates()
                    self.audioTableView.reloadData()
                    
                    self.taskDueDatePicker.isHidden = false
                    self.taskDueDatePicker.isEnabled = true
                }))
                self.present(alertController, animated: true)
                completionHandler(true)
            })
            deleteAction.image = UIImage(systemName: "trash")
            let  preventSwipe = UISwipeActionsConfiguration(actions: [deleteAction])
            preventSwipe.performsFirstActionWithFullSwipe = false
            return preventSwipe
        }
        else {
            let action = UIContextualAction(style: .destructive, title: "Delete") {
                (action, view, completionHandler) in
            
                self.delegate?.deleteSubTask(subTaskEntity: self.subTasksEntity[indexPath.row])
                self.delegate?.saveTask()
       
                self.subTasksEntity.remove(at: indexPath.row)
                
                self.subTaskTableView.deleteRows(at: [indexPath], with: .fade)
                self.subTaskTableView.endUpdates()
                
                self.subTaskTableView.reloadData()
            }
            
            return UISwipeActionsConfiguration(actions: [action])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension TaskDetailViewController: SubTaskTableViewCellDelegate {
    func updateSubTaskStatus(index: Int, status: Bool) {
        self.subTasksEntity[index].status = status
        self.delegate?.saveTask()
    }
}
