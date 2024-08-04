//
//  ApolloUniversityInfoView.swift
//  Apollo
//
//  Created by Matoi on 25.06.2024.
//

import UIKit
import Combine

final class ApolloUniversityInfoView: UIView {

    // Properties
    private let university: University
    private let viewModel: ApolloUniversityInfoViewModel

    // Elements
    private let tableView: UITableView = UITableView()
    
    // Bindings
    private var subscribers: Set<AnyCancellable> = Set<AnyCancellable>()

    weak var presenter: ApolloUniversityInfoViewControllerPresenter?

    init(frame: CGRect = .zero, university: University, viewModel: ApolloUniversityInfoViewModel) {
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

private extension ApolloUniversityInfoView {

    func configure() -> Void {
        backgroundColor = .apolloBackgroundColor
    }

    func configureTableView() -> Void {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .apolloBackgroundColor
        tableView.delaysContentTouches = false

        configureTableViewStretchyHeader()

        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configureTableViewStretchyHeader() -> Void {
        let headerView: ApolloStretchyTableHeaderView = ApolloStretchyTableHeaderView(frame: CGRectMake(0, 0, bounds.width, 200))
        
        headerView.setActionForBackButton(#selector(goBack))
        
        tableView.tableHeaderView = headerView
    }
    
    func bindViewToViewModel() -> Void {
        viewModel.universityImage
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] image in
                guard let self, let headerView = tableView.tableHeaderView as? ApolloStretchyTableHeaderView else { return }
                headerView.setImage(image)
            }
            .store(in: &subscribers)
        
        Task {
            await viewModel.getImage(for: university)
        }
    }
    
    @objc func goBack() -> Void {
        presenter?.popCurrentViewController()
    }

    @objc func goToUniversityOlympiad() -> Void {
        presenter?.present(with: university.mainOlympiad)
    }

    @objc func goToProgramsSection() -> Void {
        presenter?.present(with: university)
    }

}


extension ApolloUniversityInfoView: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerView = tableView.tableHeaderView as! ApolloStretchyTableHeaderView
        headerView.scrollViewDidScroll(scrollView: scrollView)
    }
}


extension ApolloUniversityInfoView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.row) {
        case 0:
            return ApolloUniversityTitleWithYearOfFoundationCell(university: university)
        case 1:
            return ApolloTitleCell(
                    title: university.description,
                    fontSize: 14.0,
                    fontWeight: .medium,
                    verticalPadding: 16.0,
                    horizontalPadding: 32.0
            )
        case 2:
            return ApolloButtonCell(
                    buttonStyle: .plain,
                    buttonTitle: "University Olympiad",
                    action: #selector(goToUniversityOlympiad)
            )
        case 3:
            return ApolloButtonCell(
                    buttonStyle: .outlined,
                    buttonTitle: "Educational Programs",
                    action: #selector(goToProgramsSection)
            )
        case 4:
            let cell: ApolloContactInfoCell = ApolloContactInfoCell(university: university)
            cell.delegate = self
            return cell
        case 5:
            return ApolloUniversityAddressCell(university: university)
        default:
            return UITableViewCell()
        }
    }
}


extension ApolloUniversityInfoView: ApolloContactInfoCellDelegate {
    func socialCellDidSelect(_ url: String) {
        presenter?.present(with: url)
    }

    func websiteButtonClicked() {
        presenter?.present(with: university.url)
    }
}

