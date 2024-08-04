//
// Created by Matoi on 30.07.2024.
//

import Foundation
import UIKit
import Combine

final class ApolloStubCell: UITableViewCell {

    // Properties
    private var timer: Timer.TimerPublisher?
    private var subscribers: Set<AnyCancellable> = Set<AnyCancellable>()
    private var toggler: Bool = false

    // Elements
    private let container: UIView = UIView()

    override init(style: CellStyle = .default, reuseIdentifier: String? = nil) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
        configureContainer()
        setupTimer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension ApolloStubCell {
    
    func configure() {
        backgroundColor = .clear
        selectionStyle = .none
    }

    func configureContainer() -> Void {
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .apolloCellBackgroundColor
        container.layer.cornerRadius = 24.0

        contentView.addSubview(container)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6.0),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6.0),
            container.heightAnchor.constraint(equalToConstant: 120)
        ])
    }

    func setupTimer() -> Void {
        timer = Timer.publish(every: 3.0, on: .main, in: .common)
        timer?
            .autoconnect()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.handleTimer() }
            .store(in: &subscribers)
    }

    func handleTimer() -> Void {
        UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveEaseOut) {
            self.container.alpha = self.toggler ? 1.0 : 0.3
            self.toggler = !self.toggler
        }
    }
}
