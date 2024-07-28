//
//  ApolloUniversitiesViewController.swift
//  Apollo
//
//  Created by Matoi on 05.06.2024.
//

import UIKit

protocol ApolloUniversitiesViewControllerPresenter: AnyObject {
    
    func present(with: University) -> Void
    
}

final class ApolloUniversitiesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
}


private extension ApolloUniversitiesViewController {
    func setupView() -> Void {
        let service: ApolloAPIService = ApolloAPIService.shared
        let viewModel: ApolloUniversitiesScreenViewModel = ApolloUniversitiesScreenViewModel(service: service)
        let view: ApolloUniversitiesScreen = ApolloUniversitiesScreen(viewModel: viewModel)

        view.presenter = self

        self.view = view
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension ApolloUniversitiesViewController: ApolloUniversitiesViewControllerPresenter {
    func present(with university: University) -> Void {
        let viewController: ApolloUniversityInfoViewController = ApolloUniversityInfoViewController(university: university)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}
