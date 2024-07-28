//
//  ApolloOlympiadInfoView.swift
//  Apollo
//
//  Created by Matoi on 25.06.2024.
//

import UIKit


final class ApolloOlympiadInfoView: UIScrollView {
    
    let olympiad: GroupedOlympiad
    
    // Elements
    private let contentView: UIView = UIView()
    private let nameLabel: UILabel = UILabel()
    private let benefitsStackView: UIStackView = UIStackView()
    private var profileBenefitView: ApolloOlympiadBenefitView!
    private var scoreBenefitView: ApolloOlympiadBenefitView!
    private let profileLabel: UILabel = UILabel()
    private var collectionView: ApolloProfilesCollectionView!
    private let goToOlympiadPageButton: UIButton = UIButton(type: .system)
    
    // Delegates
    weak var presenter: ApolloOlympiadInfoViewControllerPresenter?
    
    init(frame: CGRect = .zero, olympiad: GroupedOlympiad) {
        self.olympiad = olympiad
        super.init(frame: frame)
        
        configure()
        configureContentView()
        configureNameLabel()
        configureBenefitsStackView()
        configureGoToOlympiadPageButton()
        configureCollectionView()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ApolloOlympiadInfoView {
    
    func configure() -> Void {
        scrollsToTop = false
        alwaysBounceVertical = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        backgroundColor = .apolloBackgroundColor
        delaysContentTouches = false
    }
    
    func configureContentView() -> Void {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
    
    func configureNameLabel() -> Void {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 0
        nameLabel.font = .systemFont(ofSize: 24.0, weight: .bold)
        nameLabel.textColor = .label
        nameLabel.text = olympiad.name
        
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
        ])
    }
    
    func configureBenefitsStackView() -> Void {
        benefitsStackView.translatesAutoresizingMaskIntoConstraints = false
        benefitsStackView.axis = .horizontal
        benefitsStackView.backgroundColor = nil
        benefitsStackView.spacing = 16
        benefitsStackView.distribution = .fillEqually

        scoreBenefitView = ApolloOlympiadBenefitView(benefit: .score(olympiad.score))
        benefitsStackView.addArrangedSubview(scoreBenefitView)

        profileBenefitView = ApolloOlympiadBenefitView(benefit: .level(olympiad.level))
        benefitsStackView.addArrangedSubview(profileBenefitView)
        
        contentView.addSubview(benefitsStackView)
        NSLayoutConstraint.activate([
            benefitsStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16.0),
            benefitsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            benefitsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            benefitsStackView.heightAnchor.constraint(equalToConstant: 100.0)
        ])
    }
    
    func configureGoToOlympiadPageButton() -> Void {
        
        goToOlympiadPageButton.translatesAutoresizingMaskIntoConstraints = false
        goToOlympiadPageButton.setTitle("Olympiad website", for: .normal)
        goToOlympiadPageButton.setBackgroundImage(.solidFill(with: .label), for: .normal)
        goToOlympiadPageButton.tintColor = .inversedLabelColor
        goToOlympiadPageButton.layer.cornerRadius = 18.0
        goToOlympiadPageButton.layer.masksToBounds = true
        goToOlympiadPageButton.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .medium)
        
        goToOlympiadPageButton.addTarget(self, action: #selector(presentOlympiadWebsite), for: .touchUpInside)
    
        contentView.addSubview(goToOlympiadPageButton)
        NSLayoutConstraint.activate([
            goToOlympiadPageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            goToOlympiadPageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            goToOlympiadPageButton.topAnchor.constraint(equalTo: benefitsStackView.bottomAnchor, constant: 24.0),
            goToOlympiadPageButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    func configureCollectionView() -> Void {
        let flowLayout: ApolloProfilesCollectionViewFlowLayout = setupFlowLayout()
        
        collectionView = ApolloProfilesCollectionView(collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(ApolloProfileCell.self, forCellWithReuseIdentifier: "\(ApolloProfileCell.self)")
        
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            collectionView.topAnchor.constraint(equalTo: goToOlympiadPageButton.bottomAnchor, constant: 24.0),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32.0),
            collectionView.heightAnchor.constraint(lessThanOrEqualToConstant: CGFloat(olympiad.profiles.count / 2 + olympiad.profiles.count % 2) * 112.0)
        ])

    }
    
    func setupFlowLayout() -> ApolloProfilesCollectionViewFlowLayout {
        let collectionViewLayout: ApolloProfilesCollectionViewFlowLayout = ApolloProfilesCollectionViewFlowLayout()
        
        collectionViewLayout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 22.0, height: 100)
        collectionViewLayout.minimumLineSpacing = 12.0

        return collectionViewLayout
    }
    
    @objc func presentOlympiadWebsite() -> Void {
        presenter?.present(with: olympiad.link)
    }
}

extension ApolloOlympiadInfoView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        olympiad.profiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let name: String = olympiad.profiles.keys.sorted()[indexPath.row]
        let profileData: ProfileData = ProfileData(name: name, idsByUniversities: olympiad.profiles[name]!)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ApolloProfileCell.self)", for: indexPath) as? ApolloProfileCell else { return UICollectionViewCell() }
            
        cell.setDataToCell(profileData)
        
        return cell
    }
}

extension ApolloOlympiadInfoView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        let name: String = olympiad.profiles.keys.sorted()[indexPath.row]
        let profileData: ProfileData = ProfileData(name: name, idsByUniversities: olympiad.profiles[name]!)
        
        presenter?.present(with: olympiad, profile: profileData)
    }
}
