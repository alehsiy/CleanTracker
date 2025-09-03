//
//  RoomItemCell.swift
//  CleaningManager
//
//  Created by Кирилл Привалов on 25.08.2025.
//

import UIKit

final class RoomItemCell: UICollectionViewCell {
    private let iconView = UIImageView()
    private let nameLabel = UILabel()
    private let progressView = UIProgressView()
    private let percentLabel = UILabel()
    private let lastDateLabel = UILabel()
    private let infoLabel = UILabel()
    private let daysLabel = UILabel()
    private let actionButton = UIButton()

    static let reuseIdentifier = String(describing: RoomItemCell.self)

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }

}

extension RoomItemCell {
    func configure(
        icon: String,
        title: String,
        percent: String,
        date: String,
        state: String,
        cleanCount: Int,
        cleaningFrequency: String,
        nextDate: String
    ) {
        if let image = icon.asImage() {
            iconView.image = image
        } else {
            iconView.image = UIImage(systemName: "questionmark")
        }
        nameLabel.text = title
        percentLabel.text = "\(percent) clean"
        lastDateLabel.text = "date"

        infoLabel.text = "\(String(describing: cleanCount)) ・ \(String(describing: cleaningFrequency)) ・ \(String(describing: nextDate))"
    }
}

private extension RoomItemCell {
    func addSubviews() {
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(percentLabel)
        contentView.addSubview(daysLabel)
        contentView.addSubview(actionButton)
        contentView.addSubview(infoLabel)
        contentView.addSubview(progressView)
    }

    func setupLayout() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false

        layer.cornerRadius = 16
        clipsToBounds = true
        contentView.backgroundColor = .white

        actionButton.layer.cornerRadius = 15
        actionButton.clipsToBounds = true

        iconView.contentMode = .scaleAspectFit

        // MARK: Fonts

        nameLabel.font = .boldSystemFont(ofSize: 17)
        percentLabel.font = .systemFont(ofSize: 13)
        daysLabel.font = .systemFont(ofSize: 13)
        actionButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        infoLabel.font = .systemFont(ofSize: 13)
        infoLabel.font = .systemFont(ofSize: 13)

        // MARK: Colors

        percentLabel.textColor = .gray
        daysLabel.textColor = .gray
        infoLabel.textColor = .gray

        // MARK: Constraints

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            iconView.widthAnchor.constraint(equalToConstant: 32),
            iconView.heightAnchor.constraint(equalToConstant: 32),

            nameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: iconView.topAnchor),

            percentLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            percentLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),

            daysLabel.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -8),
            daysLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),

            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            actionButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            actionButton.widthAnchor.constraint(equalToConstant: 65),
            actionButton.heightAnchor.constraint(equalToConstant: 32),

            progressView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -8),
            progressView.topAnchor.constraint(equalTo: percentLabel.bottomAnchor, constant: 12),
            progressView.heightAnchor.constraint(equalToConstant: 6),

            infoLabel.leadingAnchor.constraint(equalTo: iconView.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            infoLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 12),
            infoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
