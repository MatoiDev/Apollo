//
//  ApolloProgramsWithConditionViewController.swift
//  Apollo
//
//  Created by Matoi on 07.07.2024.
//

import UIKit


final class ApolloProgramsWithConditionViewController: UIViewController {
    
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


private extension ApolloProgramsWithConditionViewController {
    func setupView() -> Void {
        let service: ApolloAPIService = ApolloAPIService.shared
        let viewModel: ApolloProgramWithConditionViewModel = ApolloProgramWithConditionViewModel(service: service)
        let view: ApolloProgramsWithConditionView = ApolloProgramsWithConditionView(profiles: profiles, viewModel: viewModel)
        
        self.view = view
    }
}


