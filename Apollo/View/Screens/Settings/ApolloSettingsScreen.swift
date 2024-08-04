//
//  SettingsView.swift
//  Apollo
//
//  Created by Matoi on 05.06.2024.
//

import UIKit


final class ApolloSettingsScreen: UIView {
    
    // Elements
    private let authorView: ApolloAuthorView = ApolloAuthorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureAuthorView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension ApolloSettingsScreen {
    
    func configureAuthorView() -> Void {
        authorView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(authorView)
        NSLayoutConstraint.activate([
            authorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            authorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
