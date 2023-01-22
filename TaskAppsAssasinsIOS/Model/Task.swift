//
//  Task.swift
//  TaskAppsAssasinsIOS
//
//  Created by Elvin Ross Fabella on 2023-01-15.
//

import UIKit

struct Task {
    
    var title: String
    private var description: String?
    private var creationDate: NSDate
    private var dueDate: NSDate
    private var dateCompleted: NSDate?
    private var pictures: [UIImage?]
    private var audios: [String?]
    private var isComplete: Bool?
    
    init(title: String, description: String, creationDate: NSDate, dueDate: NSDate, dateCompleted: NSDate, pictures: [UIImage?], audios: [String?], isComplete: Bool) {
        self.title = title
        self.description = description
        self.creationDate = creationDate
        self.dueDate = dueDate
        self.dateCompleted = dateCompleted
        self.pictures = pictures
        self.audios = audios
        self.isComplete = isComplete
    }
    
    func getTitle() -> String? {
        return self.title
    }
    
    func getDescription() -> String? {
        return self.description
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
    
    func getPictures() -> [UIImage?] {
        return self.pictures
    }
    
    func getAudios() -> [String?] {
        return self.audios
    }
    
}
