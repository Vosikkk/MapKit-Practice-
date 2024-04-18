//
//  PlacesTableViewController.swift
//  NearMe
//
//  Created by Саша Восколович on 17.04.2024.
//

import Foundation
import UIKit
import MapKit


class PlacesTableViewController: UITableViewController {
    
    var userLocation: CLLocation
    let places: [PlaceAnnotation]
    
    init(userLocation: CLLocation, places: [PlaceAnnotation]) {
        self.userLocation = userLocation
        self.places = places
        super.init(nibName: nil, bundle: nil)
    }
    
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

