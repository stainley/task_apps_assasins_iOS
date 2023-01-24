//
//  SubTask.swift
//  TaskAppsAssasinsIOS
//
//  Created by Ann Robles on 1/23/23.
//

import Foundation

struct SubTask {
    
    var title: String
    private var parentId: Int
    private var creationDate: NSDate
    private var dueDate: NSDate
    private var dateCompleted: NSDate?
    private var isComplete: Bool?
    
    init(title: String, parentId: Int, creationDate: NSDate, dueDate: NSDate, dateCompleted: NSDate? = nil, isComplete: Bool? = nil) {
        self.title = title
        self.parentId = parentId
        self.creationDate = creationDate
        self.dueDate = dueDate
        self.dateCompleted = dateCompleted
        self.isComplete = isComplete
    }
    
    func getTitle() -> String? {
        return self.title
    }
    
    func getParentId() -> Int {
        return self.parentId
    }
    
    func getCreationDate() -> NSDate {
        return self.creationDate
    }
    
    func getDueDate() -> NSDate {
        return self.dueDate
    }
    
    func getDateCompleted() -> NSDate? {
        return self.dateCompleted
    }
    
    func getIsComplete() -> Bool? {
        return self.isComplete
    }
}
