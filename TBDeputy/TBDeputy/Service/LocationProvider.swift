//
//  LocationProvider.swift
//  TBDeputy
//
//  Created by Tushar on 15/9/18.
//  Copyright © 2018 bole.tushar. All rights reserved.
//

import Foundation
import MapKit

class LocationProvider : NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationProvider()
    
    var locationManager: CLLocationManager
    var location: CLLocationCoordinate2D
    
    private override init() {
        
        // Initializing to default location
        self.locationManager = CLLocationManager()
        self.location = CLLocationCoordinate2D(latitude: -37.810888, longitude: 144.951488)
        super.init()
    }
    
    func requestUserPermission() {
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocations() {
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            
            AlertError.showMessage(title: "Location Error", msg: "Please enable location services to use this app.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            self.location = coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
