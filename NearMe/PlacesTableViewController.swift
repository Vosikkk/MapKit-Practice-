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
    
    private var userLocation: CLLocation
    private var places: [PlaceAnnotation]
    private let identifier: String = "cell"
    
    private var indexForSelectedRow: Int? {
        places.firstIndex(where: { $0.isSelected })
    }
    
    init(userLocation: CLLocation, places: [PlaceAnnotation]) {
        self.userLocation = userLocation
        self.places = places
        super.init(nibName: nil, bundle: nil)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        
        self.places.swapAt(indexForSelectedRow ?? 0, 0)
    }
    
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func calculateDistance(from start: CLLocation, to finish: CLLocation) -> CLLocationDistance {
        start.distance(from: finish)
    }
    
    private func formatDistanceToDisplay(_ distance: CLLocationDistance) -> String {
        let meters = Measurement(value: distance, unit: UnitLength.meters)
        return meters.converted(to: .kilometers).formatted()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let place = places[indexPath.row]
        return cell(for: place, by: indexPath)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    private func cell(for place: PlaceAnnotation, by indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = place.name
        content.secondaryText = formatDistanceToDisplay(calculateDistance(from: userLocation, to: place.location))
        cell.contentConfiguration = content
        cell.backgroundColor = place.isSelected ? .lightGray : .clear
        return cell
    }
}

