//
//  ApolloTabBarController.swift
//  Apollo
//
//  Created by Matoi on 05.06.2024.
//

import UIKit

enum ApolloTabs: Int {
    case main
    case universities
    case settings
}

final class ApolloTabBarController: UITabBarController {

    private var mainPageTabImageView: UIImageView?
    private var universitiesPageTabImageView: UIImageView?
    private var settingsPageTabImageView: UIImageView?
    private var rotationCounter: CGFloat = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        setupTabBarItems()

        setupImages()
    }

    private func setupImages() -> Void {
        guard let mainImageView = tabBar.subviews[0].subviews.first as? UIImageView,
              let universitiesImageView = tabBar.subviews[1].subviews.first as? UIImageView,
              let settingsImageView = tabBar.subviews[2].subviews.first as? UIImageView
        else { return }

        mainPageTabImageView = mainImageView
        mainPageTabImageView?.contentMode = .center

        universitiesPageTabImageView = universitiesImageView
        universitiesPageTabImageView?.contentMode = .center

        settingsPageTabImageView = settingsImageView
        settingsPageTabImageView?.contentMode = .center
    }

    private func configure() -> Void {
        if #available(iOS 15.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        UITabBar.appearance().tintColor = .label

    }

    private func setupTabBarItems() -> Void {
        setViewControllers([
            wrappedIntoNavigationController(ApolloMainViewController(),
                    title: ApolloResources.Strings.TabBar.mainPage,
                    image: ApolloResources.Images.TabBar.mainPage,
                    selectedImage: ApolloResources.Images.TabBar.Selected.mainPage,
                    tag: .main),
            wrappedIntoNavigationController(ApolloUniversitiesViewController(),
                    title: ApolloResources.Strings.TabBar.universitiesPage,
                    image: ApolloResources.Images.TabBar.universitiesPage,
                    selectedImage: ApolloResources.Images.TabBar.Selected.universitiesPage,
                    tag: .universities),
            wrappedIntoNavigationController(ApolloSettingsViewController(),
                    title: ApolloResources.Strings.TabBar.settings,
                    image: ApolloResources.Images.TabBar.settings,
                    selectedImage: ApolloResources.Images.TabBar.Selected.settings,
                    tag: .settings)
        ], animated: false)

    }

    private func wrappedIntoNavigationController(_ viewController: UIViewController, title: String, image: UIImage, selectedImage: UIImage, tag: ApolloTabs) -> ApolloNavigationController {
        let navigationController: ApolloNavigationController = ApolloNavigationController(rootViewController: viewController)
        let tabbarItem = UITabBarItem(
                title: title,
                image: image,
                tag: tag.rawValue
        )
        tabbarItem.selectedImage = selectedImage
        viewController.tabBarItem = tabbarItem
        viewController.navigationItem.title = title

        return navigationController
    }

    private func animate(_ imageView: UIImageView?, tag: ApolloTabs) {
        guard let imageView else { return }

        if case .settings = tag {
            imageView.transform = CGAffineTransformMakeRotation(0)
            UIView.animate(withDuration: 0.2, delay: 0.0, animations: {
                imageView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85).rotated(by: .pi)
            })
            UIView.animate(withDuration: 0.2, delay: 0.15, animations: {
                imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).rotated(by: .pi * 2.0)
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {
                imageView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            }) { _ in
                UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut, animations: {
                    imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }, completion:nil)
            }
        }

    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let tabBarItemTag = ApolloTabs(rawValue: item.tag) else { return }

        switch tabBarItemTag {
        case .main:
            animate(mainPageTabImageView, tag: tabBarItemTag)
        case .universities:
            animate(universitiesPageTabImageView, tag: tabBarItemTag)
        case .settings:
            animate(settingsPageTabImageView, tag: tabBarItemTag)
        }
    }
}
