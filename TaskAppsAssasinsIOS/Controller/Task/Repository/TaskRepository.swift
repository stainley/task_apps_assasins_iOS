//
//  TaskRepository.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-26.
//

import Foundation
import CoreData
import UIKit

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
    
    func changeTaskCategory(taskEntity: TaskEntity, for categoryEntity: CategoryEntity) {
        
        taskEntity.category_parent = categoryEntity
        saveTask()
        filteredTasks = loadTasksByCategory()
        taskTableView.reloadData()
    }
    
    
    // TODO: Elvin
    func saveTask(task: Task, oldTaskEntity: TaskEntity? = nil, newPictures: [UIImage], newAudioPath: [String]) {
        
        // Title must be required.
        if task.title == "" || task.title.isEmpty || (oldTaskEntity != nil && oldTaskEntity?.title == nil) {
            return
        }
        
        if let oldTask = oldTaskEntity {
            updateTask(updatedTask: task, oldTask: oldTask, newPictures: newPictures, newAudioPath: newAudioPath)
            return
        }
        
        let newTask = TaskEntity(context: context)
        newTask.title = task.title
        newTask.taskDescription = task.description
        newTask.creationDate = Date()
        newTask.taskDueDate = task.dueDate

        // TODO: Save image to the Database
        for picture in task.pictures {
            let pictureEntity = PictureEntity(context: context)

            pictureEntity.picture = picture
            pictureEntity.task_parent = newTask
            newTask.addToPictures(pictureEntity)
        }
        
        // TODO: Save audio into the Database
        for audio in task.audios {
            let audioEntity = AudioEntity(context: context)
            audioEntity.audioPath = audio
            audioEntity.task_parent = newTask
            newTask.addToAudios(audioEntity)
        }
        
        // TODO: Save coordinate to the database
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
    
    func updateTask(updatedTask: Task, oldTask: TaskEntity, newPictures: [UIImage], newAudioPath: [String]) {
        oldTask.title = updatedTask.title
        
        if let dateCompleted = updatedTask.dateCompleted, let isCompleted = updatedTask.isComplete {
            oldTask.dateCompleted = dateCompleted as Date
            oldTask.isCompleted = isCompleted
        }
        oldTask.taskDueDate = updatedTask.dueDate
        if updatedTask.subTasks.count > 0 {
           
            updateSubTask(parentTask: oldTask, newSubTasks:  updatedTask.subTasks)
            print("Subtask Updated")
        }
        
        saveTask()
        taskTableView.reloadData()
    }
    
    // GET LAST DUE DATE FROM AN ARRAY OF CHILD TASK
    func getSubTaskDueDate(predicate: NSPredicate?) -> Date? {
        let request: NSFetchRequest<SubTaskEntity> = SubTaskEntity.fetchRequest()
        var subtasksEntities: [SubTaskEntity] = []
        request.predicate = predicate
        do {
            try subtasksEntities = context.fetch(request)
            
            let dueDateInfo = subtasksEntities.map({ $0.dueDate})
            
            if dueDateInfo.count > 1 {
                
                let lastDate = dueDateInfo.sorted(by: { (date1, date2) -> Bool in
                    if let date1 = date1, let date2 = date2 {
                        return date1 > date2
                    }
                    return false
                })[0]
                print(lastDate!)
                return lastDate
            }
            else {
                let lastDate = dueDateInfo[0]
                return lastDate
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
