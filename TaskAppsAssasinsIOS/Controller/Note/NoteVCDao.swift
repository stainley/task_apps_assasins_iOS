//
//  NoteVCDao.swift
//  TaskAppsAssasinsIOS
//
//  Created by Jayesh Khistria on 2023-01-22.
//

import UIKit
import CoreData

extension NoteViewController {
    
    func saveNote() {
        do {
            try context.save()
            // reload collection of views
            
            print("Note had been saved")
            noteTableView.reloadData()
        } catch {
            print("Error saving category \(error.localizedDescription)")
        }
    }
    
    // Delete category from Database
    func deleteNote(noteEntity: NoteEntity) {
        print(noteEntity.title!)
        context.delete(noteEntity)
    }
    
    func loadImagesByNote(predicate: NSPredicate? = nil) {
        let request: NSFetchRequest<PictureEntity> = PictureEntity.fetchRequest()
       // let notePredicate = NSPredicate(format: "note_parent.title=%@", selectedCategory!.name!)

        request.predicate = predicate
        do {
            picturesEntity = try context.fetch(request)
            print("Search by pictures \(picturesEntity.count)")
        } catch {
            print("An error had ocurred: \(error.localizedDescription)")
        }
    }
    
    // TODO: Elvin
    func loadAudiosByNote(predicate: NSPredicate? = nil) {
        let request: NSFetchRequest<AudioEntity> = AudioEntity.fetchRequest()

        request.predicate = predicate
        do {
            audiosEntity = try context.fetch(request)
        } catch {
            print("An error had ocurred: \(error.localizedDescription)")
        }
    }
    
    
    func loadNotesByCategory(predicate: NSPredicate? = nil) -> Array<NoteEntity> {
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        let categoryPredicate = NSPredicate(format: "category_parent.name=%@", selectedCategory!.name!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error loading notes \(error.localizedDescription)")
        }
        return Array<NoteEntity>()
    }
}

