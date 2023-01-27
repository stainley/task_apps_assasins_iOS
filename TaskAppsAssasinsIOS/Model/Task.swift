//
//  Task.swift
//  TaskAppsAssasinsIOS
//
//  Created by Elvin Ross Fabella on 2023-01-15.
//

import UIKit

struct Task {
    
    let title: String
    var description: String?
    var dueDate: Date?
    var dateCompleted: NSDate?
    var isComplete: Bool?
    var image: Data!
    var pictures: [Data] = []
    var audios: [String] = []
    var subTasks: [SubTaskEntity] = []
    
    private (set) var latitude: Double?
    private (set) var longitude: Double?
    
    
    init(title: String, description: String? = nil, isComplete: Bool = false) {
        self.description = description
        self.isComplete = isComplete
        self.title = title
    }
    
    mutating func setCoordinate(latitude: Double?, longitude: Double?) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
