//
//   RoomTableViewCell.swift
//  CleaningManager
//
//  Created by Boyarkina Anastasiya on 25.08.2025.
//
import UIKit

class RoomTableViewCell: UITableViewCell {

    var onTap: (() -> Void)?

    private let containerView = UIView()

    private let roomNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()

    private let progressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemRed.withAlphaComponent(0.7)
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        return label
    }()

    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go", for: .normal)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .label
        button.semanticContentAttribute = .forceRightToLeft
        button.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    }()

    private let labelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()

    private let iconLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.textAlignment = .center
        label.backgroundColor = .white
        label.layer.cornerRadius = 22
        label.layer.masksToBounds = true
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        containerView.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        containerView.layer.cornerRadius = 16
        containerView.layer.cornerCurve = .continuous
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        containerView.addSubview(labelsStackView)
        containerView.addSubview(actionButton)
        containerView.addSubview(iconLabel)

        labelsStackView.addArrangedSubview(roomNameLabel)
        labelsStackView.addArrangedSubview(progressLabel)
        labelsStackView.addArrangedSubview(statusLabel)

        actionButton.addTarget(self, action: #selector(didTapGoButton), for: .touchUpInside)
    }

    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.heightAnchor.constraint(equalToConstant: 100),

            labelsStackView.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 12),
            labelsStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            labelsStackView.trailingAnchor.constraint(lessThanOrEqualTo: actionButton.leadingAnchor, constant: -8),

            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            actionButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 70),
            actionButton.heightAnchor.constraint(equalToConstant: 70),

            iconLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconLabel.widthAnchor.constraint(equalToConstant: 45),
            iconLabel.heightAnchor.constraint(equalToConstant: 45)
        ])
    }

    func configure(with room: Room) {
        roomNameLabel.text = room.name
        iconLabel.text = room.icon ?? "🏠"
        progressLabel.text = room.progressText

        if room.needsAttention {
            statusLabel.text = room.statusText
            statusLabel.isHidden = false
        } else {
            statusLabel.isHidden = true
        }
    }

    @objc
    private func didTapGoButton() {
        UIView.animate(withDuration: 0.3) { [onTap] in
            onTap?()
            print("Go button tapped!")
        }
    }
}
