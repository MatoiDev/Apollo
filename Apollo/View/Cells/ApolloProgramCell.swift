//
//  ApolloProgramCell.swift
//  Apollo
//
//  Created by Matoi on 07.07.2024.
//

import UIKit
import Combine

final class ApolloProgramCell: UITableViewCell {
    // Properties
    private let olympiad: Olympiad
    
    // Elements
    private let container: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let conditionStackView: UIStackView = UIStackView()
    private var awardeeView: ApolloProfileConditionView!
    private var gradeView: ApolloProfileConditionView!
    private var subjectView: ApolloProfileConditionView!


    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, olympiad: Olympiad) {
        self.olympiad = olympiad
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        configureContainer()
        configureTitleLabel()
        configureStackView()
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension ApolloProgramCell {
    func configure() -> Void {
        backgroundColor = .inversedLabelColor
        contentView.backgroundColor = .inversedLabelColor
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
        titleLabel.text = olympiad.faculty
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 16.0, weight: .medium)
        
        container.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.0),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12.0),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.0)
        ])
    }
    
    func configureStackView() -> Void {
        conditionStackView.translatesAutoresizingMaskIntoConstraints = false
        conditionStackView.axis = .horizontal
        conditionStackView.backgroundColor = nil
        conditionStackView.spacing = 16
        conditionStackView.distribution = .fillEqually
        
        configureAwardeeConditionView()
        configureGradeConditionView()
        configureSubjectConditionView()
                
        contentView.addSubview(conditionStackView)
        NSLayoutConstraint.activate([
            conditionStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.0),
            conditionStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12.0),
            conditionStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.0),
            conditionStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.0),
            conditionStackView.heightAnchor.constraint(equalToConstant: 64.0)
        ])
    }
    
    
    func configureAwardeeConditionView() -> Void {
        
        let type: ProfileCondition.AwardeeType = {
            if olympiad.condition.lowercased().contains("призёр") { return .medalist }
            return .winner
        }()
        
        awardeeView = ApolloProfileConditionView(condition: .awardee(type))
        conditionStackView.addArrangedSubview(awardeeView)
    }
    
    func configureGradeConditionView() -> Void {
        
        let stage: ProfileCondition.Grade = {
            switch olympiad.grade {
            case "9":
                return .ninth
            case "10":
                return .tenth
            case "11":
                return .eleventh
            default:
                fatalError("Unknown grade. Olympiad diplomas must be obtained in grades 9-11.")
            }
        }()
        
        gradeView = ApolloProfileConditionView(condition: .grade(stage))
        conditionStackView.addArrangedSubview(gradeView)
    }
    
    func configureSubjectConditionView() -> Void {
        subjectView = ApolloProfileConditionView(condition: .subject(olympiad.subject, olympiad.score))
        conditionStackView.addArrangedSubview(subjectView)
    }
    
}
