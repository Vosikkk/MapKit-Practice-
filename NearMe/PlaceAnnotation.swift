//
//  PlaceAnnotation.swift
//  NearMe
//
//  Created by Саша Восколович on 18.04.2024.
//

import Foundation
import MapKit


class PlaceAnnotation: MKPointAnnotation {
    
    let item: MKMapItem
    let id: UUID = UUID()
    var isSelected: Bool = false
    
    
    var name: String {
        item.name ?? ""
    }
    
    var phone: String {
        item.phoneNumber ?? ""
    }
    
    var location: CLLocation {
        item.placemark.location ?? CLLocation.default
    }
    
    var address: String {
        "\(item.placemark.subThoroughfare ?? "") \(item.placemark.thoroughfare ?? "") \(item.placemark.locality ?? "") \(item.placemark.countryCode ?? "")"
    }
    
    
    init(_ item: MKMapItem) {
        self.item = item
        super.init()
        self.coordinate = item.placemark.coordinate
    }
}

extension CLLocation {
    
    static var `default`: CLLocation {
        CLLocation(latitude: 36.063457, longitude: -95.880516)
    }
}
