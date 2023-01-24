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
    var audios: [AVAudioRecorder]
    var latitude: Double?
    var longitude: Double?
    
    
    init(title: String, description: String,  audios: [AVAudioRecorder]) {
        self.title = title
        self.noteDescription = description
        self.audios = audios
    }
    
    mutating func setCoordinate(latitude: Double?, longitude: Double?) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
