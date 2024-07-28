//
//  ApolloOlympiadCell.swift
//  Apollo
//
//  Created by Matoi on 18.06.2024.
//

import UIKit

final class ApolloOlympiadResultCell: UITableViewCell {
    
    // Elements
    private let container: UIView = UIView()
    private let nameLabel: UILabel = UILabel()
    private let profileLabel: UILabel = UILabel()
    private let conditionLabel: UILabel = UILabel()
    
    // Properties
    private let olympiad: GroupedOlympiad

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, olympiad: GroupedOlympiad) {
        self.olympiad = olympiad
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        configureContainer()
        configureNameLabel()
        configureProfileLabel()
        configureConditionLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension ApolloOlympiadResultCell {
    
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
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6.0),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6.0)
        ])
    }
    
    func configureNameLabel() -> Void {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = olympiad.name
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
        if olympiad.profiles.count == 1 {
            profileLabel.text = "\(olympiad.profiles.first!.key)"
        } else {
            profileLabel.text = String.profiles(olympiad.profiles.count)
        }
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
        
        if olympiad.score.lowercased() != "nil" { conditionLabel.text = "Подтверждение • \(olympiad.score)" }
        else { conditionLabel.text = "Не требует подтверждения" }
        
        container.addSubview(conditionLabel)
        NSLayoutConstraint.activate([
            conditionLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.0),
            conditionLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16.0)
        ])
    }
}
