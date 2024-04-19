//
//  PlaceDetailViewController.swift
//  NearMe
//
//  Created by Саша Восколович on 18.04.2024.
//

import Foundation
import UIKit
import MapKit

class PlaceDetailViewController: UIViewController {
    
    private let place: PlaceAnnotation
    
    private var buttonController: ButtonsController?
    
    private let uiApp: UIApplication = UIApplication.shared
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.alpha = 0.4
        return label
    }()
    
    private lazy var directionButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Directions", for: .normal)
        return button
    }()
    
    
    private lazy var callButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Call", for: .normal)
        return button
    }()
    
    init(place: PlaceAnnotation) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        
        let stackView = createStackView(withAxis: .vertical)
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Constants.stackTopOffset,
            leading: Constants.stackLeadingOffset,
            bottom: Constants.stackBottomOffset,
            trailing: Constants.stackTrailingOffset
        )
        
        nameLabel.text = place.name
        addressLabel.text = place.address
       
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(addressLabel)
        
        nameLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 20).isActive = true
        
        let contactStackView = createStackView(withAxis: .horizontal)
        contactStackView.addArrangedSubview(directionButton)
        contactStackView.addArrangedSubview(callButton)
        contactStackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: Constants.stackLeadingOffset)
       
        
        stackView.addArrangedSubview(contactStackView)
        
        view.addSubview(stackView)
        
        buttonController = ButtonsController(buttons: (directionButton, .map), (callButton, .call), place: place) { [unowned self] url in
            uiApp.open(url)
        }
    }
    
    
    private func createStackView(withAxis axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stackView = UIStackView()
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.spacing = UIStackView.spacingUseSystem
        return stackView
    }
    
    private struct Constants {
        static let stackTopOffset: CGFloat = 20
        static let stackLeadingOffset: CGFloat = 20
        static let stackBottomOffset: CGFloat = 20
        static let stackTrailingOffset: CGFloat = 20
    }
}


class ButtonsController {
    
    let buttons: [(button: UIButton, type: ButtonType)]
    let handle: (URL) -> Void
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
    
    init(buttons: (UIButton, ButtonType)..., place: PlaceAnnotation, handle: @escaping (URL) -> Void) {
        self.buttons = buttons
        self.place = place
        self.handle = handle
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
            handle(url)
        case .call:
            guard let urlForCall else { return }
            handle(urlForCall)
        }
    }
}

enum ButtonType {
    case map
    case call
}


extension String {
    var formatPhoneNumber: String {
        do {
            let regex = try NSRegularExpression(pattern: "[\\s\\p{P}]+")
            return regex.stringByReplacingMatches(in: self, range: NSRange(self.startIndex..., in: self), withTemplate: "")
        } catch {
            print("Error while creating regular expression: \(error.localizedDescription)")
            return self
        }
    }
}
