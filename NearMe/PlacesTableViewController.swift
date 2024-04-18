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
    let places: [String]
    
    init(userLocation: CLLocation, places: [String]) {
        self.userLocation = userLocation
        self.places = places
        super.init()
    }
    
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

