//
//  RoomImageTopCell.swift
//  CleaningManager
//
//  Created by Кирилл Привалов on 25.08.2025.
//

import UIKit

final class RoomImageTopCell: UICollectionViewCell {
    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()

    static let reuseIdentifier = String(describing: RoomItemCell.self)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        layer.cornerRadius = 16
        clipsToBounds = true

        iconImageView.contentMode = .scaleAspectFill

        let stack = UIStackView(arrangedSubviews: [iconImageView, titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center

        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stack.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: 0.9),
            ])
    }

    func configure(roomName: String, subtitle: String, image: UIImage) {
        titleLabel.text = roomName
        subtitleLabel.text = subtitle
        iconImageView.image = image
        iconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("")
    }
}

