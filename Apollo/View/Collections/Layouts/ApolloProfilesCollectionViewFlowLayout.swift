//
//  ApolloProfilesCollectionViewFlowLayout.swift
//  Apollo
//
//  Created by Matoi on 26.06.2024.
//

import UIKit


final class ApolloProfilesCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


private extension ApolloProfilesCollectionViewFlowLayout {
    
    func configure() -> Void { }
}
