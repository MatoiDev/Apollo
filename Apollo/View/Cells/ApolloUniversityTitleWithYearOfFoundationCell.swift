//
// Created by Matoi on 27.07.2024.
//

import Foundation
import UIKit

final class ApolloUniversityTitleWithYearOfFoundationCell: UITableViewCell {

    // Properties
    private let university: University

    // Elements
    private let titleLabel: UILabel = UILabel()
    private let yearOfFoundationLabel: UILabel = UILabel()

    init(style: CellStyle = .default, reuseIdentifier: String? = nil, university: University) {
        self.university = university
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
        configureTitleLabel()
        configureYearOfFoundationLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension ApolloUniversityTitleWithYearOfFoundationCell {
    
    func configure() -> Void {
        backgroundColor = .clear
        selectionStyle = .none
    }

    func configureTitleLabel() -> Void {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 27.0, weight: .bold)
        titleLabel.text = university.name

        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.0),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32.0),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }

    func configureYearOfFoundationLabel() -> Void {
        yearOfFoundationLabel.translatesAutoresizingMaskIntoConstraints = false
        yearOfFoundationLabel.numberOfLines = 1
        yearOfFoundationLabel.textColor = .secondaryLabel
        yearOfFoundationLabel.font = .systemFont(ofSize: 16.0, weight: .medium)
        yearOfFoundationLabel.text = String(university.yearOfFoundation)

        contentView.addSubview(yearOfFoundationLabel)
        NSLayoutConstraint.activate([
            yearOfFoundationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.0),
            yearOfFoundationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32.0),
            yearOfFoundationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.0),
            yearOfFoundationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
