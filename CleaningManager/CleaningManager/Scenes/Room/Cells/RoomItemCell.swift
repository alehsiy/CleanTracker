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
    private let actionButton = UIButton(type: .system)
    private let infoView = UIView()
    private let stackView = UIStackView()

    static let reuseIdentifier = String(describing: RoomItemCell.self)

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}

extension RoomItemCell {
    func configure(
        icon: String,
        title: String,
        date: Date?,
        cleaningFrequency: String,
        nextDate: Date?
    ) {
        if let image = icon.asImage() {
            iconView.image = image
        } else {
            iconView.image = UIImage(systemName: "questionmark")
        }
        nameLabel.text = title
        percentLabel.text = "% clean"
        lastDateLabel.text = "date"
        actionButton.setTitle("Done", for: .normal)
        actionButton.titleLabel?.textColor = .white
        actionButton.tintColor = .white
        infoLabel.text = "3 cleans ・ \(String(describing: cleaningFrequency)) ・ \(String(describing: nextDate))"
    }
}

private extension RoomItemCell {
    func addSubviews() {
        contentView.addSubview(iconView)
        contentView.addSubview(actionButton)
        contentView.addSubview(stackView)
        infoView.addSubview(percentLabel)
        infoView.addSubview(lastDateLabel)
        infoView.addSubview(progressView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(infoView)
        stackView.addArrangedSubview(infoLabel)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 25
        stackView.alignment = .leading
    }

    func setupLayout() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        infoView.translatesAutoresizingMaskIntoConstraints = false
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        lastDateLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        layer.cornerRadius = 16
        clipsToBounds = true
        contentView.backgroundColor = .white

        actionButton.layer.cornerRadius = 15
        actionButton.clipsToBounds = true

        iconView.contentMode = .scaleAspectFit

        // MARK: Fonts

        nameLabel.font = .boldSystemFont(ofSize: 17)
        percentLabel.font = .systemFont(ofSize: 13)
        lastDateLabel.font = .systemFont(ofSize: 13)
        actionButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        infoLabel.font = .systemFont(ofSize: 13)
        infoLabel.font = .systemFont(ofSize: 13)

        // MARK: Colors

        percentLabel.textColor = .gray
        lastDateLabel.textColor = .gray
        infoLabel.textColor = .gray
        actionButton.titleLabel?.textColor = .white
        actionButton.backgroundColor = .systemBlue

        // MARK: Constraints

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 32),
            iconView.heightAnchor.constraint(equalToConstant: 32),

            percentLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            percentLabel.bottomAnchor.constraint(equalTo: progressView.topAnchor),
            lastDateLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor),
            lastDateLabel.bottomAnchor.constraint(equalTo: progressView.topAnchor),
            progressView.widthAnchor.constraint(equalTo: infoView.widthAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 4),
            progressView.bottomAnchor.constraint(equalTo: infoView.bottomAnchor),
            progressView.centerXAnchor.constraint(equalTo: infoView.centerXAnchor),
            infoView.widthAnchor.constraint(equalTo: stackView.widthAnchor),

            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -12),
            stackView.topAnchor.constraint(lessThanOrEqualTo: contentView.topAnchor, constant: 25),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -25),

            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            actionButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 65),
            actionButton.heightAnchor.constraint(equalToConstant: 32),
        ])
    }
}
