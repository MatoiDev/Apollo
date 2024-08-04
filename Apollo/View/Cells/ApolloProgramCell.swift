//
//  ApolloProgramCell.swift
//  Apollo
//
//  Created by Matoi on 31.07.2024.
//

import Foundation
import UIKit

final class ApolloProgramCell: UITableViewCell {
    
    // Properties
    private let program: Faculty
    private lazy var olympiadsCount: String = { String.olympiads(program.olympiads.count) }()

    // Elements
    private let container: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let olympiadsBubble: UIView = UIView()
    private let fakeExtendButton: UIView = UIView()
    private let olympiadsLabel: UILabel = UILabel()
    private let chevronImage: UIImageView = UIImageView()

    init(style: CellStyle = .default, reuseIdentifier: String? = nil, program: Faculty) {
        self.program = program
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
        configureContainer()
        configureTitleLabel()
        configureFakeExtendButton()
        configureProgramsLabel()
        configureChevronImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension ApolloProgramCell {
    
    func configure() -> Void {
        backgroundColor = .clear
        selectionStyle = .none
    }

    func configureContainer() -> Void {
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .apolloBackgroundColor
        container.layer.cornerRadius = 24.0

        contentView.addSubview(container)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6.0),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6.0)
        ])
    }

    func configureTitleLabel() -> Void {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.text = program.name
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 16.0, weight: .medium)

        container.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12.0),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12.0),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12.0)
        ])
    }

    func configureFakeExtendButton() -> Void {
        fakeExtendButton.translatesAutoresizingMaskIntoConstraints = false
        fakeExtendButton.backgroundColor = .label
        fakeExtendButton.layer.cornerRadius = 12.0

        container.addSubview(fakeExtendButton)
        NSLayoutConstraint.activate([
            fakeExtendButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            fakeExtendButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12.0),
            fakeExtendButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12.0)
        ])
    }

    func configureProgramsLabel() -> Void {
        olympiadsLabel.translatesAutoresizingMaskIntoConstraints = false
        olympiadsLabel.textColor = .inversedLabelColor
        olympiadsLabel.text = olympiadsCount
        olympiadsLabel.font = .systemFont(ofSize: 12.0, weight: .medium)
        olympiadsLabel.textAlignment = .center

        fakeExtendButton.addSubview(olympiadsLabel)
        NSLayoutConstraint.activate([
            olympiadsLabel.leadingAnchor.constraint(equalTo: fakeExtendButton.leadingAnchor, constant: 8.0),
            olympiadsLabel.bottomAnchor.constraint(equalTo: fakeExtendButton.bottomAnchor, constant: -4.0),
            olympiadsLabel.topAnchor.constraint(equalTo: fakeExtendButton.topAnchor, constant: 4.0)
        ])
    }

    func configureChevronImageView() -> Void {
        chevronImage.translatesAutoresizingMaskIntoConstraints = false
        chevronImage.contentMode = .scaleAspectFit
        chevronImage.tintColor = .inversedLabelColor
        chevronImage.image = ApolloResources.Images.UniversityCell.chevronDown

        fakeExtendButton.addSubview(chevronImage)
        NSLayoutConstraint.activate([
            chevronImage.topAnchor.constraint(equalTo: fakeExtendButton.topAnchor, constant: 3.0),
            chevronImage.bottomAnchor.constraint(equalTo: fakeExtendButton.bottomAnchor, constant: -3.0),
            chevronImage.trailingAnchor.constraint(equalTo: fakeExtendButton.trailingAnchor, constant: -5.0),
            chevronImage.leadingAnchor.constraint(equalTo: olympiadsLabel.trailingAnchor, constant: 2.0),
            chevronImage.widthAnchor.constraint(equalToConstant: 18.0),
            chevronImage.heightAnchor.constraint(equalToConstant: 18.0)
        ])
    }
}
