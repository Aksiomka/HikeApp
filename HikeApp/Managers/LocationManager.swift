//
//  LocationManager.swift
//  HikeApp
//
//  Created by Svetlana Gladysheva on 12.11.2022.
//

import CoreLocation
import Foundation

final class LocationManager: NSObject {
    var currentLocation: CLLocationCoordinate2D?
    
    var onLocationServicesDisabled: (() -> Void)?
    
    private let locationManager = CLLocationManager()
    
    func setup() {
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        } else {
            onLocationServicesDisabled?()
        }
    }
    
    func startUpdatingLocation() {
        guard CLLocationManager.locationServicesEnabled() else { return }
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        guard CLLocationManager.locationServicesEnabled() else { return }
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = manager.location?.coordinate
    }
}
