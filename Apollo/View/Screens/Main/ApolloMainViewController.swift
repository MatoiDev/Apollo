//
//  ApolloMainViewController.swift
//  Apollo
//
//  Created by Matoi on 05.06.2024.
//

import UIKit

protocol ApolloMainViewControllerDelegate: AnyObject {
    func callApolloSearchViewController() -> Void
}

protocol ApolloMainViewControllerPresenter: AnyObject {
    func present(with olympiad: GroupedOlympiad) -> Void
    func present(with university: University) -> Void
}

final class ApolloMainViewController: UIViewController {
    
    let searchController: ApolloSearchController = ApolloSearchController()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() -> Void {
        let mainScreen = ApolloMainScreen()
        
        mainScreen.delegate = self
        searchController.searchBar.delegate = self
        searchController.presenter = self
        
        view = mainScreen
    
        navigationItem.searchController = searchController
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
    }
}

extension ApolloMainViewController: ApolloMainViewControllerDelegate {
    func callApolloSearchViewController() {
        view.isHidden = true
        navigationController?.setNavigationBarHidden(false, animated: true)
        searchController.searchBar.becomeFirstResponder()
    }
}

extension ApolloMainViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.isHidden = false
    }
}

extension ApolloMainViewController: ApolloMainViewControllerPresenter {
    func present(with olympiad: GroupedOlympiad) {
        let viewController: ApolloOlympiadInfoViewController = ApolloOlympiadInfoViewController(with: olympiad)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func present(with university: University) {
        dump(university)
    }
}
