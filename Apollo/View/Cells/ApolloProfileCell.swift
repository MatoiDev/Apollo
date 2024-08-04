//
//  ApolloProfileCell.swift
//  Apollo
//
//  Created by Matoi on 26.06.2024.
//

import UIKit


final class ApolloProfileCell: UICollectionViewCell {
    
    // Poperties
    var profileData: ProfileData!
    
    // Elements
    let nameLabel: UILabel = UILabel()
    let universitiesLabel: UILabel = UILabel()
    let specialitiesLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        configureNameLabel()
        configureUniversitiesLabel()
        configureSpecialitiesLabel()
    }
    
    func setDataToCell(_ profileData: ProfileData) -> Void {
        self.profileData = profileData
        
        updateCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension ApolloProfileCell {
    
    func configure() -> Void {
        clipsToBounds = true
        backgroundColor = .apolloCellBackgroundColor
        layer.cornerRadius = 24
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureNameLabel() -> Void {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .label
        nameLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        nameLabel.numberOfLines = 2
        nameLabel.lineBreakMode = .byTruncatingTail
    
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.0),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.0)
        ])
    }
    
    func configureUniversitiesLabel() -> Void {
        universitiesLabel.translatesAutoresizingMaskIntoConstraints = false
        universitiesLabel.textColor = .secondaryLabel
        universitiesLabel.font = .systemFont(ofSize: 12.0, weight: .medium)
        universitiesLabel.numberOfLines = 1
    
        contentView.addSubview(universitiesLabel)
        NSLayoutConstraint.activate([
            universitiesLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6.0),
            universitiesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.0),
            universitiesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.0)
        ])
    }
    
    func configureSpecialitiesLabel() -> Void {
        specialitiesLabel.translatesAutoresizingMaskIntoConstraints = false
        specialitiesLabel.textColor = .secondaryLabel
        specialitiesLabel.font = .systemFont(ofSize: 12.0, weight: .medium)
        specialitiesLabel.numberOfLines = 1
    
        contentView.addSubview(specialitiesLabel)
        NSLayoutConstraint.activate([
            specialitiesLabel.topAnchor.constraint(equalTo: universitiesLabel.bottomAnchor, constant: 4.0),
            specialitiesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.0),
            specialitiesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.0),
            specialitiesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.0)
        ])
    }
    
    func updateCell() -> Void {
        nameLabel.text = profileData.name
        universitiesLabel.text = String.universities(universitiesCount)
        specialitiesLabel.text = String.programs(programsCount)
    }
    
    var universitiesCount: Int {
        profileData.idsByUniversities.count
    }
    
    var programsCount: Int {
        var res: Int = 0
        for ids in profileData.idsByUniversities.values {
            res += ids.count
        }
        return res
    }
}
