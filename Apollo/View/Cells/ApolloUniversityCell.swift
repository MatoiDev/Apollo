//
//  ApolloUniversityCell.swift
//  Apollo
//
//  Created by Matoi on 06.07.2024.
//

import UIKit
import Combine

final class ApolloUniversityCell: UITableViewCell {
    
    // Properties
    private var universityID: String?
    private var university: University?
    private let profilesCount: Int
    
    // Bindings
    private let viewModel: ApolloUniversityCellViewModel
    private var subscribers: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // Elements
    private let container: UIView = UIView()
    private let leftImageView: UIImageView = UIImageView()
    private let titleLabel: UILabel = UILabel()
    private let yearLabel: UILabel = UILabel()
    private let cityLabel: UILabel = UILabel()
    private let fakeExtendButton: UIView = UIView()
    private let programsLabel: UILabel = UILabel()
    private let chevronImage: UIImageView = UIImageView()
    private let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, universityID: String, specifiedProfilesCount: Int, viewModel: ApolloUniversityCellViewModel) {
        
        profilesCount = specifiedProfilesCount
        self.universityID = universityID
        self.viewModel = viewModel
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        configureContainer()
        configureLeftImage()
        configureTitleLabel()
        configureYearLabel()
        configureCityLabel()
        configureProgramsLabel()
        configureChevronImageView()
        configureFakeExtendButton()
        configureIndicator()
        
        bindViewToViewModel(with: .idStrategy)
    }
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, university: University, viewModel: ApolloUniversityCellViewModel) {
        
        profilesCount = 0
        self.university = university
        self.viewModel = viewModel
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        configureContainer()
        configureLeftImage()
        configureTitleLabel()
        configureYearLabel()
        configureCityLabel()
        configureProgramsLabel()
        configureChevronImageView()
        configureFakeExtendButton()
        configureIndicator()
        
        updateCellWithFetchedUniversity(university)
        bindViewToViewModel(with: .universityStrategy)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension ApolloUniversityCell {

    func configure() -> Void {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    func configureContainer() -> Void {
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .apolloCellBackgroundColor
        container.layer.cornerRadius = 24.0
        
        contentView.addSubview(container)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6.0),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6.0)
        ])
    }
    
    func configureLeftImage() -> Void {
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        leftImageView.contentMode = .scaleAspectFill
        leftImageView.layer.cornerRadius = 24.0
        leftImageView.clipsToBounds = true
        
        container.addSubview(leftImageView)
        NSLayoutConstraint.activate([
            leftImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            leftImageView.topAnchor.constraint(equalTo: container.topAnchor),
            leftImageView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            leftImageView.widthAnchor.constraint(equalToConstant: 128.0),
            leftImageView.heightAnchor.constraint(equalToConstant: 128.0)
        ])
    }
    
    func configureTitleLabel() -> Void {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 18.0, weight: .medium)
        
        container.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 16.0),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.0)
        ])
    }
    
    func configureYearLabel() -> Void {
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.textColor = .secondaryLabel
        yearLabel.font = .systemFont(ofSize: 10.0, weight: .medium)
        yearLabel.textAlignment = .left
        
        container.addSubview(yearLabel)
        NSLayoutConstraint.activate([
            yearLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 16.0),
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            yearLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.0)
        ])
    }
    
    func configureCityLabel() -> Void {
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.textColor = .secondaryLabel
        cityLabel.font = .systemFont(ofSize: 10.0, weight: .medium)
        cityLabel.textAlignment = .left
        
        container.addSubview(cityLabel)
        NSLayoutConstraint.activate([
            cityLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 16.0),
            cityLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 6.0),
            cityLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.0)
        ])
    }
    
    func configureFakeExtendButton() -> Void {
        fakeExtendButton.translatesAutoresizingMaskIntoConstraints = false
        fakeExtendButton.backgroundColor = .label
        fakeExtendButton.layer.cornerRadius = 12.0
        
        container.addSubview(fakeExtendButton)
        NSLayoutConstraint.activate([
            fakeExtendButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.0),
            fakeExtendButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16.0)
        ])
    }
    
    func configureProgramsLabel() -> Void {
        programsLabel.translatesAutoresizingMaskIntoConstraints = false
        programsLabel.textColor = .inversedLabelColor
        programsLabel.text = String.programs(profilesCount)
        programsLabel.font = .systemFont(ofSize: 12.0, weight: .medium)
        programsLabel.textAlignment = .center
        
        
        fakeExtendButton.addSubview(programsLabel)
        NSLayoutConstraint.activate([
            programsLabel.leadingAnchor.constraint(equalTo: fakeExtendButton.leadingAnchor, constant: 8.0),
            programsLabel.bottomAnchor.constraint(equalTo: fakeExtendButton.bottomAnchor, constant: -4.0),
            programsLabel.topAnchor.constraint(equalTo: fakeExtendButton.topAnchor, constant: 4.0)
        ])
    }
    
    func configureChevronImageView() -> Void {
        chevronImage.translatesAutoresizingMaskIntoConstraints = false
        chevronImage.contentMode = .scaleAspectFit
        chevronImage.tintColor = .inversedLabelColor
        chevronImage.image = ApolloResources.Images.UniversityCell.chevronDown
        
        fakeExtendButton.addSubview(chevronImage)
        NSLayoutConstraint.activate([
            chevronImage.topAnchor.constraint(equalTo: fakeExtendButton.topAnchor, constant: 3.0),
            chevronImage.bottomAnchor.constraint(equalTo: fakeExtendButton.bottomAnchor, constant: -3.0),
            chevronImage.trailingAnchor.constraint(equalTo: fakeExtendButton.trailingAnchor, constant: -5.0),
            chevronImage.leadingAnchor.constraint(equalTo: programsLabel.trailingAnchor, constant: 2.0),
            chevronImage.widthAnchor.constraint(equalToConstant: 18.0),
            chevronImage.heightAnchor.constraint(equalToConstant: 18.0)
        ])
    }
    
    func configureIndicator() -> Void {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        
        leftImageView.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: leftImageView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: leftImageView.centerYAnchor)
        ])
    }
    
    func updateCellWithFetchedUniversity(_ university: University) {
        titleLabel.text = university.name
        yearLabel.text = "\(university.yearOfFoundation)"
        cityLabel.text = university.address.city
    }
    
}


