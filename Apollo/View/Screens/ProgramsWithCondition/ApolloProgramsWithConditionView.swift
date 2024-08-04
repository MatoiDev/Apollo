//
//  ApolloProgramsWithConditionView.swift
//  Apollo
//
//  Created by Matoi on 07.07.2024.
//

import UIKit
import Combine


final class ApolloProgramsWithConditionView: UIView {
    
    // Properties
    private let profiles: [String]
    private var olympiads: [Olympiad] = []
    
    // Elements
    private let tableView: UITableView = UITableView()
    
    // Bindings
    private let viewModel: ApolloProgramWithConditionViewModel
    private var subscribers: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(frame: CGRect = .zero, profiles: [String], viewModel: ApolloProgramWithConditionViewModel) {
        self.profiles = profiles.sorted()
        self.viewModel = viewModel
        super.init(frame: frame)
        
        configure()
        configureTableView()
        bindViewToViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension ApolloProgramsWithConditionView {
    
    func configure() -> Void  {
        backgroundColor = .black
    }
    
    func configureTableView() -> Void {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        tableView.showsVerticalScrollIndicator = false
        
        tableView.dataSource = self
        
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func bindViewToViewModel() -> Void {
        
        viewModel.olympiads
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] olympiads in
                guard let self else { return }
                
                self.olympiads = olympiads
                
                tableView.reloadData()
            })
            .store(in: &subscribers)
        
        Task {
            await viewModel.getOlympiads(profiles)
        }
    }
}


extension ApolloProgramsWithConditionView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        olympiads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ApolloProgramWithConditionCell(style: .default, reuseIdentifier: nil, olympiad: olympiads[indexPath.row])
        
        return cell
    }
}
