//
// Created by Matoi on 27.07.2024.
//

import Foundation
import UIKit

final class ApolloButtonCell: UITableViewCell {

    // Properties
    private let buttonTitle: String
    private let action: Selector
    private let style: ApolloButtonStyle

    // Elements
    private let button: UIButton = UIButton(type: .system)

    init(style: CellStyle = .default,
         reuseIdentifier: String? = nil,
         buttonStyle: ApolloButtonStyle,
         buttonTitle: String,
         action: Selector
    ) {
        self.action = action
        self.style = buttonStyle
        self.buttonTitle = buttonTitle
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
        configureButton()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            button.layer.borderColor = UIColor.label.cgColor
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension ApolloButtonCell {
    
    func configure() -> Void {
        backgroundColor = .clear
        selectionStyle = .none
    }

    func configureButton() -> Void {
        switch style {
        case .outlined:
            configureOutlinedButton()
        case .plain:
            configurePlainButton()
        }
    }

    func configurePlainButton() -> Void {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(buttonTitle, for: .normal)
        button.setBackgroundImage(.solidFill(with: .label), for: .normal)
        button.tintColor = .inversedLabelColor
        button.layer.cornerRadius = 12.0
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .medium)
        button.titleLabel?.textColor = .inversedLabelColor
        button.setTitleColor(.label, for: .highlighted)

        button.addTarget(nil, action: action, for: .touchUpInside)

        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.0),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32.0),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6.0),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6.0),
            button.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    func configureOutlinedButton() -> Void {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(buttonTitle, for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.label.cgColor
        button.tintColor = .label
        button.layer.cornerRadius = 12.0
        button.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .medium)
        button.setTitleColor(.label, for: .normal)

        // Add touch events for animation
        button.addTarget(self, action: #selector(touchDown), for: .touchDown)
        button.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        button.addTarget(self, action: #selector(touchUpOutside), for: .touchUpOutside)
        button.addTarget(self, action: #selector(touchDragExit), for: .touchDragExit)

        button.addTarget(nil, action: action, for: .touchUpInside)

        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.0),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32.0),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6.0),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6.0),
            button.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    @objc func touchDown() {
        animateBorderColor(to: UIColor.secondaryLabel.cgColor, duration: 0.01)
    }

    @objc func touchUpInside() {
        animateBorderColor(to: UIColor.label.cgColor, duration: 0.1)
    }

    @objc func touchUpOutside() {
        animateBorderColor(to: UIColor.label.cgColor, duration: 0.1)
    }

    @objc func touchDragExit() {
        animateBorderColor(to: UIColor.label.cgColor, duration: 0.1)
    }

    func animateBorderColor(to color: CGColor, duration: CGFloat) {
        let animation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = button.layer.borderColor
        animation.toValue = color
        animation.duration = duration
        button.layer.add(animation, forKey: "borderColor")
        button.layer.borderColor = color
    }
}
