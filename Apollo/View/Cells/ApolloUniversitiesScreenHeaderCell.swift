//
// Created by Matoi on 19.07.2024.
//

import UIKit
import Combine

final class ApolloUniversitiesScreenHeaderCell: UITableViewCell {

    // Bindings
    private let viewModel: ApolloUniversitiesScreenHeaderCellViewModel
    private var subscribers: Set<AnyCancellable> = Set<AnyCancellable>()

    // Elements
    private let container: UIView = UIView()
    private let rightImageView: UIImageView = UIImageView()
    private let titleLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    private let stackView: UIStackView = UIStackView()
    private let universitiesCountCell: ApolloUniversitiesScreenHeaderCollectionCell = ApolloUniversitiesScreenHeaderCollectionCell(withTitle: nil, subtitle: "Учебных\nЗаведения")
    private let programsCountCell: ApolloUniversitiesScreenHeaderCollectionCell = ApolloUniversitiesScreenHeaderCollectionCell(withTitle: nil, subtitle: "Программ\nОбучения")
    private let olympiadsCountCell: ApolloUniversitiesScreenHeaderCollectionCell = ApolloUniversitiesScreenHeaderCollectionCell(withTitle: nil, subtitle: "Учитываемых\nОлимпиад")

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, viewModel: ApolloUniversitiesScreenHeaderCellViewModel) {
        self.viewModel = viewModel
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
        configureContainer()
        configureRightImageView()
        configureTitleLabel()
        configureDescriptionLabel()
        configureStackView()

        bindViewToViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ApolloUniversitiesScreenHeaderCell {
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
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configureRightImageView() -> Void {
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        rightImageView.contentMode = .scaleAspectFit
        rightImageView.image = ApolloResources.Images.UniversityScreenHeaderCell.aphine
        rightImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        addSubview(rightImageView)
        NSLayoutConstraint.activate([
            rightImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12.0),
            rightImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 12.0),
            rightImageView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12.0),
            rightImageView.heightAnchor.constraint(equalToConstant: 124.0),
            rightImageView.widthAnchor.constraint(equalToConstant: 77.3)
        ])
    }

    func configureTitleLabel() -> Void {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Поиск по вузам"
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.minimumScaleFactor = 0.01
        titleLabel.adjustsFontSizeToFitWidth = true

        container.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.0),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12.0),
            titleLabel.trailingAnchor.constraint(equalTo: rightImageView.leadingAnchor, constant: -2.0)
        ])
    }

    func configureDescriptionLabel() -> Void {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "Поиск олимпиад, дающих право поступления без вступительных испытаний на выбранную образовательную программу"
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.font = .systemFont(ofSize: 11, weight: .medium)
        descriptionLabel.adjustsFontSizeToFitWidth = false
        descriptionLabel.numberOfLines = 0

        container.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.0),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.0),
            descriptionLabel.trailingAnchor.constraint(equalTo: rightImageView.leadingAnchor, constant: 12.0),
        ])
    }

    func configureStackView() -> Void {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fillEqually

        stackView.addArrangedSubview(universitiesCountCell)
        stackView.addArrangedSubview(programsCountCell)
        stackView.addArrangedSubview(olympiadsCountCell)

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8.0),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8.0),
            stackView.trailingAnchor.constraint(equalTo: rightImageView.leadingAnchor, constant: -4.0)
        ])
    }

    func bindViewToViewModel() -> Void {
        viewModel.data
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] universitiesCount, programsCount, olympiadsCount in
                    guard let self else { return }

                    self.universitiesCountCell.updateTitle(with: "\(universitiesCount)")
                    self.programsCountCell.updateTitle(with: "\(programsCount)")
                    self.olympiadsCountCell.updateTitle(with: "\(olympiadsCount)")

                })
                .store(in: &subscribers)

        Task {
            await viewModel.fetchData()
        }
    }
}
