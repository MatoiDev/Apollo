//
//  ApolloSearchEditingOverlayGestureView.swift
//  Apollo
//
//  Created by Matoi on 17.06.2024.
//

import UIKit

final class ApolloSearchEditingOverlayGestureView: UIToolbar {
    
    private let collapseButton: UIBarButtonItem = UIBarButtonItem()
    private let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    
    weak var mainDelegate: ApolloSearchControllerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCollapseButton()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        barStyle = .default
        items = [flexibleSpace, collapseButton]
        sizeToFit()
    }
}

private extension ApolloSearchEditingOverlayGestureView {
    
    func configureCollapseButton() -> Void {
        collapseButton.image = ApolloResources.Images.Keyboard.collapse
        collapseButton.style = .done
        collapseButton.target = self
        collapseButton.action = #selector(collapseKeyboard)
        collapseButton.tintColor = .label
    }
    
    @objc func collapseKeyboard() -> Void {
        mainDelegate?.collapseKeyboard()
    }
}
