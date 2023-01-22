//
//  NoteVCDao.swift
//  TaskAppsAssasinsIOS
//
//  Created by Jayesh Khistria on 2023-01-22.
//

import Foundation

extension NoteViewController {
    
    func saveNote() {
        do {
            try context.save()
            // reload collection of views
            noteTableView.reloadData()
        } catch {
            print("Error saving category \(error.localizedDescription)")
        }
    }
}
