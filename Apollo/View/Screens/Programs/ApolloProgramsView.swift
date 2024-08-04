//
//  ApolloProgramsView.swift
//  Apollo
//
//  Created by Matoi on 02.08.2024.
//

import Foundation
import UIKit
import Combine


final class ApolloProgramsView: UIView {
    // Properties
    private let university: University
    private var programs: [Faculty] = []

    // Elements
    private let tableView: UITableView = UITableView()

    // Bindings
    private let viewModel: ApolloProgramsViewModel
    private var subscribers: Set<AnyCancellable> = Set<AnyCancellable>()

    weak var presenter: ApolloProgramsViewControllerPresenter?

    init(frame: CGRect = .zero, university: University, viewModel: ApolloProgramsViewModel) {
        self.university = university
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


private extension ApolloProgramsView {

    func configure() -> Void  {
        backgroundColor = .black
    }

    func configureTableView() -> Void {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .inversedLabelColor

        tableView.dataSource = self
        tableView.delegate = self

        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func bindViewToViewModel() -> Void {
        viewModel.programs
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] faculties in
                    guard let self else { return }
                    self.programs = faculties.sorted(by: { $0.name < $1.name  })

                    tableView.reloadData()
                })
                .store(in: &subscribers)

        Task {
            await viewModel.getFacultiesFor(university: university)
        }
    }
}


extension ApolloProgramsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        programs.isEmpty ? 3 : programs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !programs.isEmpty else { return ApolloStubCell() }
        let cell = ApolloProgramCell(program: programs[indexPath.row])
        return cell
    }
}


extension ApolloProgramsView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !programs.isEmpty else { return }
        presenter?.present(with: programs[indexPath.row])
    }
}