private extension ApolloUniversityCell {
    
    enum LocalStrategy {
        case idStrategy
        case universityStrategy
    }
    
    func bindViewToViewModel(with strategy: LocalStrategy) -> Void {
        switch strategy {
        case .idStrategy:
            bindViewWithIDStrategy()
        case .universityStrategy:
            bindViewWithUniversityStrategy()
        }
    }
    
    func bindViewWithIDStrategy() -> Void {
        
        guard let universityID else { return }
        
        viewModel.university
            .receive(on: DispatchQueue.main)
            .sink { _ in return
            } receiveValue: { [weak self] university in
                guard let self else { return }
                updateCellWithFetchedUniversity(university)
            }
            .store(in: &subscribers)
        
        viewModel.universityImage
            .receive(on: DispatchQueue.main)
            .sink { _ in return
        
            } receiveValue: { [weak self] image in
                guard let self else { return }
                leftImageView.image = image
                indicator.stopAnimating()
            }
            .store(in: &subscribers)

        Task {
            await viewModel.getUniversityById(universityID)
        }
    }
    
    func bindViewWithUniversityStrategy() -> Void {
        
        guard let university else { return }
        
        viewModel.universityImage
            .receive(on: DispatchQueue.main)
            .sink { _ in return

            } receiveValue: { [weak self] image in
                guard let self else { return }
                leftImageView.image = image
                indicator.stopAnimating()
            }
            .store(in: &subscribers)

        viewModel.programs
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: {_ in }, receiveValue: { [weak self] faculties in
                    guard let self else { return }
                    programsLabel.text = String.programs(faculties.count)
                })
                .store(in: &subscribers)
        
        Task {
                    await viewModel.fetchImageWithURL(university.imageURL)
                    await viewModel.fetchProgramsCountFor(university: university)
                }
    }
}
