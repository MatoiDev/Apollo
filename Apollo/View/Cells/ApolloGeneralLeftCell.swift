//
//  ApolloGeneralLeftView.swift
//  Apollo
//
//  Created by Matoi on 04.07.2024.
//

import UIKit
import Combine


final class ApolloGeneralLeftCell: UITableViewCell {
    
    // Properties
    private var title: String?
    private let subtitle: String
    private let image: UIImage
    
    // Elements
    private let titleLabel: UILabel = UILabel()
    private let subtitleLabel: UILabel = UILabel()
    private let leftImageView: UIImageView = UIImageView()
    private let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    // Bindings
    private lazy var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, title: String?, subtitle: String, image: UIImage) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        configureImageView()
        configureTitleLabel()
        
        configureSubtitleLabel()
    }
    
    convenience init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, futureTitle: PassthroughSubject<String, Error>, subtitle: String, image: UIImage, throwingLevel: String) {
        
        self.init(style: style, reuseIdentifier: reuseIdentifier, title: "\(throwingLevel)* Уровень", subtitle: subtitle, image: image)
        
        configureFetchingIndicatorView()
        
        observe(futureTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension ApolloGeneralLeftCell {
    
    func configure() {
        backgroundColor = .apolloBackgroundColor
        contentView.backgroundColor = .apolloBackgroundColor
        selectionStyle = .none
    }
    
    func configureImageView() -> Void {
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        leftImageView.image = image
        leftImageView.contentMode = .scaleAspectFit
        leftImageView.tintColor = .label
        
        contentView.addSubview(leftImageView)
        NSLayoutConstraint.activate([
            leftImageView.widthAnchor.constraint(equalToConstant: 36),
            leftImageView.heightAnchor.constraint(equalToConstant: 36),
            leftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            leftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13.0),
            leftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13.0)
        ])
    }
    
    func configureTitleLabel() -> Void {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 14.0, weight: .medium)
        titleLabel.text = title
        titleLabel.textColor = .label
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 1
        
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 12.0),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14.0)
        ])
    }
    
    func configureFetchingIndicatorView() -> Void {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        
        indicator.startAnimating()
        
        contentView.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 12.0),
            indicator.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            indicator.heightAnchor.constraint(equalToConstant: 6.0),
            indicator.widthAnchor.constraint(equalToConstant: 6.0)
        ])
    }
    
    func configureSubtitleLabel() -> Void {
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 12.0, weight: .medium)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.lineBreakMode = .byTruncatingTail
        subtitleLabel.numberOfLines = 1
        
        contentView.addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 12.0),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14.0)
        ])
    }
    
    func observe(_ title: PassthroughSubject<String, Error>) -> Void {
        title
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                
                if case .failure(_) = completion { indicator.stopAnimating() }
            } receiveValue: { [weak self] title in
                guard let self else { return }
                
                self.title = "\(title) Уровень"
                
                UIView.animate(withDuration: 0.5) {
                    self.indicator.stopAnimating()
                    self.titleLabel.text = self.title
                }
            }.store(in: &cancellables)
    }
}
