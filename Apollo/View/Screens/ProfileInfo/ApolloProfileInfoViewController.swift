//
//  ApolloProfileInfoViewController.swift
//  Apollo
//
//  Created by Matoi on 04.07.2024.
//

import UIKit

protocol ApolloProfileInfoViewControllerPresenter: AnyObject {
    func present(with profiles: [String]) -> Void
}

final class ApolloProfileInfoViewController: UIViewController {
    
    private let olympiad: GroupedOlympiad
    private let profile: ProfileData
    
    init(olympiad: GroupedOlympiad, profile: ProfileData) {
        self.olympiad = olympiad
        self.profile = profile
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ApolloProfileInfoViewController {
    func setupView() -> Void {
        let service: ApolloAPIService = ApolloAPIService.shared
        let viewModel: ApolloProfileInfoViewModel = ApolloProfileInfoViewModel(service: service)
        let view: ApolloProfileInfoView = ApolloProfileInfoView(olympiad: olympiad, profile: profile, viewModel: viewModel)
        
        view.presenter = self
        
        self.view = view
    }
}

extension ApolloProfileInfoViewController: ApolloProfileInfoViewControllerPresenter {
    func present(with profiles: [String]) {
        let vc: ApolloProgramsViewController = ApolloProgramsViewController(profiles: profiles)
        navigationController?.pushViewController(vc, animated: true)
    }
}
