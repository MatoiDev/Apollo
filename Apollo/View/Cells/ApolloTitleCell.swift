//
//  ApolloTitleCell.swift
//  Apollo
//
//  Created by Matoi on 05.07.2024.
//

import UIKit

final class ApolloTitleCell: UITableViewCell {
    
    private let label: UILabel = UILabel()
    private let title: String
    
    // Properties
    private let fontSize: CGFloat
    private let verticalPadding: CGFloat
    private let horizontalPadding: CGFloat
    private let fontWeight: UIFont.Weight
    
    init(style: UITableViewCell.CellStyle = .default,
         reuseIdentifier: String? = nil,
         title: String,
         fontSize: CGFloat = 24.0,
         fontWeight: UIFont.Weight = .bold,
         verticalPadding: CGFloat = 16.0,
         horizontalPadding: CGFloat = 16.0
    ) {
        self.title = title
        self.fontSize = fontSize
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
        self.fontWeight = fontWeight
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        configureTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ApolloTitleCell {
    
    func configure() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    func configureTitleLabel() -> Void {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: fontSize, weight: fontWeight)
        label.textColor = .label
        label.text = title
        
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalPadding),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding),
        ])
    }
}

