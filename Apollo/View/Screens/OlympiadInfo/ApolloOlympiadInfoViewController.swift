//
//  ApolloOlympiadInfoViewController.swift
//  Apollo
//
//  Created by Matoi on 25.06.2024.
//

import UIKit
import SafariServices

protocol ApolloOlympiadInfoViewControllerPresenter: AnyObject {
    func present(with olympiad: ShortOlympiadInfo) -> Void
    func present(with olympiadURLString: String) -> Void
    func present(with olympiad: GroupedOlympiad, profile: ProfileData) -> Void
}

final class ApolloOlympiadInfoViewController: UIViewController {

    private let olympiad: GroupedOlympiad
    
    init(with olympiad: GroupedOlympiad) {
        self.olympiad = olympiad
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ApolloOlympiadInfoViewController {
    
    func setupView() -> Void {
        let view: ApolloOlympiadInfoView = ApolloOlympiadInfoView(olympiad: olympiad)
        view.presenter = self
        self.view = view
    }
}

extension ApolloOlympiadInfoViewController: ApolloOlympiadInfoViewControllerPresenter {
    func present(with olympiad: ShortOlympiadInfo) {
        print(olympiad.name)
    }
    
    func present(with olympiad: GroupedOlympiad, profile: ProfileData) {
        let vc = ApolloProfileInfoViewController(olympiad: olympiad, profile: profile)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func present(with olympiadURLString: String) {
        guard let url: URL = URL(string: olympiadURLString) else { return }
        
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.dismissButtonStyle = .close
        safariViewController.preferredControlTintColor = .label
    
        present(safariViewController, animated: true)
    }
}
