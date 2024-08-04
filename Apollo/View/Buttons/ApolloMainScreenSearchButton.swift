//
//  ApolloMainScreenSearchButton.swift
//  Apollo
//
//  Created by Matoi on 17.06.2024.
//

import UIKit


final class ApolloMainScreenSearchButton: UIButton {
    
    // Elements
    private let primaryLabel: UILabel = UILabel()
    private let secondaryLabel: UILabel = UILabel()
    private let leadingImageView: UIImageView = UIImageView()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        configure()
        configureLeadingImageView()
        configurePrimaryLabel()
        configureSecondaryLabel()
    }
    
    private func configure() -> Void {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .apolloButtonBackgroundColor
        layer.cornerRadius = 22
        layer.shadowOpacity = 0.7
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 0, height: 3)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension ApolloMainScreenSearchButton {
    
    func configureLeadingImageView() -> Void {
        leadingImageView.translatesAutoresizingMaskIntoConstraints = false
        leadingImageView.image = ApolloResources.Images.MainView.searchFieldLeadingImage
        leadingImageView.contentMode = .scaleAspectFit
        leadingImageView.tintColor = .label
        
        addSubview(leadingImageView)
        NSLayoutConstraint.activate([
            leadingImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            leadingImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            leadingImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.0),
            leadingImageView.widthAnchor.constraint(equalToConstant: 32.0),
            leadingImageView.heightAnchor.constraint(equalToConstant: 32.0)
        ])
    }
    
    func configurePrimaryLabel() -> Void {
        primaryLabel.translatesAutoresizingMaskIntoConstraints = false
        primaryLabel.textColor = .label
        primaryLabel.text = "Search in Apollo"
        primaryLabel.font = .systemFont(ofSize: 20.0, weight: .medium)
        
        addSubview(primaryLabel)
        NSLayoutConstraint.activate([
            primaryLabel.leadingAnchor.constraint(equalTo: leadingImageView.trailingAnchor, constant: 16.0),
            primaryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            primaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0)
        ])
    }
    
    func configureSecondaryLabel() -> Void {
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.textColor = .secondaryLabel
        secondaryLabel.text = "Olympiad • University"
        secondaryLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        
        addSubview(secondaryLabel)
        NSLayoutConstraint.activate([
            secondaryLabel.leadingAnchor.constraint(equalTo: leadingImageView.trailingAnchor, constant: 16.0),
            secondaryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.0),
            secondaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0)
        ])
    }
}
