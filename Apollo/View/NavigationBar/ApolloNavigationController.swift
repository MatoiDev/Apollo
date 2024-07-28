//
//  ApolloNavigationController.swift
//  Apollo
//
//  Created by Matoi on 05.06.2024.
//

import UIKit

final class ApolloNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    private func configure() -> Void {
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
        UINavigationBar.appearance().tintColor = .label
        
        view.backgroundColor = .apolloNavigationControllerBackgroundColor
    }
}
