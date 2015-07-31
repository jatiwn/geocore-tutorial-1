//
//  DataSource.swift
//  GeocoreTutorial1
//
//  Created by Jati Wicaksono on 7/31/15.
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

class DataSource: NSObject {
    
    static let sharedInstance = DataSource()
    
    let places = [
        TrainStation(name: "Aoyama Itchome", latitude: 35.672929, longitude: 139.723960, lineServed: "Oedo"),
        TrainStation(name: "Gaienmae", latitude: 35.670527, longitude: 139.717857, lineServed: "Ginza"),
        TrainStation(name: "Nogizaka", latitude: 35.666572, longitude: 139.726215, lineServed: "Chiyoda"),
        ConvenienceStore(name: "Family Mart", latitude: 35.67265605385047, longitude: 139.7243950343933, hasAtm: true),
        ConvenienceStore(name: "Poplar", latitude: 35.6717931950933, longitude: 139.7242180085983, hasAtm: false)
    ]
    
    
}

