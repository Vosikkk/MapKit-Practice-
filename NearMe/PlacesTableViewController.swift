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
    private let identifier: String = "cell"
    
    
    
    init(userLocation: CLLocation, places: [PlaceAnnotation]) {
        self.userLocation = userLocation
        self.places = places
        super.init(nibName: nil, bundle: nil)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
    }
    
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let place = places[indexPath.row]
        return cell(for: place, by: indexPath)
    }
    
    
    private func cell(for place: PlaceAnnotation, by indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = place.name
        content.secondaryText = "Secondary Text"
        cell.contentConfiguration = content
        return cell
    }
}

