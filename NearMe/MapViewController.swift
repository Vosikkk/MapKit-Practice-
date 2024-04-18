//
//  MapViewController.swift
//  NearMe
//
//  Created by Саша Восколович on 17.04.2024.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    
    private let locationManager: CLLocationManager
    
    private var searchFieldConntroller: SearchTextFieldController?
    
    private var places: [PlaceAnnotation] = []
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var searchTextField: UITextField = {
        let field = UITextField()
        field.layer.cornerRadius = 10
        field.clipsToBounds = true
        field.backgroundColor = .white
        field.placeholder = "Search"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    var location: CLLocation? {
        locationManager.location
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchFieldConntroller = SearchTextFieldController(field: searchTextField) { [unowned self] text in
            findNearbyPlaces(by: text)
        }
        setupUI()
    }


    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.addSubview(searchTextField)
        view.addSubview(mapView)
        view.bringSubviewToFront(searchTextField)
        
        searchTextField.heightAnchor.constraint(equalToConstant: Constants.Size.fieldHeight).isActive = true
        searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchTextField.widthAnchor.constraint(equalToConstant: view.bounds.size.width / 1.2).isActive = true
        searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.fieldTopOffset).isActive = true
        searchTextField.returnKeyType = .go
        
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
   
    private func checkLocationAuhtorization() {
        guard let location else { return }
        
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            let region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: Constants.Position.latitude,
                longitudinalMeters: Constants.Position.longitude
            )
            set(region)
        case .denied:
            print("")
        case .notDetermined, .restricted:
            print("")
        @unknown default:
            print("")
        }
    }
    
    private func set(_ region: MKCoordinateRegion) {
        mapView.setRegion(region, animated: true)
    }
    
    private func presentSheet(of places: [PlaceAnnotation]) {
        guard let location else { return }
        let placesTVC = PlacesTableViewController(userLocation: location, places: places)
        placesTVC.modalPresentationStyle = .pageSheet
        
        if let sheet = placesTVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            show(placesTVC)
        }
    }
    
    
    
    private func show(_ vc: UIViewController) {
        present(vc, animated: true)
    }
    
    
    private func findNearbyPlaces(by query: String) {
        
        mapView.removeAnnotations(mapView.annotations)
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.start { [weak self] response, error in
            guard let self, let response, error == nil else { return }
            
            places = response.mapItems.map(PlaceAnnotation.init)
            
            places.forEach { self.mapView.addAnnotation($0) }

            presentSheet(of: places)
        }
    }
    
    
    private struct Constants {
        
        static let fieldTopOffset: CGFloat = 60
        
        struct Position {
            static let latitude: CGFloat = 750
            static let longitude: CGFloat = 750
        }
        struct Size {
            static let fieldHeight: CGFloat = 44
        }
    }
}



extension MapViewController: MKMapViewDelegate {
    
    private func clearSelection() {
        places.forEach { $0.isSelected = false }
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
        
        clearSelection()
        
        guard let selectedAnnotation = annotation as? PlaceAnnotation else { return }
        let placeAnnotation = places.first(where: { $0.id == selectedAnnotation.id })
        placeAnnotation?.isSelected = true
        
        presentSheet(of: places)
    }
}



extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuhtorization()
    }
}
