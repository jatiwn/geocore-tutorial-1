//
//  TableViewController.swift
//  GeocoreTutorial1
//
//  Created by Jati Wicaksono on 7/31/15.
//  Copyright (c) 2015 MapMotion. All rights reserved.
//

import UIKit
import CoreLocation

class TableViewController: UITableViewController, CLLocationManagerDelegate {
        
    var textLabel: UITableView?
    var detailTextLabel: UITableView?
    var locationManager = CLLocationManager()
    var placeDistance: [CLLocationDistance] = []
    var places: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        
        CLLocationManager.locationServicesEnabled()
        
        self.locationManager.startUpdatingLocation()
        
        DataSource.sharedInstance.getNearestPlaces(locationManager.location.coordinate.latitude, centerLon: locationManager.location.coordinate.longitude) .then{ (geocorePlaces:[Place]) -> Void in
            self.places = geocorePlaces
            self.places.sort { (place1, place2) -> Bool in
                self.calculatePlaceDistance(place1.latitude, longitude: place1.longitude) < self.calculatePlaceDistance(place2.latitude, longitude: place2.longitude)
            }
            self.tableView.reloadData()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        DataSource.sharedInstance.getNearestPlaces(locationManager.location.coordinate.latitude, centerLon: locationManager.location.coordinate.longitude) .then{ (geocorePlaces:[Place]) -> Void in
            self.places = geocorePlaces
            self.places.sort { (place1, place2) -> Bool in
                self.calculatePlaceDistance(place1.latitude, longitude: place1.longitude) < self.calculatePlaceDistance(place2.latitude, longitude: place2.longitude)
            }
            self.tableView.reloadData()
        }
    
    }
    
    func calculatePlaceDistance(latitude: Double, longitude: Double) -> Double {
        let place = CLLocation(latitude: latitude, longitude: longitude)
        let placeDistance: Double = locationManager.location.distanceFromLocation(place)
        return placeDistance
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        
        
        let place = self.places[indexPath.row]
        
        cell.textLabel?.text = place.name
        cell.detailTextLabel?.text = String(format: "Distance from your location = %.2f kilometers", (self.calculatePlaceDistance(place.latitude, longitude: place.longitude))/1000)
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailsFromList" {
            
            var detailsVC: DetailsViewController = segue.destinationViewController as! DetailsViewController
            
            let tableIndex = tableView.indexPathForSelectedRow()?.row
            let place = self.places[tableIndex!]
            detailsVC.place = place
            
        }
        
    }
}
