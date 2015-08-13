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
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBAction func currentLocationButton(sender: AnyObject) {
        
        let currentViewCenterCoordinate = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude)
        
        mapView.setRegion(MKCoordinateRegionMake(currentViewCenterCoordinate, MKCoordinateSpanMake(0.1, 0.1)), animated: true)
    }
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var firstView: Bool = true
    var selectedPlace: Place?
    /*
    var maxLat: Double?
    var minLat: Double?
    var maxLon: Double?
    var minLon: Double?
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.startUpdatingLocation()
        
        self.mapView.delegate = self
        
        self.currentViewCoordinate()
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        
        let location = locations[0] as! CLLocation
        let currentViewCenterCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        println("location manager: did update location \(location.coordinate.latitude), \(location.coordinate.longitude)")
        
        if firstView == true {
            mapView.setRegion(MKCoordinateRegionMake(currentViewCenterCoordinate, MKCoordinateSpanMake(0.1, 0.1)), animated: true)
            
            firstView = false
        }
        
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("location manager: failed with error: \(error)")
    }
    

    func currentViewCoordinate() -> (maxLat: Double, minLat: Double, maxLon: Double, minLon: Double) {
        let currentRegion = mapView.region
        let currentCenterLatitude = currentRegion.center.latitude
        let currentCenterLongitude = currentRegion.center.longitude
        let currentLatitudeDelta = currentRegion.span.latitudeDelta
        let currentLongitudeDelta = currentRegion.span.longitudeDelta
        /*
        maxLat = currentCenterLatitude + (currentLatitudeDelta/2)
        minLat = currentCenterLatitude - (currentLatitudeDelta/2)
        maxLon = currentCenterLongitude + (currentLongitudeDelta/2)
        minLon = currentCenterLongitude - (currentLongitudeDelta/2)
        */
        return (
            currentCenterLatitude + (currentLatitudeDelta/2),
            currentCenterLatitude - (currentLatitudeDelta/2),
            currentCenterLongitude + (currentLongitudeDelta/2),
            currentCenterLongitude - (currentLongitudeDelta/2)
        )
    }
    
    func mapViewDidFinishLoadingMap(mapView: MKMapView!) {
        
        let (maxLat, minLat, maxLon, minLon) = currentViewCoordinate()
        
        DataSource.sharedInstance.getData(minLat, minLon: minLon, maxLat: maxLat, maxLon: maxLon) .then { (places:[Place]) -> Void in
            
            self.mapView.addAnnotations(places)

        }
    }
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        
        let (maxLat, minLat, maxLon, minLon) = currentViewCoordinate()
        
        DataSource.sharedInstance.getData(minLat, minLon: minLon, maxLat: maxLat, maxLon: maxLon) .then { (places:[Place]) -> Void in
            
            let annotationsToRemove = mapView.annotations
            mapView.removeAnnotations( annotationsToRemove )
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
                view.calloutOffset = CGPoint(x: -8, y: 2)
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