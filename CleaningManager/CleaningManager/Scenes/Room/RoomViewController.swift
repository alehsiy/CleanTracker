//
//  RoomViewController.swift
//  CleaningManager
//
//  Created by Zvorygin Aleksey on 19.08.2025.
//

import UIKit

final class RoomViewController: UIViewController, UICollectionViewDataSource {
    enum Section: Int, CaseIterable {
        case header
        case zone
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == Section.header.rawValue {
            return 1
        } else {
            return model.items.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == Section.header.rawValue {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoomImageTopCell.reuseIdentifier, for: indexPath) as! RoomImageTopCell
            cell.configure(roomName: "RoomName", subtitle: "String", image: UIImage(systemName: "drop")!)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoomItemCell.reuseIdentifier, for: indexPath) as! RoomItemCell
//            cell.configure()
            return cell
        }
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil

    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(RoomImageTopCell.self, forCellWithReuseIdentifier: RoomImageTopCell.reuseIdentifier)
    }

    func makeLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, env in
            if sectionIndex == 0 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = itemSize
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                return section
            } else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(105))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = itemSize
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
                return section
            }
        }
    }
}

fileprivate struct RoomItem {
    let cleanlinessStatus: String
    let icon: RoomIcon
    let lastCleaningDate: Date
    let cleaningFrequency: CleaningFrequency
    let state: CleaningState
}

fileprivate struct RoomModel {
    let name: String
    let image: UIImage?
    let items: [RoomItem]
    let totalCleanlinessStatus: Int
}

enum CleaningFrequency {
    case daily
    case weekly
    case monthly
}

enum RoomIcon: String {
    case dishes = "🍽️"
}

enum CleaningState {
  case cleanRequired
  case inProgress
  case done
}

fileprivate let model = RoomModel(
    name: "Kitchen",
    image: nil,
    items: [RoomItem(
        cleanlinessStatus: "0% clean",
        icon: .dishes,
        lastCleaningDate: Calendar.current.startOfDay(for: Date()),
        cleaningFrequency: .daily,
        state: .cleanRequired)
    ],
    totalCleanlinessStatus: 21)
