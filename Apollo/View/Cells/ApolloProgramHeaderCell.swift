//
// Created by Matoi on 04.08.2024.
//

import Foundation
import UIKit

final class ApolloProgramHeaderCell: UITableViewCell {

    // Properties
    private let program: Faculty
    private let university: University
    private let buttonAction: Selector

    // Elements
    private let container: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let subtitleLabel: UILabel = UILabel()
    let goToProgramWebsiteButton: UIButton = UIButton(type: .system)

    init(style: CellStyle = .default, reuseIdentifier: String? = nil, program: Faculty, university: University, action: Selector) {
        self.program = program
        self.university = university
        buttonAction = action
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
        configureContainer()
        configureTitleLabel()
        configureSubtitleLabel()
        configureGoToProgramWebsiteButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension ApolloProgramHeaderCell {

    func configure() {
        contentView.backgroundColor = nil
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
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configureTitleLabel() -> Void {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = program.name
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 18, weight: .medium)
        titleLabel.numberOfLines = 0

        container.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.0),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12.0),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.0)
        ])
    }

    func configureSubtitleLabel() -> Void {
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = university.name
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.minimumScaleFactor = 0.01
        subtitleLabel.adjustsFontSizeToFitWidth = true

        container.addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.0),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.0),
            subtitleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.0)
        ])
    }

    func configureGoToProgramWebsiteButton() -> Void {
        goToProgramWebsiteButton.translatesAutoresizingMaskIntoConstraints = false
        goToProgramWebsiteButton.setTitle("Program's Website", for: .normal)
        goToProgramWebsiteButton.setBackgroundImage(.solidFill(with: .label), for: .normal)
        goToProgramWebsiteButton.tintColor = .inversedLabelColor
        goToProgramWebsiteButton.layer.cornerRadius = 12.0
        goToProgramWebsiteButton.layer.masksToBounds = true
        goToProgramWebsiteButton.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .medium)
        goToProgramWebsiteButton.titleLabel?.textColor = .inversedLabelColor
        goToProgramWebsiteButton.setTitleColor(.label, for: .highlighted)

        goToProgramWebsiteButton.addTarget(nil, action: buttonAction, for: .touchUpInside)

        contentView.addSubview(goToProgramWebsiteButton)
        NSLayoutConstraint.activate([
            goToProgramWebsiteButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.0),
            goToProgramWebsiteButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.0),
            goToProgramWebsiteButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16.0),
            goToProgramWebsiteButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12.0),
            goToProgramWebsiteButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
