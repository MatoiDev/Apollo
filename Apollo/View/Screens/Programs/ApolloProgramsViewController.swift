//
//  ApolloProgramsViewController.swift
//  Apollo
//
//  Created by Matoi on 02.08.2024.
//

import Foundation
import UIKit


protocol ApolloProgramsViewControllerPresenter: AnyObject {
    func present(with program: Faculty) -> Void
}


final class ApolloProgramsViewController: UIViewController {

    private let university: University

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, university: University) {
        self.university = university
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationItem.title = university.name
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension ApolloProgramsViewController {
    func setupView() -> Void {
        let service: ApolloAPIService = ApolloAPIService.shared
        let viewModel: ApolloProgramsViewModel = ApolloProgramsViewModel(service: service)
        let view: ApolloProgramsView = ApolloProgramsView(university: university, viewModel: viewModel)

        view.presenter = self

        self.view = view
    }
}


extension ApolloProgramsViewController: ApolloProgramsViewControllerPresenter {
    func present(with program: Faculty) {
        let viewController: ApolloOlympiadsViewController = ApolloOlympiadsViewController(program: program, university: university)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
