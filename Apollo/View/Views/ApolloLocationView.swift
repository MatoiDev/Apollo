//
// Created by Matoi on 28.07.2024.
//

import Foundation
import UIKit
import MapKit

final class ApolloLocationView: UIView {

    // Properties
    private let university: University

    // Elements
    private lazy var mapView: MKMapView = MKMapView(frame: bounds)

    init(frame: CGRect = .zero, university: University) {
        self.university = university
        super.init(frame: frame)

        configure()
        configureMapView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ApolloLocationView {

    func configure() -> Void {
        backgroundColor = .clear
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }

    func configureMapView() -> Void {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.layer.cornerRadius = bounds.height * 0.2
        setRegion(latitude: university.address.location.latitude, longitude: university.address.location.longitude)

        addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setRegion(latitude: Double, longitude: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
        mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
}

