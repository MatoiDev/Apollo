//
// Created by Matoi on 21.07.2024.
//

import UIKit


final class ApolloUniversitiesScreenHeaderCollectionCell: UIView {

    // Properties
    private var title: String?
    private let subtitle: String
    private var timer: Timer?
    private var timerState: Bool = true

    // Elements
    private let titleLabel: UILabel = UILabel()
    private let subtitleLabel: UILabel = UILabel()

    init(frame: CGRect = .zero, withTitle title: String?, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
        super.init(frame: frame)

        configure()
        configureTitleLabel()
        configureSubtitleLabel()
        startLabelBackgroundAnimation()
    }

    func updateTitle(with value: String) {
        title = value

        reconfigureTitleLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension ApolloUniversitiesScreenHeaderCollectionCell {
    
    func configure() -> Void {
        backgroundColor = nil
    }

    func configureTitleLabel() -> Void {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title ?? " "
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 18.0, weight: .medium)
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.backgroundColor = .secondarySystemFill
        titleLabel.layer.cornerRadius = 4.0
        titleLabel.layer.masksToBounds = true

        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.0),
        ])
    }

    func reconfigureTitleLabel() -> Void {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, animations: {
                self.titleLabel.text = self.title
                self.titleLabel.alpha = 1.0
            }) { _ in
                self.timer?.invalidate()
                self.titleLabel.backgroundColor = .clear
            }
        }
    }

    func startLabelBackgroundAnimation() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(changeBackgroundColor), userInfo: nil, repeats: true)
    }

    @objc func changeBackgroundColor() {
        UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveEaseOut) {
            self.titleLabel.alpha = self.timerState ? 0.3 : 1.0
            self.timerState = !self.timerState
        }
    }

    func configureSubtitleLabel() -> Void {
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = subtitle
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = .systemFont(ofSize: 8.0, weight: .medium)
        subtitleLabel.numberOfLines = 2
        subtitleLabel.adjustsFontSizeToFitWidth = false

        addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.0),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.0),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.0),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2.0)
        ])
    }
}
