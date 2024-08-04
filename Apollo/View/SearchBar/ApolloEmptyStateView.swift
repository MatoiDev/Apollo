//
//  ApolloEmptyStateView.swift
//  Apollo
//
//  Created by Matoi on 18.06.2024.
//

import UIKit


enum ApolloEmptyState {
    case noResults
    case noInput
    case error(_ description: String)
}


final class ApolloEmptyStateView: UIView {
    
    private let container: UIView = UIView()
    private let imageView: UIImageView = UIImageView()
    private let label: UILabel = UILabel()
    private var state: ApolloEmptyState
    
    init(frame: CGRect = .zero, state: ApolloEmptyState = .noInput) {
        self.state = state
        super.init(frame: frame)
        
        configure()
        configureContainer()
        configureImageView()
        configureLabel()
    }
    
    func updateState(with newState: ApolloEmptyState) -> Void {
        state = newState
        label.text = titleForState()
        imageView.image = imageForState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension ApolloEmptyStateView {
    
    func configure() -> Void {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }
    
    func configureContainer() -> Void {
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = nil
        
        addSubview(container)
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configureImageView() -> Void {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        
        container.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 72.0)
        ])
    }
    
    func configureLabel() -> Void {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.text = titleForState()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.01
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        
        container.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
    
    func titleForState() -> String {
        switch state {
        case .error(let description):
            return description
        case .noInput:
            return "Search in Apollo"
        case .noResults:
            return "No results found"
        }
    }
    
    func imageForState() -> UIImage {
        switch state {
        case .error(_):
            return UIImage(systemName: "exclamationmark.triangle")!
        case .noInput:
            return UIImage(systemName: "magnifyingglass")!
        case .noResults:
            return UIImage(systemName: "questionmark.diamond")!
        }
    }
}
