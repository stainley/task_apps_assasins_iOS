//
//  NoteDeailVCDao.swift
//  TaskAppsAssasinsIOS
//
//  Created by Ann Robles on 1/24/23.
//

import Foundation

extension NoteDetailViewController {
    
    func saveNote() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error.localizedDescription)")
        }
    }
}

