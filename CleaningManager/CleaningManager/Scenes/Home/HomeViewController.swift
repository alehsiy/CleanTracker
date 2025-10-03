//
//  HomeViewController.swift
//  CleaningManager
//
//  Created by Zvorygin Aleksey on 19.08.2025.
//

import UIKit
import SwiftUI

final class HomeViewController: UIViewController, roomViewControllerDelegate {

    private var rooms: [Room] = []
    private var isLoading = false
    private let roomService = RoomService.shared
    private let progressBar = ProgressBlock()
    private let sectionTitleLabel = UILabel()
    private let tableView = UITableView()

    private let addRoomButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add room", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.tintColor = .label
        button.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        button.layer.cornerRadius = 16
        button.layer.cornerCurve = .continuous
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setup()

        view.backgroundColor = .white

        loadRooms()
        updateEmptyState()
    }

    private func setup() {
        setupProgressBar()
        setupSectionTitle()
        setupAddRoomButton()
        setupTableView()
        setupEmptyStateView()
    }

    private func loadRooms() {
        Task {
            do {
                let rooms = try await roomService.fetchAllRooms()

                await MainActor.run {
                    self.rooms = rooms
                    self.tableView.reloadData()
                    self.updateEmptyState()
                }
            } catch {
                await MainActor.run {
                    self.handleError(error)
                }
            }
        }
    }

    private func handleError(_ error: Error) {
        if let roomError = error as? RoomServiceError {
            switch roomError {
            case .networkError(let underlyingError):
                showError(message: "Network error: \(underlyingError.localizedDescription)")
            case .decodingError:
                showError(message: "Failed to parse server response")
            case .unknown:
                showError(message: "Unknown error occurred")
            }
        } else {
            showError(message: error.localizedDescription)
        }
    }

    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
            self.loadRooms()
        })
        present(alert, animated: true)
    }

    private func setupNavigationBar() {
        title = "Clean Quest"

        let notificationButton = UIBarButtonItem(
            image: UIImage(systemName: "bell"),
            style: .plain,
            target: self,
            action: #selector(didTapNotificationButton)
        )
        notificationButton.tintColor = .systemBlue

        navigationItem.rightBarButtonItem = notificationButton

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.isTranslucent = false
    }

    private func setupProgressBar() {
        view.addSubview(progressBar)
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        let totalProgress = calculateTotalProgress()
        progressBar.updateProgress(totalProgress)
    }

    private func setupSectionTitle() {
        sectionTitleLabel.text = "Your rooms"
        sectionTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sectionTitleLabel)

        NSLayoutConstraint.activate([
            sectionTitleLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 24),
            sectionTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: sectionTitleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addRoomButton.topAnchor, constant: -16)
        ])

        tableView.register(RoomTableViewCell.self, forCellReuseIdentifier: "RoomCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.showsVerticalScrollIndicator = true
    }

    private func setupEmptyStateView() {
        let backgroundView = UIView()
        tableView.backgroundView = backgroundView

        let label = UILabel()
        label.text = "Let's begin your cleaning journey!\nAdd your first room to start"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0

        let imageView = UIImageView(image: UIImage(systemName: "arrowshape.down.circle"))
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit

        backgroundView.addSubview(label)
        backgroundView.addSubview(imageView)

        backgroundView.frame = tableView.bounds
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: -40),
            label.widthAnchor.constraint(lessThanOrEqualToConstant: 300),

            imageView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func updateEmptyState() {
        let isEmpty = rooms.isEmpty
        tableView.backgroundView?.isHidden = !isEmpty
    }

    private func setupAddRoomButton() {
        addRoomButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addRoomButton)

        NSLayoutConstraint.activate([
            addRoomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            addRoomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addRoomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addRoomButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        addRoomButton.addTarget(self, action: #selector(didTapAddRoomButton), for: .touchUpInside)
    }

    private func handleRoomSelection(_ room: Room) {
        print("Selected room: \(room.name)")
    }

    private func calculateTotalProgress() -> Float {
        let totalTasks = rooms.reduce(into: 0) { $0 + ($1.totalZones ?? 0) }
        let completedTasks = rooms.reduce(0) { $0 + ($1.completedZones ?? 0) }
        return totalTasks > 0 ? Float(completedTasks) / Float(totalTasks) : 0
    }

    func roomViewController(_ controller: RoomViewController, didEnterName name: String, icon: String) {
        print("Получили из RoomVC: \(name), \(icon)")
        // todo прогресс из комнат
    }
    
    @objc
    private func didTapNotificationButton() {
        let modalVC = UIHostingController(rootView: NotificationModalScreenView())
        modalVC.view.backgroundColor = .clear
        modalVC.modalPresentationStyle = .overFullScreen
        modalVC.modalTransitionStyle = .crossDissolve
        present(modalVC, animated: true, completion: nil)
        print("Notification button tapped!")
    }

    @objc
    private func didTapAddRoomButton() {
        let modalVC = CleaningManager.AddRoomModalScreen()
        modalVC.modalPresentationStyle = .overFullScreen
        modalVC.modalTransitionStyle = .crossDissolve
        modalVC.delegate = self
        present(modalVC, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath) as? RoomTableViewCell else {
                fatalError("Unable to dequeue RoomTableViewCell")
        }
        let room = rooms[indexPath.row]
        cell.configure(with: room)
        cell.onTap = {
            let roomViewController = RoomViewController()
            roomViewController.roomId = self.rooms[indexPath.row].id
            self.navigationController?.pushViewController(roomViewController, animated: true)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let room = rooms[indexPath.row]
        handleRoomSelection(room)
    }
}

// MARK: - ModalScreenViewControllerDelegate
extension HomeViewController: AddRoomModalScreenDelegate {
    func AddRoomModalScreen(_ controller: AddRoomModalScreen, didEnterName name: String, icon: String, roomId: String) {
        controller.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            print("the modal window is closed")
            let roomVC = RoomViewController()
            roomVC.roomId = roomId
            roomVC.delegate = self
            let nav = self.navigationController
            nav?.pushViewController(roomVC, animated: true)
        }
    }
}
