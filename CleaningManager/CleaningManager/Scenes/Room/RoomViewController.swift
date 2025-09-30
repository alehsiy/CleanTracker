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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.tintColor = .label
        button.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        button.layer.cornerRadius = 16
        button.layer.cornerCurve = .continuous
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        showItems(roomId: room!.id)
        view.backgroundColor = UIColor(white: 0.97, alpha: 1)

        setupNavigationBar()

        // TODO: Добавить PlaceholderView, если нет items


//        collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
//        collectionView.dataSource = self
//        collectionView.backgroundColor = .clear
//        collectionView.register(
//            RoomHeaderCell.self,
//            forCellWithReuseIdentifier: RoomHeaderCell.reuseIdentifier
//        )
//        collectionView.register(
//            RoomItemCell.self,
//            forCellWithReuseIdentifier: RoomItemCell.reuseIdentifier
//        )
//        view.addSubview(collectionView)
//
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ])
        
        setupAddItemButton()
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
            return zones.count
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
                cell.configure(
                    roomName: room.name,
                    subtitle: "Cleaning items in this room",
                    image: room.icon.asImage(),
                    progress: "2/3 Clean  ・  48%"
                )
            } else {
                print("")
            }
            return cell
        } else {
            // swiftlint:disable force_cast
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RoomItemCell.reuseIdentifier,
                for: indexPath
            ) as! RoomItemCell
            // swiftlint:enable force_cast
            cell.configure(
                icon: zones[indexPath.item].icon,
                title: zones[indexPath.item].name,
                date: zones[indexPath.item].lastCleanedAt,
                cleaningFrequency: zones[indexPath.item].frequency.rawValue,
                nextDate: zones[indexPath.item].nextDueAt
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

    func setupNavigationBar() {
        let settingsButton = UIBarButtonItem(
            image: UIImage(systemName: "gearshape"),
            style: .plain,
            target: self,
            action: #selector(settingsButtonTapped)
        )
        navigationItem.rightBarButtonItem = settingsButton
        navigationItem.title = model.name
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
                let rooms = try await RoomService.shared.getRoomZones(id: id)
                await MainActor.run {
                    self.zones = rooms
                    setupCollectionView()
                }
            } catch {
                await MainActor.run {
                    print(error.localizedDescription)
                }
            }
        }
    }

    @objc func settingsButtonTapped() {
        let modalVC = CleaningManager.EntitySettingsModalScreen()
        modalVC.items = model.items
        modalVC.modalPresentationStyle = .overFullScreen
        modalVC.modalTransitionStyle = .crossDissolve
        present(modalVC, animated: true, completion: nil)
        print("Settings button tapped")
    }
    
    @objc
    func didTapAddItemButton() {
        let modalVC = CleaningManager.AddItemModalScreen()
        modalVC.modalPresentationStyle = .overFullScreen
        modalVC.modalTransitionStyle = .crossDissolve
        present(modalVC, animated: true, completion: nil)
        print("Add item button tapped")
    }
}
