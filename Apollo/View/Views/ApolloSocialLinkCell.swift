//
// Created by Matoi on 27.07.2024.
//

import Foundation
import UIKit


enum SocialLinkType {
    case vk
    case youtube
    case ok
    case telegram
}


final class ApolloSocialLinkCell: UIView {

    // Properties
    let link: String
    private let type: SocialLinkType
    private lazy var image: UIImage = {
        switch type {
        case .ok:
            return ApolloResources.Images.Social.ok
        case .vk:
            return ApolloResources.Images.Social.vk
        case .youtube:
            return ApolloResources.Images.Social.youtube
        case .telegram:
            return ApolloResources.Images.Social.telegram
        }
    }()

    // Elements
    private let imageView: UIImageView = UIImageView()

    init(frame: CGRect = .zero, type: SocialLinkType, url: String) {
        link = url
        self.type = type

        super.init(frame: frame)

        configure()
        configureImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension ApolloSocialLinkCell {
    
    func configure() -> Void {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .apolloButtonBackgroundColor
        layer.cornerRadius = 8.0

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 48),
            heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func configureImageView() -> Void {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit

        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 20),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
