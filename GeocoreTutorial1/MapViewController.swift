//
//  ViewController.swift
//  GeocoreTutorial1
//
//  Created by Jati Wicaksono on 7/27/15.
//  Copyright (c) 2015 MapMotion. All rights reserved.
//

import UIKit
import MapKit
import PromiseKit
import GeocoreKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var selectedPlace: Place?
    var maxLat: Double?
    var minLat: Double?
    var maxLon: Double?
    var minLon: Double?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        var region: MKCoordinateRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(35.658581, 139.745433), MKCoordinateSpanMake(0.1, 0.1))
            
        self.mapView.setRegion(region, animated: true)
            
        self.mapView.delegate = self
        
        self.currentViewCoordinate()
    }

    func currentViewCoordinate() -> (maxLat: Double, minLat: Double, maxLon: Double, minLon: Double) {
        var currentRegion = mapView.region
        var currentCenterLatitude = currentRegion.center.latitude
        var currentCenterLongitude = currentRegion.center.longitude
        var currentLatitudeDelta = currentRegion.span.latitudeDelta
        var currentLongitudeDelta = currentRegion.span.longitudeDelta
        maxLat = currentCenterLatitude + (currentLatitudeDelta/2)
        minLat = currentCenterLatitude - (currentLatitudeDelta/2)
        maxLon = currentCenterLongitude + (currentLongitudeDelta/2)
        minLon = currentCenterLongitude - (currentLongitudeDelta/2)
        
        return (maxLat!, minLat!, maxLon!, minLon!)
    }
    
    func mapViewDidFinishLoadingMap(mapView: MKMapView){
        
        DataSource.sharedInstance.getData(minLat!, minLon: minLon!, maxLat: maxLat!, maxLon: maxLon!) .then { (places:[Place]) -> Void in
            
            for place in places {
                print("name = \(place.name), latitude = \(place.latitude), longitude = \(place.longitude)")
                
            }
            DataSource.sharedInstance.places = places
            self.mapView.addAnnotations(places)

        }
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.currentViewCoordinate()
        DataSource.sharedInstance.getData(minLat!, minLon: minLon!, maxLat: maxLat!, maxLon: maxLon!) .then { (places:[Place]) -> Void in
            
            for place in places {
                print("name = \(place.name), latitude = \(place.latitude), longitude = \(place.longitude)")
                
            }
            
            let annotationsToRemove = mapView.annotations
            mapView.removeAnnotations( annotationsToRemove )
            DataSource.sharedInstance.places = places
            self.mapView.addAnnotations(places)
            
        }
            
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? Place {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                
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
        if control == view.rightCalloutAccessoryView {
            self.selectedPlace = view.annotation as? Place
            performSegueWithIdentifier("showDetailsFromMap", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailsFromMap" {
            var detailsVC: DetailsViewController = segue.destinationViewController as! DetailsViewController
            
            var annotation: MKAnnotation!
    
            detailsVC.place = selectedPlace
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}