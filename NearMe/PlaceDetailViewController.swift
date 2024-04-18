//
//  PlaceDetailViewController.swift
//  NearMe
//
//  Created by Саша Восколович on 18.04.2024.
//

import Foundation
import UIKit

class PlaceDetailViewController: UIViewController {
    
    let place: PlaceAnnotation
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.alpha = 0.4
        return label
    }()
    
    
    
    init(place: PlaceAnnotation) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
    }
    
    private func setupUI() {
        
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
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
        
        view.addSubview(stackView)
    }
    
    
    private struct Constants {
        static let stackTopOffset: CGFloat = 20
        static let stackLeadingOffset: CGFloat = 20
        static let stackBottomOffset: CGFloat = 20
        static let stackTrailingOffset: CGFloat = 20
    }
}

