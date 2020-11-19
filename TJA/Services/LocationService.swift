//
//  LocationService.swift
//  TJA
//
//  Created by Miron Rogovets on 19.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class LocationService: NSObject, ObservableObject {
    
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation? = nil
    @Published var servicesDisabled = false
    @Published var userTrackingMode: MKUserTrackingMode = .follow
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    var locationServicesEnabled: Bool {
        CLLocationManager.locationServicesEnabled()
    }
    
    var mockupCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: 40.71, longitude: -74)
    }
    
    func checkPermissions() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.start()
        case .denied, .restricted:
            self.servicesDisabled = true
        case .notDetermined:
            self.requestUsage()
        default:
            break
        }
    }
    
    func requestUsage() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func start() {
        self.locationManager.startUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("DEBUG: -- LocationService -- Changed status to \(status)")
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.start()
        case .denied, .restricted:
            self.servicesDisabled = true
        case .notDetermined:
            self.requestUsage()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location
        }
    }
}
