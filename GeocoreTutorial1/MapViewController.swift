//
//  ViewController.swift
//  GeocoreTutorial1
//
//  Created by Jati Wicaksono on 7/27/15.
//  Copyright (c) 2015 MapMotion. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var maxLatitude: CLLocationDegrees = -90
        var minLatitude: CLLocationDegrees = 90
        var sumLatitude: CLLocationDegrees = 0
        var maxLongitude: CLLocationDegrees = -180
        var minLongitude: CLLocationDegrees = 180
        var sumLongitude: CLLocationDegrees = 0
        
        for place in DataSource.sharedInstance.places {
            if place.latitude > maxLatitude {
                maxLatitude = place.latitude
            } else if place.latitude < minLatitude {
                minLatitude = place.latitude
            }
            
            if place.longitude > maxLongitude {
                maxLongitude = place.longitude
            } else if place.longitude < minLongitude {
                minLongitude = place.longitude
            }
            
            sumLatitude += place.latitude
            sumLongitude += place.longitude
 
            
        }
        
        let numberOfPlaces = Double(DataSource.sharedInstance.places.count)
        
        var region: MKCoordinateRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(sumLatitude/numberOfPlaces, sumLongitude/numberOfPlaces), MKCoordinateSpanMake((maxLatitude - minLatitude)*3, (maxLongitude - minLongitude)*3))
        
        mapView.setRegion(region, animated: true)
        
        mapView.addAnnotations(DataSource.sharedInstance.places)
        
        mapView.delegate = self
        
    }

    
    
    func setCenterCoordinate(coordinate: CLLocationCoordinate2D ,
        animated: Bool){
        var centerCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
          
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? Place {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
            }
            
            view.pinColor = annotation.pinColor()
            
            return view
        }
        return nil
    }
    
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let location = view.annotation as! Place
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}