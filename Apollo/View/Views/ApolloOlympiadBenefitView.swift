//
//  ApolloBenefitView.swift
//  Apollo
//
//  Created by Matoi on 26.06.2024.
//

import UIKit

enum OlympiadBenefit {
    case level(_ value: String)
    case score(_ value: String)
}

final class ApolloOlympiadBenefitView: UIView {
    
    private let titleLabel: UILabel = UILabel()
    private let subtitleLabel: UILabel = UILabel()
    private let benefit: OlympiadBenefit
    
    init(frame: CGRect = .zero, benefit: OlympiadBenefit) {
        self.benefit = benefit
        super.init(frame: frame)
        
        configure()
        configureTitleLabel()
        configureSubtitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension ApolloOlympiadBenefitView {
    
    func configure() -> Void {
        backgroundColor = .apolloCellBackgroundColor
        layer.cornerRadius = 24
    }
    
    func configureTitleLabel() -> Void {
        guard !withoutEntranceTests else { return }
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = titleForBenefit
        titleLabel.font = .systemFont(ofSize: 50, weight: .bold)
        titleLabel.textColor = .secondaryLabel
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
    func configureSubtitleLabel() -> Void {

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = subtitleForBenefit
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.numberOfLines = withoutEntranceTests ? 2 : 1
        subtitleLabel.textAlignment = .center
        subtitleLabel.lineBreakMode = .byTruncatingTail
        
        addSubview(subtitleLabel)
        
        subtitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12.0).isActive = withoutEntranceTests
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.0),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.0),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.0)
        ])
    }
    
    var titleForBenefit: String {
        switch benefit {
        case .level(let level):
            return "\(level)"
        case .score(let score):
            return "≈\(score)"
        }
    }
    
    var subtitleForBenefit: String {
        switch benefit {
        case .level(let value):
            return value == "S" ? "Ранг" : "Уровень РСОШ*"
        case .score(let score):
            return score == "nil" ? "Не требует\nподтверждения" : "Мин. балл для БВИ"
        }
    }
    
    var withoutEntranceTests: Bool {
        if case let .score(value) = benefit, value == "nil" { return true }
        return false
    }
}
