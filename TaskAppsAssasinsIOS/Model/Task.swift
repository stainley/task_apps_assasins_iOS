//
//  Task.swift
//  TaskAppsAssasinsIOS
//
//  Created by Elvin Ross Fabella on 2023-01-15.
//

import UIKit

struct Task {
    
    private (set) var title: String
    let description: String?
    let creationDate: NSDate
    let dueDate: NSDate
    let dateCompleted: NSDate?
    var isComplete: Bool?
    var image: Data!
    var pictures: [Data] = []
    var audios: [String] = []
    
    private (set) var latitude: Double?
    private (set) var longitude: Double?
    
    
    init(title: String, description: String, creationDate: NSDate, dueDate: NSDate, dateCompleted: NSDate, pictures: [UIImage?], audios: [String?], isComplete: Bool) {
        self.title = title
        self.description = description
        self.creationDate = creationDate
        self.dueDate = dueDate
        self.dateCompleted = dateCompleted
        self.isComplete = isComplete
    }
    
    mutating func setCoordinate(latitude: Double?, longitude: Double?) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
