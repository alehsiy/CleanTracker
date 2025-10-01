//
//  RoomViewController.swift
//  CleaningManager
//
//  Created by Zvorygin Aleksey on 19.08.2025.
//

import UIKit

protocol roomViewControllerDelegate: AnyObject {
    func roomViewController(
        _ controller: RoomViewController,
        didEnterName name: String,
        icon: String
    )
}

final class RoomViewController: UIViewController, UICollectionViewDataSource {
    var room: Room?
    var roomId: String?
    private var zones: [Zone] = []

    enum Section: Int, CaseIterable {
        case header
        case zone
    }

    weak var delegate: roomViewControllerDelegate?

    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil

    var collectionView: UICollectionView!

    private let addItemButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add item", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 16
        button.layer.cornerCurve = .continuous
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        showItems(roomId: room!.id)
        view.backgroundColor = UIColor(white: 0.97, alpha: 1)

        setupAddItemButton()
        setupNavigationBar()
        setupCollectionView()
    }

    func setupCollectionView() {
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
        collectionView.register(
            RoomPlaceholderCell.self,
            forCellWithReuseIdentifier: RoomPlaceholderCell.reuseIdentifier
        )
        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: addItemButton.topAnchor, constant: -16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == Section.header.rawValue {
            return 1
        } else {
            return zones.isEmpty ? 1 : zones.count
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
            if let room {
                if let zones = room.totalZones, zones > 0 {
                    cell.configure(
                        roomName: room.name,
                        image: room.icon.asImage(),
                        progress: room.progressText
                    )
                } else {
                    cell.configure(
                        roomName: room.name,
                        image: room.icon.asImage(),
                        progress: "No zones yet"
                    )
                }
            } else {
                cell.configure(
                    roomName: "Oops!",
                    image: "😔".asImage(),
                    progress: "We can't find your room"
                )
            }
            return cell
        } else {
            if zones.isEmpty {
                // swiftlint:disable force_cast
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: RoomPlaceholderCell.reuseIdentifier,
                    for: indexPath
                ) as! RoomPlaceholderCell
                // swiftlint:enable force_cast
                return cell
            }
            // swiftlint:disable force_cast
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RoomItemCell.reuseIdentifier,
                for: indexPath
            ) as! RoomItemCell
            // swiftlint:enable force_cast
            cell.configure(
                icon: zones[indexPath.item].icon,
                title: zones[indexPath.item].name,
                lastDate: zones[indexPath.item].lastCleanedAt,
                cleaningFrequency: zones[indexPath.item].frequency.rawValue,
                nextDate: zones[indexPath.item].nextDueAt,
                isDue: zones[indexPath.item].isDue
            )
            cell.itemId = zones[indexPath.item].id
            cell.onCleanItem = { [weak self] in
                self?.showItems(roomId: self?.room?.id ?? "")
            }
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

    func setupNavigationBar() {
        let settingsButton = UIBarButtonItem(
            image: UIImage(systemName: "gearshape"),
            style: .plain,
            target: self,
            action: #selector(settingsButtonTapped)
        )
        navigationItem.rightBarButtonItem = settingsButton
        navigationItem.title = room?.name
    }

    func setupAddItemButton() {
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addItemButton)
        NSLayoutConstraint.activate([
            addItemButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            addItemButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addItemButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addItemButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        addItemButton.addTarget(self, action: #selector(didTapAddItemButton), for: .touchUpInside)
    }

    func showItems(roomId id: String) {
        Task {
            do {
                let zones = try await RoomService.shared.getRoomZones(id: id)
                let room = try await RoomService.shared.getRoomById(id: id)
                await MainActor.run {
                    self.zones = zones
                    self.room = room
                    collectionView.reloadData()
                }
            } catch {
                await MainActor.run {
                    print(error.localizedDescription)
                }
            }
        }
    }

    func getRoom() {
        Task {
            do {
                let room = try await RoomService.shared.getRoomById(id: roomId ?? "")
                await MainActor.run {
                    self.room = room
                }
            } catch {
                await MainActor.run {
                    print(error.localizedDescription)
                }
            }
        }
    }

    @objc
    func settingsButtonTapped() {
        let modalVC = CleaningManager.EntitySettingsModalScreen()
        modalVC.items = zones
        modalVC.modalPresentationStyle = .overFullScreen
        modalVC.modalTransitionStyle = .crossDissolve
        modalVC.roomId = room?.id
        modalVC.onAddingItem = { [weak self] in
            self?.showItems(roomId: self?.room?.id ?? "")
        }
        present(modalVC, animated: true, completion: nil)
        print("Settings button tapped")
    }

    @objc
    func didTapAddItemButton() {
        let modalVC = CleaningManager.AddItemModalScreen()
        modalVC.modalPresentationStyle = .overFullScreen
        modalVC.modalTransitionStyle = .crossDissolve
        modalVC.roomId = room?.id
        modalVC.onAddingItem = { [weak self] in
            self?.showItems(roomId: self?.room?.id ?? "")
        }
        present(modalVC, animated: true, completion: nil)
        print("Add item button tapped")
    }
}
