//
//  SubTaskRepository.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-26.
//

import CoreData

extension TaskViewController {
    
    func saveSubTask() {
        do {
            try context.save()
            
            print("SubTask had been saved")
            taskTableView.reloadData()
        } catch {
            print("Error saving task \(error.localizedDescription)")
        }
    }
    
    // Save all subtasks
    func addSubTask(parentTask: TaskEntity, subTasks: [SubTaskEntity]) {
              
        for subTask in subTasks {
            let newSubTask = SubTaskEntity(context: context)
            newSubTask.title = subTask.title
            newSubTask.dueDate = subTask.dueDate
            newSubTask.creationDate = Date()
            newSubTask.task_parent = parentTask
            saveSubTask()
        }
    }
    
    func updateSubTask(parentTask: TaskEntity, newSubTasks: [SubTaskEntity]) {
        
        for sbTask in newSubTasks {
            sbTask.task_parent = parentTask
            saveSubTask()
        }
    }
    
    // MARK: Delete task from Database
    func deleteSubTask(subTaskEntity: SubTaskEntity) {
        print(subTaskEntity.title!)
        context.delete(subTaskEntity)
    }
    
    // Load all subtasks
    func loadSubTasksByTask(predicate: NSPredicate? = nil, title: String) -> Array<SubTaskEntity> {
        let request: NSFetchRequest<SubTaskEntity> = SubTaskEntity.fetchRequest()
        let taskPredicate = NSPredicate(format: "task_parent.title=%@", title)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [taskPredicate, additionalPredicate])
        } else {
            request.predicate = taskPredicate
        }
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error loading notes \(error.localizedDescription)")
        }
        
        return Array<SubTaskEntity>()
    }
   
}
