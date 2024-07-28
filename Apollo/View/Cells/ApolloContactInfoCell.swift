//
// Created by Matoi on 27.07.2024.
//

import Foundation
import UIKit


protocol ApolloContactInfoCellDelegate: AnyObject {
    func socialCellDidSelect(_ url: String) -> Void
    func websiteButtonClicked() -> Void
}

final class ApolloContactInfoCell: UITableViewCell {

    // Properties
    private let university: University

    // Elements
    private let leftImageView: UIImageView = UIImageView()
    private let titleLabel: UILabel = UILabel()
    private let admissionCommitteeLabel: UILabel = UILabel()
    private let phoneNumberButton: UIButton = UIButton(type: .system)
    private let websiteButton: UIButton = UIButton(type: .system)
    private let separator: UIView = UIView()
    private let socialLinksStackView: UIStackView = UIStackView()

    private lazy var websiteLabelTitle: String = {
        university.url
                .replacingOccurrences(of: "https://", with: "www.")
                .replacingOccurrences(of: "/", with: "")
    }()

    weak var delegate: ApolloContactInfoCellDelegate?

    init(style: CellStyle = .default, reuseIdentifier: String? = nil, university: University) {
        self.university = university
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
        configureLeftImageView()
        configureTitleLabel()
        configureAdmissionCommitteeLabel()
        configurePhoneNumberButton()
        configureWebsiteButton()
        configureSocialLinksStackView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ApolloContactInfoCell {

    func configure() -> Void {
        backgroundColor = .clear
        selectionStyle = .none
    }

    func configureLeftImageView() -> Void {
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        leftImageView.tintColor = .secondaryLabel
        leftImageView.contentMode = .scaleAspectFit
        leftImageView.image = ApolloResources.Images.ContactCell.phone

        contentView.addSubview(leftImageView)
        NSLayoutConstraint.activate([
            leftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.0),
            leftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.0),
            leftImageView.widthAnchor.constraint(equalToConstant: 24.0),
            leftImageView.heightAnchor.constraint(equalToConstant: 24.0)
        ])
    }

    func configureTitleLabel() -> Void {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        titleLabel.text = "Contact Info"
        titleLabel.adjustsFontSizeToFitWidth = true

        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 12.0),
            titleLabel.centerYAnchor.constraint(equalTo: leftImageView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -56.0)
        ])
    }

    func configureAdmissionCommitteeLabel() -> Void {
        admissionCommitteeLabel.translatesAutoresizingMaskIntoConstraints = false
        admissionCommitteeLabel.numberOfLines = 1
        admissionCommitteeLabel.textColor = .secondaryLabel
        admissionCommitteeLabel.font = .systemFont(ofSize: 11.0, weight: .medium)
        admissionCommitteeLabel.text = "Admission Committee".uppercased()
        admissionCommitteeLabel.adjustsFontSizeToFitWidth = true
        admissionCommitteeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        contentView.addSubview(admissionCommitteeLabel)
        NSLayoutConstraint.activate([
            admissionCommitteeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            admissionCommitteeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.0)
        ])
    }

    func configurePhoneNumberButton() -> Void {
        phoneNumberButton.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberButton.setTitle(university.contactNumber, for: .normal)
        phoneNumberButton.tintColor = .label
        phoneNumberButton.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .medium)
        phoneNumberButton.titleLabel?.adjustsFontSizeToFitWidth = true
        phoneNumberButton.addTarget(self, action: #selector(phoneNumberClicked), for: .touchUpInside)

        contentView.addSubview(phoneNumberButton)
        NSLayoutConstraint.activate([
            phoneNumberButton.leadingAnchor.constraint(equalTo: admissionCommitteeLabel.leadingAnchor),
            phoneNumberButton.topAnchor.constraint(equalTo: admissionCommitteeLabel.bottomAnchor)
        ])
    }

    func configureWebsiteButton() -> Void {
        websiteButton.translatesAutoresizingMaskIntoConstraints = false
        websiteButton.setTitle(websiteLabelTitle, for: .normal)
        websiteButton.tintColor = .label
        websiteButton.addTarget(self, action: #selector(websiteButtonClicked), for: .touchUpInside)
        websiteButton.titleLabel?.adjustsFontSizeToFitWidth = true
        websiteButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)

        contentView.addSubview(websiteButton)
        NSLayoutConstraint.activate([
            websiteButton.leadingAnchor.constraint(equalTo: phoneNumberButton.leadingAnchor),
            websiteButton.topAnchor.constraint(equalTo: phoneNumberButton.bottomAnchor, constant: 16.0),
        ])
    }


    func configureSocialLinksStackView() -> Void {
        socialLinksStackView.translatesAutoresizingMaskIntoConstraints = false
        socialLinksStackView.axis = .horizontal
        socialLinksStackView.alignment = .leading
        socialLinksStackView.spacing = 8.0

        setupSocialLinkCells()

        contentView.addSubview(socialLinksStackView)
        NSLayoutConstraint.activate([
            socialLinksStackView.leadingAnchor.constraint(equalTo: websiteButton.leadingAnchor),
            socialLinksStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -52.0),
            socialLinksStackView.heightAnchor.constraint(equalToConstant: 36.0),
            socialLinksStackView.topAnchor.constraint(equalTo: websiteButton.bottomAnchor, constant: 8.0),
            socialLinksStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.0)
        ])
    }

    func setupSocialLinkCells() {
        let links: [(type: SocialLinkType, url: String?)] = [
            (.telegram, university.contactLinks.telegram),
            (.youtube, university.contactLinks.youtube),
            (.vk, university.contactLinks.vk),
            (.ok, university.contactLinks.ok)
        ]

        links.forEach { link in
            if let url = link.url {
                addSocialLinkCell(type: link.type, url: url)
            }
        }
    }

    private func addSocialLinkCell(type: SocialLinkType, url: String) {
        let socialLinkCell = ApolloSocialLinkCell(type: type, url: url)
        socialLinkCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:))))
        socialLinksStackView.addArrangedSubview(socialLinkCell)
    }

    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? ApolloSocialLinkCell else { return }
        socialCellDidSelect(cell.link)
        print(cell.link)
    }

    func socialCellDidSelect(_ url: String) -> Void {
        delegate?.socialCellDidSelect(url)
    }

    @objc func phoneNumberClicked() -> Void {
        if let phoneNumber = phoneNumberButton.title(for: .normal),
           let phoneURL = URL(string: "tel://\(phoneNumber.filter { $0.isNumber })") {
            if UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            }
        }
    }

    @objc func websiteButtonClicked() -> Void {
        delegate?.websiteButtonClicked()
    }
}
