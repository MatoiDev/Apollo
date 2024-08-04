//
//  ApolloProgramsViewController.swift
//  Apollo
//
//  Created by Matoi on 02.08.2024.
//

import Foundation
import UIKit
import SafariServices


protocol ApolloOlympiadsViewControllerPresenter: AnyObject {
    func present(with url: String) -> Void
}


final class ApolloOlympiadsViewController: UIViewController {

    private let program: Faculty
    private let university: University

    init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil, program: Faculty, university: University) {
        self.program = program
        self.university = university
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension ApolloOlympiadsViewController {
    func setupView() -> Void {
        let service: ApolloAPIService = ApolloAPIService.shared
        let viewModel: ApolloOlympiadsViewModel = ApolloOlympiadsViewModel(service: service)
        let view: ApolloOlympiadsView = ApolloOlympiadsView(program: program, university: university, viewModel: viewModel)

        view.presenter = self

        self.view = view
    }
}


extension ApolloOlympiadsViewController: ApolloOlympiadsViewControllerPresenter {
    func present(with url: String) {
        guard let url: URL = URL(string: url) else { return }

        let safariViewController = SFSafariViewController(url: url)
        safariViewController.dismissButtonStyle = .close
        safariViewController.preferredControlTintColor = .label

        present(safariViewController, animated: true)
    }
}
