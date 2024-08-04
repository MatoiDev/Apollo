//
//  ApolloSettingsViewController.swift
//  Apollo
//
//  Created by Matoi on 05.06.2024.
//

import UIKit


final class ApolloSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavigationButton()
    }
}


private extension ApolloSettingsViewController {
    
    func setupView() -> Void {
        let view: ApolloSettingsScreen = ApolloSettingsScreen()
        
        self.view = view
    }
    
    func setupNavigationButton() -> Void {
        
        let button: UIButton = UIButton(type: .system)
        button.setTitle("Source code", for: .normal)
        button.addTarget(self, action: #selector(seeSourceCode), for: .touchUpInside)
    
        let rightNavButton: UIBarButtonItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = rightNavButton
    }
    
    @objc func seeSourceCode() -> Void {
        let url: URL = URL(string: "https://github.com/MatoiDev/Apollo")!
        if UIApplication.shared.canOpenURL(url) { UIApplication.shared.open(url)  }
    }
}
