//
//  NoteVCDao.swift
//  TaskAppsAssasinsIOS
//
//  Created by Jayesh Khistria on 2023-01-22.
//

import Foundation
import CoreData

extension NoteViewController {
    
    func fetchAllNote(with request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest(), predicate: NSPredicate? = nil) {
        if let categorySelectedName = categorySelected!.name {
            let folderPredicate = NSPredicate(format: "category_parent.name=%@", categorySelectedName)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            if let addtionalPredicate = predicate {
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [folderPredicate, addtionalPredicate])
            } else {
                request.predicate = folderPredicate
            }

            do {
                filteredNotes = try context.fetch(request)
            } catch {
                print("Error loading notes \(error.localizedDescription)")
            }

            noteTableView?.reloadData()
        }
    }
    
    func deleteNote(note: NoteEntity) {
        context.delete(note)
    }
}

