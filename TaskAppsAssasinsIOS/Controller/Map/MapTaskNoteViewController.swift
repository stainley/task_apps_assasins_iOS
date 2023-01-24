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
        
        let noteAnnotation = NoteAnnotation(coordinate: location)
        noteAnnotation.title = "Note"
        map.addAnnotation(noteAnnotation)
        
        map.setRegion(region, animated: true)
        
    }
}

extension MapTaskNoteViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKMarkerAnnotationView {
            return nil
        }
                
        var annotationView: MKAnnotationView?
        if let annotation = annotation as? NoteAnnotation {
            annotationView = setupCustomAnnotationView(for: annotation, on: map)
        }

        return annotationView
    }
    
    private func setupCustomAnnotationView(for annotation: NoteAnnotation, on mapView: MKMapView) -> MKAnnotationView {

        let flagAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        //flagAnnotationView.glyphImage = UIImage(named: "notes")
        flagAnnotationView.canShowCallout = true
        flagAnnotationView.markerTintColor=UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0,alpha:0.5).withAlphaComponent(0)
        // Provide the left image icon for the annotation.
        flagAnnotationView.image = UIImage(named: "notes")
        flagAnnotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        return flagAnnotationView
    }
}
