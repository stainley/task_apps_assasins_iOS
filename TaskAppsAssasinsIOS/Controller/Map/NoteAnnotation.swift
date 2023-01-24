//
//  MKNoteAnnotation.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-24.
//

import Foundation
import MapKit

class NoteAnnotation: NSObject, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var image: UIImage?
    
    init(title: String? = nil, coordinate: CLLocationCoordinate2D, image: UIImage? = nil) {
        self.title = title
        self.coordinate = coordinate
        self.image = image
    }
}

