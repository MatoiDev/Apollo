//
//  SearchView.swift
//  Apollo
//
//  Created by Matoi on 17.06.2024.
//

import UIKit
import Combine


class ApolloSearchView: UIView {
    
    // Elements
    private let tableView: UITableView = UITableView()
    private let searchBar: UISearchBar!
    private let emptyStateView: ApolloEmptyStateView = ApolloEmptyStateView()
    private var emptyStateViewBottomConstraint: NSLayoutConstraint? // UIKeyboardLayoutGuide alternative with ios 13 support
    
    // Properties
    private var olympiads: [GroupedOlympiad] = []
    private var universities: [University] = []
    
    // Bindings
    private let viewModel: ApolloSearchViewModel!
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // Delegates
    weak var presenter: ApolloMainViewControllerPresenter?
    
    init(frame: CGRect = .zero, searchBar: UISearchBar, viewModel: ApolloSearchViewModel) {
        self.viewModel = viewModel
        self.searchBar = searchBar
        super.init(frame: frame)
        
        configureTableView()
        configureSearchBar()
        configureEmptyStateView()
        
        bindViewToViewModel()
        registerNotifications() // UIKeyboardLayoutGuide alternative with ios 13
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension ApolloSearchView {
    
    func configureEmptyStateView() -> Void {
        emptyStateView.isHidden = true
        
        addSubview(emptyStateView)
        emptyStateViewBottomConstraint = emptyStateView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -32)
        NSLayoutConstraint.activate([
            emptyStateView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            emptyStateView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.0),
            emptyStateView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32.0)
        ])
        emptyStateViewBottomConstraint?.isActive = true
    }
    
    func configureSearchBar() -> Void {
        searchBar.placeholder = "Olympiad • University"
        searchBar.autocorrectionType = .no
        searchBar.autocapitalizationType = .none
        searchBar.searchTextField.adjustsFontSizeToFitWidth = true
    }
    
    func configureTableView() -> Void {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func bindViewToViewModel() -> Void {
        searchBar.searchTextField.textPublisher
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .sink { [weak viewModel] textInput in
                guard let viewModel else { return }
                
                viewModel.searchText = textInput
            }
            .store(in: &cancellables)
        
        viewModel.$fetched
            .receive(on: RunLoop.main)
            .sink { [weak self] fetched in
                guard let self else { return }
                
                self.olympiads = fetched.olympiads
                self.universities = fetched.universities
                
                if !self.olympiads.isEmpty || !self.universities.isEmpty { // Прячем emptyView если с сервера поступило хоть что-то
                    emptyStateView.isHidden = true
                } else { // Если оба результата пустые, то мы показываем это
                    emptyStateView.updateState(with: self.searchBar.text == "" ? .noInput : .noResults)
                    emptyStateView.isHidden = false
                }
                
                tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$errorLog
            .receive(on: RunLoop.main)
            .sink { [weak self] description in
                guard let self, let description else { return }
                emptyStateView.updateState(with: .error(description)) // Обработка ошибки
                emptyStateView.isHidden = false
            }
            .store(in: &cancellables)
    }
    
    func registerNotifications() -> Void { // UIKeyboardLayoutGuide alternative with ios 13
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] _ in
                self?.keyboardWillHide()
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak self] notification in
                self?.keyboardWillShow(notification)
            }
            .store(in: &cancellables)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let convertedFrame = self.convert(frame, from: nil)
        let keyboardHeight = self.bounds.height - convertedFrame.minY
        emptyStateViewBottomConstraint?.constant = -keyboardHeight + 64
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    private func keyboardWillHide() {
        emptyStateViewBottomConstraint?.constant = -32
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}


extension ApolloSearchView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard !universities.isEmpty else { return cellForOlympiad(at: indexPath) }
            return cellForUniversity(at: indexPath)
        case 1:
            return cellForOlympiad(at: indexPath)
        default:
            fatalError("Unexpected section")
        }
    }

    private func cellForUniversity(at indexPath: IndexPath) -> UITableViewCell {
        let service: ApolloAPIService = ApolloAPIService.shared
        let cellViewModel: ApolloUniversityResultViewModel = ApolloUniversityResultViewModel(service: service)
        
        let cell: ApolloUniversityResultCell = ApolloUniversityResultCell(
            style: .default,
            reuseIdentifier: nil,
            university: universities[indexPath.row],
            viewModel: cellViewModel
        )
        
        return cell
    }

    private func cellForOlympiad(at indexPath: IndexPath) -> UITableViewCell {
        let cell: ApolloOlympiadResultCell = ApolloOlympiadResultCell(
            style: .default,
            reuseIdentifier: nil,
            olympiad: olympiads[indexPath.row]
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (olympiads.isEmpty, universities.isEmpty) {
        case (true, true): return
        case (false, true):
            presenter?.present(with: olympiads[indexPath.row])
        case (true, false):
            presenter?.present(with: universities[indexPath.row])
        case (false, false):
            if indexPath.section == 0 { presenter?.present(with: universities[indexPath.row]) }
            else { presenter?.present(with: olympiads[indexPath.row]) }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        144.0
    }
}


extension ApolloSearchView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        switch (olympiads.isEmpty, universities.isEmpty) {
        case (true, true):
            return 0
        case (false, true), (true, false):
            return 1
        case (false, false):
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (olympiads.isEmpty, universities.isEmpty) {
        case (true, true):
            return "Empty"
        case (false, true):
            return "Olympiads"
        case (true, false):
            return "Universities"
        case (false, false):
            if section == 0 { return "Universities" }
            else { return "Olympiads" }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (olympiads.isEmpty, universities.isEmpty) {
        case (true, true):
            return 1
        case (false, true):
            return min(olympiads.count, 5)
        case (true, false):
            return min(universities.count, 5)
        case (false, false):
            if section == 0 { return min(viewModel.fetched.universities.count, 5) }
            else { return min(viewModel.fetched.olympiads.count, 5) }
        }
    }
}
