//
//  Note.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-12.
//

import UIKit

struct Note {
    
    private var title: String?
    private var description: String?
    private var creationDate: NSDate
    private var pictures: [UIImage?]
    private var audios: [String?]
    private var latitude: Double?
    private var longitude: Double?
    
    
    init(title: String, description: String, creationDate: NSDate, pictures: [UIImage?], audios: [String?]) {
        self.title = title
        self.description = description
        self.creationDate = creationDate
        self.pictures = pictures
        self.audios = audios
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
    
    func getPictures() -> [UIImage?] {
        return self.pictures
    }
    
    func getAudios() -> [String?] {
        return self.audios
    }
    
    mutating func setCoordinate(latitude: Double?, longitude: Double?) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
