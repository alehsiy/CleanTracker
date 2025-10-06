//
//  RoomHeaderCell.swift
//  CleaningManager
//
//  Created by Кирилл Привалов on 25.08.2025.
//

import UIKit

final class RoomHeaderCell: UICollectionViewCell {
    private let iconImageView = UILabel()
    private let titleLabel = UILabel()
    private let progressInfoLabel = UILabel()
    private let labelsView = UIStackView()

    static let reuseIdentifier = String(describing: RoomHeaderCell.self)

    let adaptiveBlueWithAlpha = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor.systemBlue.withAlphaComponent(0.2)
        default:
            return UIColor.systemBlue.withAlphaComponent(0.1)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupLayout()
    }

    func configure(roomName: String, image: String?, progress: String) {
        titleLabel.text = roomName
        progressInfoLabel.text = progress
        iconImageView.text = image ?? "🏠"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}

// MARK: - Private Methods

private extension RoomHeaderCell {
    func setupLayout() {
        backgroundColor = adaptiveBlueWithAlpha
        layer.cornerRadius = 16
        clipsToBounds = true

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        labelsView.translatesAutoresizingMaskIntoConstraints = false

        iconImageView.font = UIFont.systemFont(ofSize: 40)
        iconImageView.textAlignment = .center
        iconImageView.backgroundColor = .white
        iconImageView.layer.cornerRadius = 30
        iconImageView.layer.masksToBounds = true

        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)

        progressInfoLabel.font = UIFont.systemFont(ofSize: 16)
        progressInfoLabel.textColor = .secondaryLabel

        labelsView.axis = .vertical
        labelsView.alignment = .leading

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 60),
            iconImageView.heightAnchor.constraint(equalToConstant: 60),

            labelsView.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            labelsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            labelsView.heightAnchor.constraint(equalToConstant: 60),
            labelsView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16)
        ])
    }

    func addSubviews() {
        contentView.addSubview(iconImageView)
        labelsView.addArrangedSubview(titleLabel)
        labelsView.addArrangedSubview(progressInfoLabel)
        contentView.addSubview(labelsView)
    }
}
