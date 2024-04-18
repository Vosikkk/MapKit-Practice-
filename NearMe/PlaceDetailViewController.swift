//
//  PlaceDetailViewController.swift
//  NearMe
//
//  Created by Саша Восколович on 18.04.2024.
//

import Foundation
import UIKit

class PlaceDetailViewController: UIViewController {
    
    private let place: PlaceAnnotation
    
    private var buttonController: DirectionButtonController?
    
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
        buttonController = DirectionButtonController(button: directionButton, place: place) { url in
            UIApplication.shared.open(url)
        }
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


private class DirectionButtonController {
    
    let button: UIButton
    let callback: (URL) -> Void
    let place: PlaceAnnotation
    
    var url: String {
      "http://maps.apple.com/?daddr="
    }
    
    
    init(button: UIButton, place: PlaceAnnotation, callback: @escaping (URL) -> Void) {
        self.button = button
        self.place = place
        self.callback = callback
        setup()
    }
    
    
    private func setup() {
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        let coordinate = place.location.coordinate
        guard let url = URL(string: "\(url)\(coordinate.latitude),\(coordinate.longitude)") else { return }
        callback(url)
    }
}
