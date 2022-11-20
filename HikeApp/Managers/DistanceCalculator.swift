//
//  DistanceCalculator.swift
//  HikeApp
//
//  Created by Svetlana Gladysheva on 16.11.2022.
//

import Foundation
import CoreLocation

final class DistanceCalculator {
    func calcDistanceBetween(_ point1: CLLocationCoordinate2D, and point2: CLLocationCoordinate2D) -> Double {
        let location1 = CLLocation(latitude: point1.latitude, longitude: point1.longitude)
        let location2 = CLLocation(latitude: point2.latitude, longitude: point2.longitude)
        return location1.distance(from: location2)
    }
}
