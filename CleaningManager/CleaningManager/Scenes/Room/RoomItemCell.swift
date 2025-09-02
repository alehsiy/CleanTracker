//
//  RoomItemCell.swift
//  CleaningManager
//
//  Created by Кирилл Привалов on 25.08.2025.
//

import UIKit

final class RoomItemCell: UICollectionViewCell {
    let itemIcon = UILabel()
    let itemName = UILabel()
    let progressView = UIProgressView()
    let cleanilenessLabel = UILabel()
    let cleaningInfoLabel = UILabel()
    let lastCleaningDateLabel = UILabel()
    let cleanButton = UIButton()

    static let reuseIdentifier = String(describing: RoomItemCell.self)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }

}

extension RoomItemCell {
    func configure() {

    }
}
