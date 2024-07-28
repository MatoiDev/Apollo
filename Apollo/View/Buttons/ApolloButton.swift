//
//  ApolloButton.swift
//  Apollo
//
//  Created by Matoi on 26.06.2024.
//

import UIKit


enum ApolloButtonStyle {
    case plain
    case outlined
}

final class ApolloButton: UIButton {
    
    private let highlightDuration: TimeInterval
    private let highlightedBackgroundColor: UIColor
    private let normalBackgroundColor: UIColor
    
    init(frame: CGRect = .zero,
         style: ApolloButtonStyle = .plain,
         highlightDuration: TimeInterval = 0.0,
         normalBackgroundColor: UIColor = .label,
         highlightedBackgroundColor: UIColor = .apolloButtonHighlightedColor
    ) {
        self.highlightDuration = highlightDuration
        self.highlightedBackgroundColor = highlightedBackgroundColor
        self.normalBackgroundColor = normalBackgroundColor
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            if oldValue == false && isHighlighted {
                highlight()
            } else if oldValue == true && !isHighlighted {
                unHighlight()
            }
        }
    }
}

private extension ApolloButton {
    func configure() -> Void {
        heightAnchor.constraint(equalToConstant: 56).isActive = true
        adjustsImageWhenHighlighted = false
        layer.cornerRadius = 18
        layer.masksToBounds = true
        titleLabel?.font = .systemFont(ofSize: 17.0, weight: .medium)
        backgroundColor = normalBackgroundColor
    }
    
    func highlight() {
        animateBackground(to: highlightedBackgroundColor, duration: highlightDuration)
    }

    func unHighlight() {
        animateBackground(to: normalBackgroundColor, duration: highlightDuration)
    }
    
    func animateBackground(to color: UIColor?, duration: TimeInterval) {
        guard let color = color else { return }
        UIView.animate(withDuration: highlightDuration) {
            self.backgroundColor = color
        }
    }
}
