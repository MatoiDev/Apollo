//
//  ApolloSearchController.swift
//  Apollo
//
//  Created by Matoi on 06.06.2024.
//

import UIKit


protocol ApolloSearchControllerDelegate: AnyObject {
    func collapseKeyboard() -> Void
}


class ApolloSearchController: UISearchController {

    private var viewModel: ApolloSearchViewModel!
    
    weak var presenter: ApolloMainViewControllerPresenter?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() -> Void {
                
        let service: ApolloAPIService = ApolloAPIService.shared
        viewModel = ApolloSearchViewModel(withService: service)
        let searchView: ApolloSearchView = ApolloSearchView(
            searchBar: searchBar,
            viewModel: viewModel
        )
        searchView.presenter = presenter
        view = searchView
        
        let editingOverlayView: ApolloSearchEditingOverlayGestureView = ApolloSearchEditingOverlayGestureView()
        editingOverlayView.mainDelegate = self
        searchBar.inputAccessoryView = editingOverlayView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 1.0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1) {
            self.view.alpha = 0.0
        }
        viewModel.clean()
    }
}


extension ApolloSearchController: ApolloSearchControllerDelegate {
    func collapseKeyboard() {
        searchBar.resignFirstResponder()
    }
}




