//
//  DetailsViewController.swift
//  GeocoreTutorial1
//
//  Created by Jati Wicaksono on 8/3/15.
//  Copyright (c) 2015 MapMotion. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var detailsMapView: MKMapView!
    @IBOutlet weak var detailsTableView: UITableView!
    
    var place: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var region: MKCoordinateRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(place!.latitude, place!.longitude), MKCoordinateSpanMake(0.01, 0.01))
        
        detailsMapView.setRegion(region, animated: true)
        
        detailsMapView.addAnnotation(place!)
        detailsMapView.delegate = self
        
        detailsTableView.dataSource = self
        detailsTableView.delegate = self
        
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
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
            }
            
            view.pinColor = annotation.pinColor()
            
            return view
        }
        return nil
    }
    
    
    func infoCategoryShowing() -> [String] {
        var infoCategoryToShow = ["Name", "Type", place!.facility()]
        
        return infoCategoryToShow
    }
    
    
    func infoDetailShowing() -> [String] {
        var infoDetailToShow = [place!.name, place!.categoryDescription(), place!.facilityDetails()]
        
        return infoDetailToShow
    }
    
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let location = view.annotation as! Place
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMapsWithLaunchOptions(launchOptions)
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
