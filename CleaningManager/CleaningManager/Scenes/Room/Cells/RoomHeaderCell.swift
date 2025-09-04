//
//  RoomHeaderCell.swift
//  CleaningManager
//
//  Created by Кирилл Привалов on 25.08.2025.
//

import UIKit

final class RoomHeaderCell: UICollectionViewCell {
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let progressInfoLabel = UILabel()
    private let labelsView = UIStackView()

    // TODO: Добавить UIImageView по макету

    static let reuseIdentifier = String(describing: RoomHeaderCell.self)

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupLayout()
    }

    func configure(roomName: String, subtitle: String, image: UIImage?, progress: String) {
        titleLabel.text = roomName
        subtitleLabel.text = subtitle
        progressInfoLabel.text = progress
        if let image {
            iconImageView.image = image
        } else {
            iconImageView.image = UIImage(systemName: "home")
        }
        iconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}

// MARK: - Private Methods

private extension RoomHeaderCell {
    func setupLayout() {
        backgroundColor = .white
        layer.cornerRadius = 16
        clipsToBounds = true

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        labelsView.translatesAutoresizingMaskIntoConstraints = false

        iconImageView.contentMode = .scaleAspectFill
        iconImageView.contentMode = .scaleAspectFit

        // TODO: Добавить картинку на фоне и плейсхолдер, если её нет

        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)

        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        subtitleLabel.textColor = .gray

        progressInfoLabel.font = UIFont.systemFont(ofSize: 16)
        progressInfoLabel.textColor = .gray


        labelsView.axis = .vertical
        labelsView.alignment = .leading

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),

            labelsView.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            labelsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            labelsView.heightAnchor.constraint(equalToConstant: 60),
            labelsView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16)
        ])
    }

    func addSubviews() {
        contentView.addSubview(iconImageView)
        labelsView.addArrangedSubview(titleLabel)
        labelsView.addArrangedSubview(subtitleLabel)
        labelsView.addArrangedSubview(progressInfoLabel)
        contentView.addSubview(labelsView)
    }
}
