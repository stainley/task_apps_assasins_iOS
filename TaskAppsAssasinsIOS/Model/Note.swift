//
//  Note.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-12.
//

import UIKit
import AVFAudio

struct Note {
    
    var title: String
    var noteDescription: String?
    var image: Data!
    var pictures: [Data] = []
    var audios: [String] = []
    
    private (set) var latitude: Double?
    private (set) var longitude: Double?
    
    
    init(title: String, description: String) {
        self.title = title
        self.noteDescription = description
    }
    
    mutating func setCoordinate(latitude: Double?, longitude: Double?) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
