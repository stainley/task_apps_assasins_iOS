//
//  Task.swift
//  TaskAppsAssasinsIOS
//
//  Created by Elvin Ross Fabella on 2023-01-15.
//

import UIKit

struct Task {
    
    var title: String?
    var description: String?
    var dueDate: NSDate?
    var dateCompleted: NSDate?
    var isComplete: Bool?
    var image: Data!
    var pictures: [Data] = []
    var audios: [String] = []
    
    private (set) var latitude: Double?
    private (set) var longitude: Double?
    
    
    init(title: String? = nil, description: String? = nil, isComplete: Bool = false) {
        self.title = title
        self.description = description
        self.isComplete = isComplete
        
    }
    
    mutating func setCoordinate(latitude: Double?, longitude: Double?) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
