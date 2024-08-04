//
//  ApolloProfileInfoView.swift
//  Apollo
//
//  Created by Matoi on 04.07.2024.
//

import UIKit
import Combine


final class ApolloProfileInfoView: UIView {
    
    // Properties
    private let olympiad: GroupedOlympiad
    private let profile: ProfileData
    
    // Elements
    private let tableView: UITableView = UITableView()
    
    // Bindings
    private let viewModel: ApolloProfileInfoViewModel
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    weak var presenter: ApolloProfileInfoViewControllerPresenter?
    
    init(frame: CGRect = .zero, olympiad: GroupedOlympiad, profile: ProfileData, viewModel: ApolloProfileInfoViewModel) {
        self.olympiad = olympiad
        self.profile = profile
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


private extension ApolloProfileInfoView {
    
    func bindViewToViewModel() -> Void {
        Task {
            await viewModel.getLevelForOlympiad(profile.idsByUniversities.first!.value.first!)
        }
    }
    
    func configure() -> Void {
        backgroundColor = .apolloBackgroundColor
    }
    
    func configureTableView() -> Void {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = nil
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}


extension ApolloProfileInfoView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section > 1 else { return }
        
        let university: String =  Array(profile.idsByUniversities.keys)[indexPath.row]
        let olympiads: [String]  = profile.idsByUniversities[university] ?? []
        
        guard !olympiads.isEmpty else { return }
        
        presenter?.present(with: olympiads)
    }
}


extension ApolloProfileInfoView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3 // 1 на хеддер, 1 на ячейки и ещё 1 на  университеты
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        default:
            return profile.idsByUniversities.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return ApolloTitleCell(
                style: .default,
                reuseIdentifier: nil,
                title: olympiad.name
            )
        case 1:
            return getGeneralLeftCellByRow(indexPath.row)
        default:
            let universityId: String = Array(profile.idsByUniversities.keys)[indexPath.row]
            let cellViewModel: ApolloUniversityCellViewModel = ApolloUniversityCellViewModel(service: ApolloAPIService.shared)
            
            let cell: ApolloUniversityCell = ApolloUniversityCell(
                style: .default,
                reuseIdentifier: nil,
                universityID: universityId,
                specifiedProfilesCount: profile.idsByUniversities[universityId]!.count, 
                viewModel: cellViewModel
            )
            
            return cell
        }
    }
    
    private func getGeneralLeftCellByRow(_ row: Int) -> ApolloGeneralLeftCell {
        switch row {
        case 0:
            return ApolloGeneralLeftCell(
                style: .default,
                reuseIdentifier: nil,
                title: profile.name,
                subtitle: "Профиль олимпиады",
                image: ApolloResources.Images.GeneralLeftCell.profile
            )
        case 1:
            if olympiad.level == "S" {
                return ApolloGeneralLeftCell(
                    style: .default,
                    reuseIdentifier: nil,
                    title: "S ранг",
                    subtitle: "Уровень ВсОШ и межнара",
                    image: ApolloResources.Images.GeneralLeftCell.level
                )
            }
            return ApolloGeneralLeftCell(
                style: .default,
                reuseIdentifier: nil,
                futureTitle: viewModel.olympiadLevel,
                subtitle: "Перечня олимпиад РСОШ",
                image: ApolloResources.Images.GeneralLeftCell.level,
                throwingLevel: olympiad.level
            )
        case 2:
            return ApolloGeneralLeftCell(
                style: .default,
                reuseIdentifier: nil,
                title: String.educationalInstitutions(profile.idsByUniversities.count),
                subtitle: "Принимают олимпиаду",
                image: ApolloResources.Images.GeneralLeftCell.universities
            )
        default:
            return ApolloGeneralLeftCell(
                style: .default,
                reuseIdentifier: nil,
                title: String.educationalPrograms(programsCount),
                subtitle: "Без вступительных испытаний",
                image: ApolloResources.Images.GeneralLeftCell.programs
            )
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return 16.0
        default:
            return .leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    private var programsCount: Int {
        var res: Int = 0
        for ids in profile.idsByUniversities.values {
            res += ids.count
        }
        return res
    }
}
