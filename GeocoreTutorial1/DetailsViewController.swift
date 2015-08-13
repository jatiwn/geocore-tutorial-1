//
//  DetailsViewController.swift
//  GeocoreTutorial1
//
//  Created by Jati Wicaksono on 8/3/15.
//  Copyright (c) 2015 MapMotion. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailsViewController: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {


    @IBOutlet weak var detailsMapView: MKMapView!
    @IBOutlet weak var detailsTableView: UITableView!
    
    var place: Place?
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var region: MKCoordinateRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(place!.latitude, place!.longitude), MKCoordinateSpanMake(0.01, 0.01))
        
        detailsMapView.setRegion(region, animated: true)
        
        detailsMapView.addAnnotation(place!)
        detailsMapView.delegate = self
        
        detailsTableView.dataSource = self
        detailsTableView.delegate = self
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        
        CLLocationManager.locationServicesEnabled()
        
        self.locationManager.startUpdatingLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
                
            }
            
            view.pinColor = annotation.pinColor()
            
            return view
        }
        return nil
    }
    
    func calculatePlaceDistance(latitude: Double, longitude: Double) -> Double {
        let place = CLLocation(latitude: latitude, longitude: longitude)
        let placeDistance: Double = locationManager.location.distanceFromLocation(place)
        return placeDistance
    }
    
    func infoCategoryShowing() -> [String] {
        var infoCategoryToShow = ["Name", "Category", "Distance"]
        
        return infoCategoryToShow
    }
    
    func infoDetailShowing() -> [String] {
        var infoDetailToShow = [place!.name, place!.categoryDescription(), String(format: "%.2f kilometers", (self.calculatePlaceDistance(place!.latitude, longitude: place!.longitude))/1000)]
        
        return infoDetailToShow
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoCategoryShowing().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = infoCategoryShowing()[indexPath.row]
        cell.detailTextLabel?.text = infoDetailShowing()[indexPath.row]
        
        return cell
    }
    
    


}
