//
// Created by Matoi on 28.07.2024.
//

import Foundation
import UIKit

final class ApolloUniversityAddressCell: UITableViewCell {

    // Properties
    private let university: University
    private lazy var address: String = {
        "\(university.address.city), \(university.address.street),\n\(university.address.postCode)"
    }()

    // Elements
    private let leftImageView: UIImageView = UIImageView()
    private let titleLabel: UILabel = UILabel()
    private let addressLabel: UILabel = UILabel()
    private lazy var locationView: ApolloLocationView = ApolloLocationView(university: university)

    init(style: CellStyle = .default, reuseIdentifier: String? = nil, university: University) {
        self.university = university
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
        configureLeftImageView()
        configureTitleLabel()
        configureAddressLabel()
        configureLocationView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension ApolloUniversityAddressCell {

    func configure() -> Void {
        backgroundColor = .clear
        selectionStyle = .none
    }

    func configureLeftImageView() -> Void {
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        leftImageView.tintColor = .secondaryLabel
        leftImageView.contentMode = .scaleAspectFit
        leftImageView.image = ApolloResources.Images.AddressCell.pin

        contentView.addSubview(leftImageView)
        NSLayoutConstraint.activate([
            leftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.0),
            leftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.0),
            leftImageView.widthAnchor.constraint(equalToConstant: 24.0),
            leftImageView.heightAnchor.constraint(equalToConstant: 24.0)
        ])
    }

    func configureTitleLabel() -> Void {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        titleLabel.text = "Address"
        titleLabel.adjustsFontSizeToFitWidth = true

        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 12.0),
            titleLabel.centerYAnchor.constraint(equalTo: leftImageView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -56.0)
        ])
    }

    func configureAddressLabel() -> Void {
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.numberOfLines = 0
        addressLabel.textColor = .secondaryLabel
        addressLabel.font = .systemFont(ofSize: 14.0, weight: .medium)
        addressLabel.text = address
        addressLabel.adjustsFontSizeToFitWidth = true

        contentView.addSubview(addressLabel)
        NSLayoutConstraint.activate([
            addressLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -56.0),
            addressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0)
        ])
    }

    func configureLocationView() -> Void {
        locationView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(locationView)
        NSLayoutConstraint.activate([
            locationView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 52.0),
            locationView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -52.0),
            locationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.0),
            locationView.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 12.0),
            locationView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.4)
        ])
    }
}
