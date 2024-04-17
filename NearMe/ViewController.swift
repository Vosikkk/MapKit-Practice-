//
//  ViewController.swift
//  NearMe
//
//  Created by Саша Восколович on 17.04.2024.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    
    let locationManager: CLLocationManager
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
       // map.showsUserLocation = true
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
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
    
    
    private struct Constants {
        
        static let fieldTopOffset: CGFloat = 60
        
        struct Size {
            static let fieldHeight: CGFloat = 44
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}





private class SearchTextFieldController {
    
    let field: UITextField
    let callback: () -> Void
    
    init(field: UITextField, callback: @escaping () -> Void) {
        self.field = field
        self.callback = callback
    }
}
