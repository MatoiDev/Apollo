//
// Created by Matoi on 02.08.2024.
//

import Foundation
import UIKit

final class ApolloOlympiadCell: UITableViewCell {

    // Properties
    private var olympiad: Olympiad?

    // Elements
    private let container: UIView = UIView()
    private let nameLabel: UILabel = UILabel()
    private let profileLabel: UILabel = UILabel()
    private let conditionLabel: UILabel = UILabel()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
        configureContainer()
        configureNameLabel()
        configureProfileLabel()
        configureConditionLabel()
    }

    func configureWithOlympiad(_ olympiad: Olympiad) -> Void {
        self.olympiad = olympiad
        updateCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension ApolloOlympiadCell {

    func configure() {
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

    func configureNameLabel() -> Void {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 16.0, weight: .medium)
        nameLabel.minimumScaleFactor = 1
        nameLabel.textColor = .label
        nameLabel.numberOfLines = 2
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.lineBreakMode = .byTruncatingTail

        container.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.0),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.0),
            nameLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.0)
        ])
    }

    func configureProfileLabel() -> Void {
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        profileLabel.font = .systemFont(ofSize: 12.0, weight: .regular)
        profileLabel.minimumScaleFactor = 0.01
        profileLabel.textColor = .secondaryLabel
        profileLabel.numberOfLines = 1
        profileLabel.adjustsFontSizeToFitWidth = true

        container.addSubview(profileLabel)
        NSLayoutConstraint.activate([
            profileLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.0),
            profileLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.0),
            profileLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8.0)
        ])
    }

    func configureConditionLabel() -> Void {
        conditionLabel.translatesAutoresizingMaskIntoConstraints = false
        conditionLabel.font = .systemFont(ofSize: 12.0, weight: .medium)
        conditionLabel.minimumScaleFactor = 0.01
        conditionLabel.textColor = .secondaryLabel
        conditionLabel.adjustsFontSizeToFitWidth = true

        container.addSubview(conditionLabel)
        NSLayoutConstraint.activate([
            conditionLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.0),
            conditionLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16.0)
        ])
    }

    func updateCell() -> Void {
        nameLabel.text = olympiad!.name
        profileLabel.text = "\(olympiad!.profile)"
        if olympiad!.score.lowercased() != "nil" { 
            conditionLabel.text = "\(olympiad!.condition.lowercased().contains("призёр") ? "Призёр" : "Победитель") • \(olympiad!.score)"
        }
        else { conditionLabel.text = "Не требует подтверждения" }
    }
}
