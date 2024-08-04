//
//  MainView.swift
//  Apollo
//
//  Created by Matoi on 05.06.2024.
//

import UIKit
import Combine


final class ApolloMainScreen: UIView {

    // Elements
    private let apolloLabel: UILabel = UILabel()
    private let quoteLabel: UILabel = UILabel()
    private let backgroundImageView: UIImageView = UIImageView()
    private let searchButton: ApolloMainScreenSearchButton = ApolloMainScreenSearchButton()
    
    weak var delegate: ApolloMainViewControllerDelegate?
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        configureView()
        configureBackgroundImage()
        configureApolloLabel()
        configureQuoteLabel()
        configureSearchButton()
    }
    
    private func configureView() -> Void  {
        backgroundColor = .apolloBackgroundColor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


private extension ApolloMainScreen {
    
    func configureApolloLabel() -> Void {
        apolloLabel.translatesAutoresizingMaskIntoConstraints = false
        apolloLabel.text = "Apollo"
        apolloLabel.font = .systemFont(ofSize: 80, weight: .bold)
        apolloLabel.textColor = .label
        apolloLabel.minimumScaleFactor = 0.1
        apolloLabel.adjustsFontSizeToFitWidth = true
        apolloLabel.lineBreakMode = .byClipping
        apolloLabel.numberOfLines = 1
        
        addSubview(apolloLabel)
        NSLayoutConstraint.activate([
            apolloLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            apolloLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            apolloLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.6)
        ])
    }
    
    func configureQuoteLabel() -> Void {
        quoteLabel.translatesAutoresizingMaskIntoConstraints = false
        quoteLabel.text = "YOUR\nKNOWLEDGE\nIS YOUR\nPOWER"
        quoteLabel.font = .systemFont(ofSize: 50, weight: .light)
        quoteLabel.textColor = .label
        quoteLabel.lineBreakMode = .byTruncatingTail
        quoteLabel.numberOfLines = 4
        quoteLabel.minimumScaleFactor = 0.01
        quoteLabel.adjustsFontSizeToFitWidth = true
        
        addSubview(quoteLabel)
        NSLayoutConstraint.activate([
            quoteLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -32.0),
            quoteLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            quoteLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -64.0)
        ])
    }
    
    func configureBackgroundImage() -> Void {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.image = ApolloResources.Images.MainView.backgroundImage
        
        addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo:trailingAnchor),
            backgroundImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7),
            backgroundImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.7)
        ])
    }
    
    func configureSearchButton() -> Void {
        searchButton.addTarget(self, action: #selector(callSearchController), for: .touchUpInside)
        
        addSubview(searchButton)
        NSLayoutConstraint.activate([
            searchButton.heightAnchor.constraint(equalToConstant: 72.0),
            searchButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            searchButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            searchButton.topAnchor.constraint(lessThanOrEqualTo: quoteLabel.bottomAnchor, constant: 64.0),
            searchButton.bottomAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -32.0)
        ])
    }
    
    @objc func callSearchController() -> Void {
        delegate?.callApolloSearchViewController()
    }
}
