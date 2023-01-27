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
    
    
    
    func fetchAllCategory() -> Array<CategoryEntity> {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error loading categories \(error.localizedDescription)")
        }
        
        return Array<CategoryEntity>()
    }
    
    // TODO: Elvin
    func saveTask(task: Task, oldTaskEntity: TaskEntity? = nil) {
        
        // Title must be required.
        if task.title.isEmpty {
            guard let oldTask = oldTaskEntity else { return }
            if oldTask.title!.isEmpty {
                return
            }
            return
        }
        
        if task.subTasks.count > 0 {
            guard let oldTaskEntity = oldTaskEntity else { return }
            // UPDATE NOT SAVE
            updateTask(updatedTask: task, oldTask: oldTaskEntity)
            return
        }
        
        let newTask = TaskEntity(context: context)
     
        newTask.title = task.title
        newTask.taskDescription = task.description
        newTask.creationDate = Date()
        // Save image to the Database
        
        for picture in task.pictures {
            let pictureEntity = PictureEntity(context: context)

            pictureEntity.picture = picture
            pictureEntity.task_parent = newTask
            newTask.addToPictures(pictureEntity)
        }
        
        // Save audio into the Database
        for audio in task.audios {
            let audioEntity = AudioEntity(context: context)
            audioEntity.audioPath = audio
            audioEntity.task_parent = newTask
            newTask.addToAudios(audioEntity)
        }
        
        // Save coordinate to the database
        if let latitude = task.latitude, let longitude = task.longitude {
            newTask.longitude = latitude
            newTask.longitude = longitude
        }
        
        
        // TODO: save all subtask before the task
        if task.subTasks.count > 0 {
            addSubTask(parentTask: newTask, subTasks: task.subTasks)
        }
        
        
        newTask.category_parent = selectedCategory
        saveTask()
        tasks = loadTasksByCategory()
        
        filteredTasks = tasks
        taskTableView.reloadData()
    }
    
    func updateTask(updatedTask: Task, oldTask: TaskEntity) {
        oldTask.title = updatedTask.title
        
        if let dateCompleted = updatedTask.dateCompleted, let isCompleted = updatedTask.isComplete {
            oldTask.dateCompleted = dateCompleted as Date
            oldTask.isCompleted = isCompleted
        }
        
        // TODO: save all subtask before the task
        /*if task.subTasks.count > 0 {
            addSubTask(parentTask: newTask, subTasks: task.subTasks)
         }*/
        
        if updatedTask.subTasks.count > 0 {
            print("SUBTASK TO BE UPDATED")
           
            updateSubTask(parentTask: oldTask, newSubTasks:  updatedTask.subTasks)
            
        }
        
      
        
        saveTask()
        taskTableView.reloadData()
    }
    
}
