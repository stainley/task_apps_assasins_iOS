//
//  TaskRepository.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-26.
//

import Foundation
import CoreData

extension TaskViewController {
 
    func saveTask() {
        do {
            try context.save()
            // reload collection of views
            
            print("Task had been saved")
            taskTableView.reloadData()
        } catch {
            print("Error saving task \(error.localizedDescription)")
        }
    }
    
    // Delete task from Database
    func deleteTask(taskEntity: TaskEntity) {
        print(taskEntity.title!)
        context.delete(taskEntity)
    }
    
    func loadImagesByTask(predicate: NSPredicate? = nil) {
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
    func loadAudiosByTask(predicate: NSPredicate? = nil) {
        let request: NSFetchRequest<AudioEntity> = AudioEntity.fetchRequest()

        request.predicate = predicate
        do {
            audiosEntity = try context.fetch(request)
        } catch {
            print("An error had ocurred: \(error.localizedDescription)")
        }
    }
    
    
    // Load all tasks by category
    func loadTasksByCategory(predicate: NSPredicate? = nil) -> Array<TaskEntity> {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
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
        return Array<TaskEntity>()
    }
    
    // Load all subtasks
    func loadSubTasksByTask(predicate: NSPredicate? = nil) -> Array<SubTaskEntity> {
        let request: NSFetchRequest<SubTaskEntity> = SubTaskEntity.fetchRequest()
        let categoryPredicate = NSPredicate(format: "category_parent.name=%@", selectedCategory!.name!)
        
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
        
        return Array<SubTaskEntity>()
    }
}
