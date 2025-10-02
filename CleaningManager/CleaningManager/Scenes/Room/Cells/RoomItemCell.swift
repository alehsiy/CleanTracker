//
//  RoomItemCell.swift
//  CleaningManager
//
//  Created by Кирилл Привалов on 25.08.2025.
//

import UIKit

//final class RoomItemCell: UITableViewCell {
//    private let iconView = UIImageView()
//    private let nameLabel = UILabel()
//    private let nextDateLabel = UILabel()
//    private let lastDateLabel = UILabel()
//    private let frequencyLabel = UILabel()
//    private let actionButton = UIButton()
//
//    static let reuseIdentifier = String(describing: RoomItemCell.self)
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        //        addSubviews()
//        //        setupLayout()
//    }
//
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("Not implemented")
//    }
//}
//
final class RoomItemCell: UICollectionViewCell {
    var itemId: String?
    var onCleanItem: (() -> Void)?
    private let iconView = UIImageView()
    private let nameLabel = UILabel()
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
    func configure(info: Zone) {
        iconView.image = info.icon.asImage() ?? UIImage(systemName: "questionmark")
        nameLabel.text = info.name
//        lastDateLabel.text = info.lastCleanedAt?.ISO8601Format()
//        actionButton.setTitle("Done", for: .normal)
//        actionButton.titleLabel?.textColor = .white
//        actionButton.tintColor = .white
//        infoLabel.text = "\(String(describing: cleaningFrequency)) ・ \(String(describing: nextDate))"
    }
}

extension RoomItemCell {
    func configure(
        icon: String,
        title: String,
        lastDate: Date?,
        cleaningFrequency: String,
        nextDate: Date?,
        isDue: Bool
    ) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if !icon.isEmpty, let image = icon.asImage() {
            iconView.image = image
        } else {
            iconView.image = UIImage(systemName: "questionmark")
        }
        nameLabel.text = title
        if let lastDate {
            lastDateLabel.text = "Last date cleaned: \(dateFormatter.string(from: lastDate))"
        } else {
            lastDateLabel.text = "Item has not been cleaned yet"
        }
        actionButton.titleLabel?.textColor = .white
        actionButton.tintColor = .white
        if isDue {
            actionButton.backgroundColor = .systemRed
            actionButton.setTitle("Clean", for: .normal)
            actionButton.addTarget(self, action: #selector(cleanButtonPressed(_:)), for: .touchUpInside)
        } else {
            actionButton.setTitle("Done", for: .normal)
            actionButton.backgroundColor = .systemBlue
        }
        if let nextDate {
            infoLabel.text = "\(String(describing: cleaningFrequency).capitalized) ・ Next date: \(dateFormatter.string(from: nextDate))"
        } else {
            infoLabel.text = "\(String(describing: cleaningFrequency).capitalized) ・ No next date yet"
        }
    }
}

private extension RoomItemCell {
    func addSubviews() {
        contentView.addSubview(iconView)
        contentView.addSubview(actionButton)
        contentView.addSubview(stackView)
        infoView.addSubview(lastDateLabel)
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
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        lastDateLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        layer.cornerRadius = 16
        clipsToBounds = true
        contentView.backgroundColor = .white

        actionButton.layer.cornerRadius = 15
        actionButton.clipsToBounds = true

        iconView.contentMode = .scaleAspectFit

        // MARK: Fonts

        nameLabel.font = .boldSystemFont(ofSize: 17)
        lastDateLabel.font = .systemFont(ofSize: 13)
        actionButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        infoLabel.font = .systemFont(ofSize: 13)
        infoLabel.font = .systemFont(ofSize: 13)

        // MARK: Colors

        lastDateLabel.textColor = .gray
        infoLabel.textColor = .gray
        actionButton.titleLabel?.textColor = .white

        // MARK: Constraints

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 32),
            iconView.heightAnchor.constraint(equalToConstant: 32),

            lastDateLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
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

    @objc
    private func cleanButtonPressed(_ sender: UIButton) {
        guard let id = itemId else { return }
        Task {
            try await ZoneService.shared.cleanZone(id: id)
            onCleanItem?()
        }
    }
}
