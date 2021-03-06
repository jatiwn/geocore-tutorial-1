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
import SwiftCSV
import GeocoreKit
import PromiseKit

class Place: NSObject, MKAnnotation {
    var name: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var coordinate: CLLocationCoordinate2D
    var title: String
    var subtitle: String {
        get {
            return categoryDescription()
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
    
    func categoryDescription() -> String {
        return "A Place"
    }
    
    func facility() -> String {
        return "None"
    }
    
    func facilityDetails() -> String {
        return "None"
    }
    
    
}

class TrainStation: Place {
    var lineServed: String
    
    init(name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, lineServed: String) {
        self.lineServed = lineServed
        super.init(name: name, latitude: latitude, longitude: longitude)
    }
    
    override func categoryDescription() -> String {
        return "Train Station"
    }
    
    override func facility() -> String {
        return "Line"
    }
    
    override func facilityDetails() -> String {
        return lineServed
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
    
    override func categoryDescription() -> String {
            return "Convenience Store"
    }
    
    override func facility() -> String {
        return "ATM"
    }
    
    override func facilityDetails() -> String {
        if (hasAtm){
            return "Yes"
        } else {
            return "No"
        }
    }
    
}



class DataSource: NSObject {
    
    static let sharedInstance = DataSource()
    
    func getData(minLat: Double, minLon: Double, maxLat: Double, maxLon: Double) -> Promise<[Place]> {
        return GeocorePlace
            .get(minLat: minLat, minLon: minLon, maxLat: maxLat, maxLon: maxLon)
            .then {
                (geocorePlaces: [GeocorePlace]) -> Promise<[Place]> in
                var places: [Place] = []
                //println("--- Some places as promised:")
                for place in geocorePlaces {
                    var point = place.point ?? GeocorePoint(latitude: 0, longitude: 0)
                    places.append(Place(
                        name: place.name ?? "",
                        latitude: Double(point.latitude!),
                        longitude: Double(point.longitude!)))
                }
                return Promise(places)
            }
    }
    
    func getNearestPlaces(centerLat: Double, centerLon: Double) -> Promise<[Place]> {
        return GeocorePlace
            .get(centerLat: centerLat, centerLon: centerLon)
            .then { (geocorePlaces: [GeocorePlace]) -> Promise <[Place]> in
                var places: [Place] = []
                //println("--- Some places as promised:")
                for place in geocorePlaces {
                    var point = place.point ?? GeocorePoint(latitude: 0, longitude: 0)
                    places.append(Place(
                        name: place.name ?? "",
                        latitude: Double(point.latitude!),
                        longitude: Double(point.longitude!)))
                }
                return Promise(places)
        }
    }

}

