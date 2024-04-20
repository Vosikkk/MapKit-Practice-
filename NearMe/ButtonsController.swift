//
//  ButtonsController.swift
//  NearMe
//
//  Created by Саша Восколович on 19.04.2024.
//

import UIKit
import MapKit

enum ButtonType {
    case map
    case call
}

class ButtonsController {
    
    let buttons: [(button: UIButton, type: ButtonType)]
    let callback: (URL) -> Void
    let place: PlaceAnnotation
    
    
    private var url: URL? {
        URL(string: "http://maps.apple.com/?daddr=\(coordinate.latitude),\(coordinate.longitude)")
    }
    
    private var urlForCall: URL? {
        URL(string: "tel://\(place.phone.formatPhoneNumber)")
    }
    
    private var coordinate: CLLocationCoordinate2D {
        place.location.coordinate
    }
    
    init(buttons: (UIButton, ButtonType)..., place: PlaceAnnotation, callback: @escaping (URL) -> Void) {
        self.buttons = buttons
        self.place = place
        self.callback = callback
        setup()
    }
    
    
    private func setup() {
        buttons.forEach { (button , _ ) in
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        guard let buttonType = buttons.first(where: { $0.button == sender })?.type else { return }
               
        switch buttonType {
        case .map:
            guard let url else { return }
            callback(url)
        case .call:
            guard let urlForCall else { return }
            callback(urlForCall)
        }
    }
}
