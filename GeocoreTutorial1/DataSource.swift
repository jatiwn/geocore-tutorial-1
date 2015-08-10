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
    var places: [Place] = []
    
    
    func getData(minLat: Double, minLon: Double, maxLat: Double, maxLon: Double) -> Promise<[Place]> {
        return GeocorePlace
            .get(minLat: minLat, minLon: minLon, maxLat: maxLat, maxLon: maxLon)
            .then {
                (geocorePlaces: [GeocorePlace]) -> Promise<[Place]> in
                var places: [Place] = []
                println("--- Some places as promised:")
                for place in geocorePlaces {
                    var point = place.point ?? GeocorePoint(latitude: 0, longitude: 0)
                    places.append(Place(
                        name: place.name ?? "",
                        latitude: Double(point.latitude!),
                        longitude: Double(point.longitude!)))
                }
                return Promise(places)
            }
        
        /*
        return Promise { fulfill, reject in
            GeocorePlace
                .get(minLat: 35.66617440081799, minLon: 139.7126117348629, maxLat: 35.67753978462231, maxLon: 139.72917705773887)
                .then { (geocorePlaces: [GeocorePlace]) -> Void in
                    var places: [Place] = []
                    println("--- Some places as promised:")
                    for place in geocorePlaces {
                        places.append(Place(name: place.name!, latitude: Double(place.point!.latitude!), longitude: Double(place.point!.longitude!)))
                        
                        println("Id = \(place.id), Name = \(place.name), Point = (\(place.point?.latitude), \(place.point?.longitude))")
                    }
                    fulfill(places)
                }
        }
        */
    }
    /*
    func importData() -> Promise<[Place]> {
        
        return Promise { fulfill, reject in
            self.places = []
            
            GeocorePlace
                .get(minLat: 35, minLon: 139, maxLat: 36, maxLon: 140)
                .then { (places: [GeocorePlace]) -> Void in
                    println("--- Some places as promised:")
                    for place in places {
                        self.places.append(Place(name: place.name!, latitude: Double(place.point!.latitude!), longitude: Double(place.point!.longitude!)))
                        
                        println("Id = \(place.id), Name = \(place.name), Point = (\(place.point?.latitude), \(place.point?.longitude))")
                    }
                    
            }
            fulfill (Place())

        }
        
        
        self.places = []
        
        if let url = NSBundle.mainBundle().URLForResource("map_app_data-jati_en", withExtension: "csv") {
            var error: NSErrorPointer = nil
       
            if let csv = CSV(contentsOfURL: url, error: error) {
                
                for placeDict in csv.rows {
                    let placeName = placeDict["name"]

                    let placeLatitude = NSString(string: placeDict["latitude"]!).doubleValue
                    let placeLongitude = NSString(string: placeDict["longitude"]!).doubleValue
                    
                    let placeDetails = placeDict["facility_details"]
                    
                    if placeDetails == "Yes" {
                        let placeAtm = true
                        self.places.append(ConvenienceStore(name: placeName!, latitude: placeLatitude, longitude: placeLongitude, hasAtm: placeAtm))
                    } else if placeDetails == "No" {
                        let placeAtm = false
                        self.places.append(ConvenienceStore(name: placeName!, latitude: placeLatitude, longitude: placeLongitude, hasAtm: placeAtm))
                    } else {
                        self.places.append(TrainStation(name: placeName!, latitude: placeLatitude, longitude: placeLongitude, lineServed: placeDetails!))
                    }
                
                }
                
                
            }
        }
        return places
        
        
    }
    */
    
    /*
    let places = [
        TrainStation(name: "Aoyama Itchome", latitude: 35.672929, longitude: 139.723960, lineServed: "Oedo"),
        TrainStation(name: "Gaienmae", latitude: 35.670527, longitude: 139.717857, lineServed: "Ginza"),
        TrainStation(name: "Nogizaka", latitude: 35.666572, longitude: 139.726215, lineServed: "Chiyoda"),
        ConvenienceStore(name: "Family Mart", latitude: 35.67265605385047, longitude: 139.7243950343933, hasAtm: true),
        ConvenienceStore(name: "Poplar", latitude: 35.6717931950933, longitude: 139.7242180085983, hasAtm: false)
    ]
    */

}

