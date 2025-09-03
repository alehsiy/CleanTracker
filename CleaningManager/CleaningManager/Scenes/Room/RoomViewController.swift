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

    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil

    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.97, alpha: 1)

        setupNavigationBar()

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(
            RoomHeaderCell.self,
            forCellWithReuseIdentifier: RoomHeaderCell.reuseIdentifier
        )
        collectionView.register(
            RoomItemCell.self,
            forCellWithReuseIdentifier: RoomItemCell.reuseIdentifier
        )
        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == Section.header.rawValue {
            return 1
        } else {
            return model.items.count
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if indexPath.section == Section.header.rawValue {
            // swiftlint:disable force_cast
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RoomHeaderCell.reuseIdentifier,
                for: indexPath
            ) as! RoomHeaderCell
            // swiftlint:enable force_cast
            cell.configure(
                roomName: model.name,
                subtitle: "Cleaning items in this room",
                image: model.emojiIcon.asImage()
            )
            return cell
        } else {
            // swiftlint:disable force_cast
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RoomItemCell.reuseIdentifier,
                for: indexPath
            ) as! RoomItemCell
            // swiftlint:enable force_cast
            cell.configure(
                icon: model.items[indexPath.item].icon,
                title: model.items[indexPath.item].title,
                percent: model.items[indexPath.item].cleanlinessPercent,
                date: model.items[indexPath.item].lastCleaningDate,
                state: model.items[indexPath.item].state.title,
                cleanCount: model.items[indexPath.item].cleanCount,
                cleaningFrequency: model.items[indexPath.item].cleaningFrequency.title,
                nextDate: model.items[indexPath.item].nextDate
            )
            return cell
        }
    }
}

// MARK: - Private Methods

private extension RoomViewController {
    func makeLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            if sectionIndex == 0 {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(120)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = itemSize
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16)
                return section
            } else {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(160)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
                let groupSize = itemSize
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
                return section
            }
        }
    }

    private func setupNavigationBar() {
        self.title = "Cleaning Room"

        let settingsButton = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(settingsButtonTapped)
        )
        navigationItem.rightBarButtonItem = settingsButton
    }

    @objc private func settingsButtonTapped() {
        // Handle Settings button tap
        print("Settings button tapped")
    }
}
