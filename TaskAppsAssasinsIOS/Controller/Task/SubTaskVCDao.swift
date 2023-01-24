//
//  SubTaskVCDao.swift
//  TaskAppsAssasinsIOS
//
//  Created by Ann Robles on 1/23/23.
//

import Foundation

extension TaskDetailViewController {
    
    func saveSubTask() {
        do {
            try context.save()
            subTaskTableView.reloadData()
        } catch {
            print("Error saving category \(error.localizedDescription)")
        }
    }
}

