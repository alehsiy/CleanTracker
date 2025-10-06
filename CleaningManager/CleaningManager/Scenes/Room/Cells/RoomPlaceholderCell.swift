//
//  RoomPlaceholderCell.swift
//  CleaningManager
//
//  Created by Кирилл Привалов on 30.09.2025.
//

import UIKit

final class RoomPlaceholderCell: UICollectionViewCell {
    private let titleLabel = UILabel()

    static let reuseIdentifier = String(describing: RoomPlaceholderCell.self)

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
        contentView.addSubview(titleLabel)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        backgroundColor = adaptiveBlueWithAlpha
        layer.cornerRadius = 16
        clipsToBounds = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "There are no items yet"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .gray

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 32),
        ])
    }
}
