//
//  ViewController.swift
//  GeocoreTutorial1
//
//  Created by Jati Wicaksono on 7/27/15.
//  Copyright (c) 2015 MapMotion. All rights reserved.
//

import UIKit
import MapKit
import AddressBook

class Place: NSObject, MKAnnotation {
    var name: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var coordinate: CLLocationCoordinate2D
    var title: String
    var subtitle: String {
        get {
            return category()
        }
    }

    init(name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        self.title = name
        
        super.init()
        
    }
    
    func pinColor() -> MKPinAnnotationColor  {
        return .Red
    }
    
    func mapItem() -> MKMapItem {
        
        let addressDict = [String(kABPersonAddressStreetKey): self.subtitle]
        let placemark = MKPlacemark(coordinate: self.coordinate, addressDictionary: addressDict)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.title
        
        return mapItem
    }
    
    func category() -> String {
        return "A Place"
    }
    
}

class TrainStation: Place {
    var lineServed: String
    
    init(name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, lineServed: String) {
        self.lineServed = lineServed
        super.init(name: name, latitude: latitude, longitude: longitude)
    }
    
    override func category() -> String {
        return "Train Station, Line Served: \(lineServed)"
    }
}

class ConvenienceStore: Place {
    var hasAtm: Bool
    
    init(name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, hasAtm: Bool){
        self.hasAtm = hasAtm
        super.init(name: name, latitude: latitude, longitude: longitude)
    }
    
    override func pinColor() -> MKPinAnnotationColor {
        if (hasAtm) {
            return .Green
        } else {
            return .Purple
        }
    }
    
    override func category() -> String {
        if (hasAtm) {
            return "Convenience Store, ATM Available"
        } else {
            return "Convenience Store, No ATM Avaliable"
        }
    }
  
}



class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var places: [Place] = [
            TrainStation(name: "Aoyama Itchome", latitude: 35.672929, longitude: 139.723960, lineServed: "Oedo"),
            TrainStation(name: "Gaienmae", latitude: 35.670527, longitude: 139.717857, lineServed: "Ginza"),
            TrainStation(name: "Nogizaka", latitude: 35.666572, longitude: 139.726215, lineServed: "Chiyoda"),
            ConvenienceStore(name: "Family Mart", latitude: 35.67265605385047, longitude: 139.7243950343933, hasAtm: true),
            ConvenienceStore(name: "Poplar", latitude: 35.6717931950933, longitude: 139.7242180085983, hasAtm: false)
        ]
        
        
        
        var numberOfPlaces = places.count
        
        var maxLatitude: CLLocationDegrees = -90
        var minLatitude: CLLocationDegrees = 90
        var sumLatitude: CLLocationDegrees = 0
        var maxLongitude: CLLocationDegrees = -180
        var minLongitude: CLLocationDegrees = 180
        var sumLongitude: CLLocationDegrees = 0
        
        for place in places {
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
        
        var region: MKCoordinateRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(sumLatitude/Double(numberOfPlaces), sumLongitude/Double(numberOfPlaces)), MKCoordinateSpanMake((maxLatitude - minLatitude)*3, (maxLongitude - minLongitude)*3))
        
        mapView.setRegion(region, animated: true)
        
        mapView.addAnnotations(places)
        
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