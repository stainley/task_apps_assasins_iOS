//
//  TaskVCDao.swift
//  TaskAppsAssasinsIOS
//
//  Created by Ann Robles on 1/23/23.
//

import Foundation

extension TaskDetailViewController {
    
    func saveTask() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error.localizedDescription)")
        }
    }
}
