//
//  ApolloProgramsView.swift
//  Apollo
//
//  Created by Matoi on 02.08.2024.
//

import Foundation
import UIKit
import Combine


final class ApolloOlympiadsView: UIView {
    
    // Properties
    private let program: Faculty
    private let university: University
    private var olympiads: [Olympiad] = []
    private var fetchedOlympiads: [Olympiad] = []

    // Elements
    private let tableView: UITableView = UITableView()
    private lazy var footerView: ApolloTableViewSectionFooterWithTextField = ApolloTableViewSectionFooterWithTextField(frame: CGRectMake(0, 0, tableView.bounds.width, 44), title: String.olympiads(fetchedOlympiads.isEmpty ? olympiads.count : fetchedOlympiads.count), backgroundColor: .apolloBackgroundColor)

    // Bindings
    private let viewModel: ApolloOlympiadsViewModel
    private var subscribers: Set<AnyCancellable> = Set<AnyCancellable>()

    weak var presenter: ApolloOlympiadsViewControllerPresenter?

    init(frame: CGRect = .zero, program: Faculty, university: University, viewModel: ApolloOlympiadsViewModel) {
        self.program = program
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


private extension ApolloOlympiadsView {

    func configure() -> Void  {
        backgroundColor = .black
    }

    func registerCells() -> Void {
        tableView.register(ApolloOlympiadCell.self, forCellReuseIdentifier: "OlympiadCell")
    }

    func configureTableView() -> Void {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        tableView.showsVerticalScrollIndicator = false
        tableView.delaysContentTouches = false
        tableView.backgroundColor = .inversedLabelColor

        tableView.dataSource = self
        tableView.delegate = self
        
        registerCells()

        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func bindViewToViewModel() -> Void {
        
        footerView.textField.textPublisher
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak viewModel, weak self] textInput in
                guard let viewModel, let self else { return }
                fetchedOlympiads = viewModel.filter(olympiads, with: textInput)
                
                if fetchedOlympiads.isEmpty {
                    if let text = footerView.textField.text, !text.isEmpty {
                        footerView.titleLabel.text = String.olympiads(0)
                    }
                    else { footerView.titleLabel.text = String.olympiads(olympiads.count) }
                }
                else { footerView.titleLabel.text = String.olympiads(fetchedOlympiads.count) }
                
                tableView.reloadSections(IndexSet(integer: 1), with: .none)
            }
            .store(in: &subscribers)
            
        
        viewModel.olympiads
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] olympiads in
                    guard let self else { return }
                    self.olympiads = olympiads.sorted(by: { $0.name < $1.name  })
                    
                    footerView.titleLabel.text = String.olympiads(fetchedOlympiads.isEmpty ? olympiads.count : fetchedOlympiads.count)
                    
                    tableView.reloadData()
                })
                .store(in: &subscribers)

        Task {
            await viewModel.getOlympiads(for: program.id)
        }
    }

    @objc func goToProgramWebsite() -> Void {
        presenter?.present(with: program.facultyURL)
    }
}


extension ApolloOlympiadsView: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int { 2 }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 }
    
        if olympiads.isEmpty { return 3 }
        if fetchedOlympiads.isEmpty {
            guard let text = footerView.textField.text, text.isEmpty else { return 0 }
            return olympiads.count
        }
        return fetchedOlympiads.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { return ApolloProgramHeaderCell(program: program, university: university, action: #selector(goToProgramWebsite)) }
        guard !olympiads.isEmpty else { return ApolloStubCell() }
        guard let cell: ApolloOlympiadCell = tableView.dequeueReusableCell(withIdentifier: "OlympiadCell", for: indexPath) as? ApolloOlympiadCell else { return UITableViewCell() }
        
        let olympiad: Olympiad = fetchedOlympiads.isEmpty ? olympiads[indexPath.row] : fetchedOlympiads[indexPath.row]

        cell.configureWithOlympiad(olympiad)

        return cell
    }
}


extension ApolloOlympiadsView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { return UITableView.automaticDimension }
        return 144.0
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
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


extension ApolloOlympiadsView: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        collapseKeyboard()
        return true
    }
}


extension ApolloOlympiadsView: ApolloSearchControllerDelegate {
    func collapseKeyboard() {
        footerView.textField.resignFirstResponder()
    }
}

