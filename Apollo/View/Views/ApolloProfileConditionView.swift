//
//  ApolloProfileConditionView.swift
//  Apollo
//
//  Created by Matoi on 07.07.2024.
//

import UIKit


enum ProfileCondition {
    enum AwardeeType: String {
        case winner = "Победитель"
        case medalist = "Призёр"
    }
    
    enum Grade: Int {
        case ninth = 9, tenth, eleventh
    }
    
    case awardee(_ type: AwardeeType)
    case grade(_ stage: Grade)
    case subject(_ subject: String, _ points: String)
}


final class ApolloProfileConditionView: UIView {
    
    // Properties
    private let condition: ProfileCondition
    
    // Elements
    private let subtitleLabel: UILabel = UILabel()
    private var titleLabel: UILabel?
    private var imageView: UIImageView?
    
    init(frame: CGRect = .zero, condition: ProfileCondition) {
        self.condition = condition
        super.init(frame: frame)
        
        configure()
        if case .awardee(_) = condition { configureImageView() }
        else { configureTitleLabel() }
        
        configureSubtitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension ApolloProfileConditionView {
    
    func configure() -> Void {
        backgroundColor = .apolloCellBackgroundColor
        layer.cornerRadius = 12
    }
    
    func configureTitleLabel() -> Void {
        guard !withoutEntranceTests else { return }
        
        titleLabel = UILabel()
        titleLabel!.translatesAutoresizingMaskIntoConstraints = false
        titleLabel!.text = titleForCondition
        titleLabel!.font = .systemFont(ofSize: 27.0, weight: .bold)
        titleLabel!.textColor = .secondaryLabel
        titleLabel!.adjustsFontSizeToFitWidth = true
        titleLabel!.numberOfLines = 1
        titleLabel!.textAlignment = .center
        
        addSubview(titleLabel!)
        NSLayoutConstraint.activate([
            titleLabel!.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel!.heightAnchor.constraint(equalToConstant: 32.0)
        ])
    }
    
    func configureImageView() -> Void {
        imageView = UIImageView()
        imageView!.translatesAutoresizingMaskIntoConstraints = false
        imageView!.image = imageForCondition
        imageView!.tintColor = .secondaryLabel
        imageView!.contentMode = .scaleAspectFit
        
        addSubview(imageView!)
        NSLayoutConstraint.activate([
            imageView!.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            imageView!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            imageView!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            imageView!.heightAnchor.constraint(equalToConstant: 32.0)
        ])
    }
    
    func configureSubtitleLabel() -> Void {
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = subtitleForBenefit
        subtitleLabel.font = .systemFont(ofSize: 10, weight: .medium)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.numberOfLines = withoutEntranceTests ? 2 : 1
        subtitleLabel.textAlignment = .center
        subtitleLabel.lineBreakMode = .byTruncatingTail
        
        addSubview(subtitleLabel)
        
        switch condition {
        case .awardee(_):
            subtitleLabel.topAnchor.constraint(equalTo: imageView!.bottomAnchor, constant: 8.0).isActive = withoutEntranceTests
            break
        case let .subject(_, points):
            if points == "nil" {
                subtitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12.0).isActive = withoutEntranceTests
            } else {
                subtitleLabel.topAnchor.constraint(equalTo: titleLabel!.bottomAnchor, constant: 8.0).isActive = withoutEntranceTests
            }
            break
        default:
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel!.bottomAnchor, constant: 8.0).isActive = withoutEntranceTests
            break
        }
        
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.0),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.0),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.0)
        ])
    }
    
    var titleForCondition: String {
        switch condition {
        case let .subject(_, points):
            return points == "nil" ? "" : "\(points)"
        case .grade(let stage):
            return "\(stage.rawValue)"
        default:
            return ""
        }
    }
    
    var imageForCondition: UIImage {
        switch condition {
        case .awardee(let type):
            return type == .medalist ? ApolloResources.Images.ApolloCondition.medalist : ApolloResources.Images.ApolloCondition.winner
        default:
            return UIImage()
        }
    }

    var subtitleForBenefit: String {
        switch condition {
        case let .subject(subject, points):
            return points == "nil" ? "Не требует\nподтверждения" : subject
        case .awardee(let type):
            return "\(type.rawValue)"
        case .grade(_):
            return "Класс"
            
        }
    }
    
    var withoutEntranceTests: Bool {
        if case let .subject(_, points) = condition, points == "nil" { return true }
        return false
    }
}
