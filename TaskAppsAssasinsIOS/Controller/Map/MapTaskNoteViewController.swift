//
//  MapTaskNoteViewController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-24.
//

import UIKit
import MapKit

class MapTaskNoteViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    
    var coordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        
        map.isZoomEnabled = false
        map.showsUserLocation = true
        
        map.delegate = self
        
        if let coordinate = coordinate {
            displayNoteLocaiton(title: "Note", latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
        
    }
    
    
    func displayNoteLocaiton(title: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let latitudeDelta: CLLocationDegrees = 0.7
        let longitudeDelta: CLLocationDegrees = 0.7
        
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        
        map.setRegion(region, animated: true)
    }
}


extension MapTaskNoteViewController: MKMapViewDelegate {
    
}
