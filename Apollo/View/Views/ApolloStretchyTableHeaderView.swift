//
// Created by Matoi on 25.07.2024.
//

import Foundation
import UIKit


final class ApolloStretchyTableHeaderView: UIView {
    // Properties
    private var headerImage: UIImage?

    // Elements
    private let containerView: UIView = UIView()
    private let imageView: UIImageView = UIImageView()
    private let notchView: UIView = UIView()
    private let grabberView: UIView = UIView()
    private let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    private let backButton: UIButton = UIButton(type: .system)

    // Constraints
    private var containerViewHeight = NSLayoutConstraint()
    private var imageViewHeight = NSLayoutConstraint()
    private var imageViewBottom = NSLayoutConstraint()
    private var indicatorYCenter = NSLayoutConstraint()
    private var backButtonTop = NSLayoutConstraint()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
        createViews()
        setViewConstraints()
        configureNotchView()
        configureGrabberView()
        configureActivityIndicatorView()
        configureBackButton()
    }

    func setImage(_ image: UIImage) -> Void {
        indicator.stopAnimating()
        imageView.image = image

        layoutIfNeeded()
    }

    func setActionForBackButton(_ selector: Selector) -> Void {
        backButton.addTarget(nil, action: selector, for: .touchUpInside)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        containerViewHeight.constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        imageViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
        indicatorYCenter.constant = -offsetY / 2 - 8.0
        backButtonTop.constant = offsetY > -52.0 ? 52.0 - offsetY : 52.0 - offsetY - (abs(offsetY) - 52.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ApolloStretchyTableHeaderView {

    func configure() -> Void {
        backgroundColor = .apolloCellBackgroundColor
        containerView.backgroundColor = .apolloCellBackgroundColor
    }
    
    func createViews() {
        addSubview(containerView)
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        containerView.addSubview(imageView)
    }
    
    func setViewConstraints() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: containerView.widthAnchor),
            centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        containerViewHeight = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerViewHeight.isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewBottom = imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        imageViewBottom.isActive = true
        imageViewHeight = imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        imageViewHeight.isActive = true
    }
    
    func configureNotchView() -> Void {
        notchView.translatesAutoresizingMaskIntoConstraints = false
        notchView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        notchView.layer.cornerRadius = 16.0
        notchView.layer.masksToBounds = true
        notchView.backgroundColor = UIColor.apolloBackgroundColor
        
        addSubview(notchView)
        NSLayoutConstraint.activate([
            notchView.leadingAnchor.constraint(equalTo: leadingAnchor),
            notchView.trailingAnchor.constraint(equalTo: trailingAnchor),
            notchView.bottomAnchor.constraint(equalTo: bottomAnchor),
            notchView.heightAnchor.constraint(equalToConstant: 32.0)
        ])
    }

    func configureGrabberView() {
        grabberView.translatesAutoresizingMaskIntoConstraints = false
        grabberView.layer.cornerRadius = 2.5
        grabberView.backgroundColor = UIColor.label
        
        notchView.addSubview(grabberView)
        NSLayoutConstraint.activate([
            grabberView.centerXAnchor.constraint(equalTo: notchView.centerXAnchor),
            grabberView.topAnchor.constraint(equalTo: notchView.topAnchor, constant: 8.0),
            grabberView.heightAnchor.constraint(equalToConstant: 5.0),
            grabberView.widthAnchor.constraint(equalToConstant: 36.0),
        ])
        
    }
    
    func configureBackButton() -> Void {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.contentMode = .scaleAspectFit
        backButton.setImage(ApolloResources.Images.Button.backButtonImage, for: .normal)
        backButton.tintColor = .label
        
        backButtonTop = backButton.topAnchor.constraint(equalTo: topAnchor)
        
        addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            backButtonTop,
            backButton.heightAnchor.constraint(equalToConstant: 48.0),
            backButton.widthAnchor.constraint(equalToConstant: 48.0)
        ])
    }

    func configureActivityIndicatorView() -> Void {
        indicator.translatesAutoresizingMaskIntoConstraints = false

        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        
        indicatorYCenter = indicator.centerYAnchor.constraint(equalTo: centerYAnchor)

        addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicatorYCenter
        ])
    }
}
