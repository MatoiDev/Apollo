//
//  ApolloUniversityInfoViewController.swift
//  Apollo
//
//  Created by Matoi on 25.06.2024.
//

import UIKit
import SafariServices

protocol ApolloUniversityInfoViewControllerPresenter: AnyObject {
    func popCurrentViewController() -> Void
    func present(with olympiadURLString: String) -> Void
}

final class ApolloUniversityInfoViewController: UIViewController {

    private let university: University

    init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil, university: University) {
        self.university = university
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ApolloUniversityInfoViewController {
    func setupView() -> Void {
        let service: ApolloAPIService = ApolloAPIService.shared
        let viewModel: ApolloUniversityInfoViewModel = ApolloUniversityInfoViewModel(service: service)
        let view: ApolloUniversityInfoView = ApolloUniversityInfoView(
                university: university,
                viewModel: viewModel
        )

        view.presenter = self

        self.view = view
    }
}

extension ApolloUniversityInfoViewController: ApolloUniversityInfoViewControllerPresenter {
    func present(with olympiadURLString: String) {
        guard let url: URL = URL(string: olympiadURLString) else { return }

        let safariViewController = SFSafariViewController(url: url)
        safariViewController.dismissButtonStyle = .close
        safariViewController.preferredControlTintColor = .label

        present(safariViewController, animated: true)
    }

    func popCurrentViewController() {
        navigationController?.popViewController(animated: true)
    }
}
