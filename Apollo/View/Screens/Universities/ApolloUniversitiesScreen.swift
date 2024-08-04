//
//  UniversitiesView.swift
//  Apollo
//
//  Created by Matoi on 05.06.2024.
//

import UIKit
import Combine


final class ApolloUniversitiesScreen: UIView {
    
    // Properties
    private var universities: [University] = []

    // Elements
    private let tableView: UITableView = UITableView()
    private lazy var footerView: ApolloTableViewSectionFooterWithTextField = ApolloTableViewSectionFooterWithTextField(frame: CGRectMake(0, 0, tableView.bounds.width, 44), title: "Universities")
    
    // Bindings
    private let viewModel: ApolloUniversitiesScreenViewModel
    private var subscribers: Set<AnyCancellable> = Set<AnyCancellable>()

    weak var presenter: ApolloUniversitiesViewControllerPresenter?

    init(frame: CGRect = .zero, viewModel: ApolloUniversitiesScreenViewModel) {
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


private extension ApolloUniversitiesScreen {

    func bindViewToViewModel() -> Void {
        footerView.textField.textPublisher
                .debounce(for: 0.5, scheduler: RunLoop.main)
                .sink { [weak viewModel] textInput in
                    guard let viewModel else { return }
                    viewModel.searchText = textInput
                }
                .store(in: &subscribers)

        viewModel.$universities
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] universities in
                    guard let self else { return  }
                    self.universities = universities.sorted(by: { $0.id < $1.id })
                    tableView.reloadSections(IndexSet(integer: 1), with: .none)
                })
                .store(in: &subscribers)
    }

    func configure() -> Void {
        backgroundColor = .apolloBackgroundColor
    }

    func configureTableView() -> Void {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.backgroundColor = .apolloBackgroundColor

        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}


extension ApolloUniversitiesScreen: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        return universities.isEmpty ? 3 : universities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let service: ApolloAPIService = ApolloAPIService.shared

        switch indexPath.section {
        case 0:
            let vm: ApolloUniversitiesScreenHeaderCellViewModel = ApolloUniversitiesScreenHeaderCellViewModel(service: service)
            let cell = ApolloUniversitiesScreenHeaderCell(style: .default, reuseIdentifier: nil, viewModel: vm)

            return cell
        case 1:
            guard !universities.isEmpty else {
                return ApolloStubCell()
            }
            let vm: ApolloUniversityCellViewModel = ApolloUniversityCellViewModel(service: service)
            let cell: ApolloUniversityCell = ApolloUniversityCell(
                    style: .default,
                    reuseIdentifier: nil,
                    university: universities[indexPath.row],
                    viewModel: vm
            )

            return cell
        default:
            return UITableViewCell()
        }
    }

    public func numberOfSections(in tableView: UITableView) -> Int { 2 }
}


extension ApolloUniversitiesScreen: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section != 0, !universities.isEmpty else { return }
        let universityToPresent: University = universities[indexPath.row]

        presenter?.present(with: universityToPresent)
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 148.0
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let editingOverlayView: ApolloSearchEditingOverlayGestureView = ApolloSearchEditingOverlayGestureView()
        
            editingOverlayView.mainDelegate = self
            footerView.textField.inputAccessoryView = editingOverlayView

            footerView.textField.delegate = self

            return footerView
        }
        return nil
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 { return 58.0 }
        return 0.0
    }
}


extension ApolloUniversitiesScreen: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        collapseKeyboard()
        return true
    }
}


extension ApolloUniversitiesScreen: ApolloSearchControllerDelegate {
    func collapseKeyboard() {
        footerView.textField.resignFirstResponder()
    }
}
