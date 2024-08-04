//
// Created by Matoi on 23.07.2024.
//

import UIKit


final class ApolloTableViewSectionFooterWithTextField: UIView {

    // Properties
    private let title: String?
    private let textFieldBackgroundColor: UIColor

    // Elements
    var textField: UITextField = UITextField()
    var titleLabel: UILabel = UILabel()

    // Constraints
    private var textFieldLeadingConstraint: NSLayoutConstraint!
    private var textFieldTrailingConstraint: NSLayoutConstraint!
    private var textFieldLeadingActiveConstraint: NSLayoutConstraint!
    private var textFieldTrailingActiveConstraint: NSLayoutConstraint!
    private var textFieldWidthConstraint: NSLayoutConstraint!

    init(frame: CGRect = .zero, title: String?, backgroundColor: UIColor = .apolloCellBackgroundColor) {
        self.title = title
        textFieldBackgroundColor = backgroundColor
        super.init(frame: frame)

        configure()
        configureTitleLabel()
        configureTextField()

        addObservers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension ApolloTableViewSectionFooterWithTextField {

    func configure() -> Void {
        backgroundColor = nil
    }

    func configureTitleLabel() -> Void {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 24.0, weight: .medium)
        titleLabel.textColor = .label

        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0)
        ])

    }

    func configureTextField() -> Void {

        let imageView: UIImageView = UIImageView(image: ApolloResources.Images.TextFieldLeftIconPack.magnify)
        imageView.contentMode = .center
        imageView.tintColor = .label

        let viewPadding = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: Int(textField.frame.size.height)))
        imageView.center = viewPadding.center
        viewPadding.addSubview(imageView)

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        textField.layer.cornerRadius = 10.0
        textField.backgroundColor = textFieldBackgroundColor
        textField.tintColor = .label
        textField.leftView = viewPadding
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.leftViewMode = .always
        textField.placeholder = "Search"

        addSubview(textField)

        textFieldLeadingConstraint = textField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16.0)
        textFieldTrailingConstraint = textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0)
        textFieldLeadingActiveConstraint = textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0)
        textFieldTrailingActiveConstraint = textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0)
        textFieldWidthConstraint = textField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 3)

        NSLayoutConstraint.activate([
            textFieldTrailingConstraint,
            textFieldLeadingConstraint,
            textField.heightAnchor.constraint(equalToConstant: 36.0),
            textFieldWidthConstraint,
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 14.0)
        ])
    }

    func addObservers() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: UITextField.textDidBeginEditingNotification, object: textField)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: UITextField.textDidEndEditingNotification, object: textField)
    }

    @objc func textFieldDidBeginEditing() {
        titleLabel.isHidden = true

        NSLayoutConstraint.deactivate([
            textFieldLeadingConstraint,
            textFieldWidthConstraint
        ])

        NSLayoutConstraint.activate([
            textFieldLeadingActiveConstraint,
            textFieldTrailingActiveConstraint
        ])

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }

    @objc func textFieldDidEndEditing() {
        titleLabel.isHidden = false

        NSLayoutConstraint.deactivate([
            textFieldLeadingActiveConstraint,
            textFieldTrailingActiveConstraint
        ])

        NSLayoutConstraint.activate([
            textFieldLeadingConstraint,
            textFieldWidthConstraint
        ])

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}
