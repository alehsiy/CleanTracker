//
//  CollectionRoomItemCell.swift
//  CleaningManager
//
//  Created by Zvorygin Aleksey on 18.09.2025.
//

import UIKit

final class CollectionRoomItemCell: UITableViewCell {

    private let itemNamelabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        itemNamelabel.text = title
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 8
        contentView.addSubview(itemNamelabel)
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = 2
        contentView.backgroundColor = .systemGray6
        
        itemNamelabel.font = .systemFont(ofSize: 14)
        itemNamelabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            itemNamelabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            itemNamelabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            itemNamelabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            itemNamelabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
