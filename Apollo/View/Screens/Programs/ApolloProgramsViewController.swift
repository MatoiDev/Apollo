//
//  ApolloProgramsViewController.swift
//  Apollo
//
//  Created by Matoi on 07.07.2024.
//

import UIKit

final class ApolloProgramsViewController: UIViewController {
    
    private let profiles: [String]
    
    init(profiles: [String]) {
        self.profiles = profiles
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

private extension ApolloProgramsViewController {
    func setupView() -> Void {
        let service: ApolloAPIService = ApolloAPIService.shared
        let viewModel: ApolloProgramViewModel = ApolloProgramViewModel(service: service)
        let view: ApolloProgramsView = ApolloProgramsView(profiles: profiles, viewModel: viewModel)
        
        self.view = view
    }
}


