//
//  ApolloProfilesCollectionView.swift
//  Apollo
//
//  Created by Matoi on 26.06.2024.
//

import UIKit


final class ApolloProfilesCollectionView: UICollectionView {

    override init(frame: CGRect = .zero, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension ApolloProfilesCollectionView {
    
    func configure() -> Void {
        backgroundColor = nil
    }
}
