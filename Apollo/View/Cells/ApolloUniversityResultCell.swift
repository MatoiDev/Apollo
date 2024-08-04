//
//  ApolloUniversityResultCell:.swift
//  Apollo
//
//  Created by Matoi on 18.06.2024.
//

import UIKit
import Combine


final class ApolloUniversityResultCell: UITableViewCell {
    
    // Properties
    private var university: University?
    
    // Elements
    private let container: UIView = UIView()
    private let logoImageView: UIImageView = UIImageView()
    private let nameLabel: UILabel = UILabel()
    private let cityLabel: UILabel = UILabel()
    private let specialitiesLabel: UILabel = UILabel()
    
    // Bindings
    private var viewModel: ApolloUniversityResultViewModel?
    private var subscribers: Set<AnyCancellable> = Set<AnyCancellable>()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        configureContainer()
        configureLogoImageView()
        configureNameLabel()
        configureCityLabel()
        configureSpecialitiesLabel()
    }
    
    func configureCellWithUniversity(_ university: University, viewModel: ApolloUniversityResultViewModel) -> Void {
        self.university = university
        self.viewModel = viewModel
        
        bindViewToViewModel()
        updateCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension ApolloUniversityResultCell {
    
    func bindViewToViewModel() -> Void {
        Task {
            await viewModel?.getFacultiesFor(university: university!.id)
        }
        
        viewModel?.faculties
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion { // TODO: Допилить
                    fatalError(error.localizedDescription)
                }
            } receiveValue: { [weak self] faculties in
                guard let self else { return }
                specialitiesLabel.text = String.programs(faculties.count)
            }
            .store(in: &subscribers)
    }
    
    func configure() -> Void {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    func configureContainer() -> Void {
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .apolloBackgroundColor
        container.layer.cornerRadius = 24.0
        
        contentView.addSubview(container)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6.0),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6.0)
        ])
    }
    
    func configureLogoImageView() -> Void {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFit
        
        addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.0),
            logoImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.0),
            logoImageView.widthAnchor.constraint(equalToConstant: 60.0),
            logoImageView.heightAnchor.constraint(equalToConstant: 60.0)
        ])
    }
    
    func configureNameLabel() -> Void {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 16.0, weight: .medium)
        nameLabel.minimumScaleFactor = 0.8
        nameLabel.textColor = .label
        nameLabel.numberOfLines = 2
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.lineBreakMode = .byTruncatingTail
        
        container.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.0),
            nameLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 8.0),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.0)
        ])
    }
    
    func configureCityLabel() -> Void {
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.font = .systemFont(ofSize: 12.0, weight: .regular)
        cityLabel.minimumScaleFactor = 0.01
        cityLabel.textColor = .secondaryLabel
        cityLabel.numberOfLines = 1
        cityLabel.adjustsFontSizeToFitWidth = true
        
        container.addSubview(cityLabel)
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8.0),
            cityLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 8.0),
            cityLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.0)
        ])
    }
    
    func configureSpecialitiesLabel() -> Void {
        specialitiesLabel.translatesAutoresizingMaskIntoConstraints = false
        specialitiesLabel.font = .systemFont(ofSize: 12.0, weight: .medium)
        specialitiesLabel.minimumScaleFactor = 0.01
        specialitiesLabel.textColor = .secondaryLabel
        specialitiesLabel.adjustsFontSizeToFitWidth = true
        specialitiesLabel.text = "Подсчёт программ..."
        
        container.addSubview(specialitiesLabel)
        NSLayoutConstraint.activate([
            specialitiesLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.0),
            specialitiesLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.0),
            specialitiesLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16.0)
        ])
    }
    
    func updateCell() -> Void {
        cityLabel.text = university!.address.city
        nameLabel.text = university!.name
        logoImageView.image = UIImage(named: "\(university!.id)Logo")
    }
}
