//
//  HomeViewController.swift
//  CleaningManager
//
//  Created by Zvorygin Aleksey on 19.08.2025.
//

import UIKit

final class HomeViewController: UIViewController {

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

    // MARK: - Mock Data
    private var rooms: [Room] = [
        Room(id: UUID(), name: "Kitchen", icon: "🍽️", completedTasks: 3, totalTasks: 5, needsAttention: true),
        Room(id: UUID(), name: "Living room", icon: "🛋️", completedTasks: 0, totalTasks: 5, needsAttention: true),
        Room(id: UUID(), name: "Guest room", icon: "🌇", completedTasks: 3, totalTasks: 5, needsAttention: true),
        Room(id: UUID(), name: "Bedroom", icon: "🛌", completedTasks: 5, totalTasks: 5, needsAttention: false),
        Room(id: UUID(), name: "Bathroom", icon: "🚿", completedTasks: 2, totalTasks: 4, needsAttention: true)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setup()

        view.backgroundColor = .white
    }

    private func setup() {
        setupProgressBar()
        setupSectionTitle()
        setupAddRoomButton()
        setupTableView()
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
        let totalTasks = rooms.reduce(0) { $0 + $1.totalTasks }
        let completedTasks = rooms.reduce(0) { $0 + $1.completedTasks }
        return totalTasks > 0 ? Float(completedTasks) / Float(totalTasks) : 0
    }

    @objc private func didTapNotificationButton() {
        print("Notification button tapped!")
    }

    @objc private func didTapAddRoomButton() {
        print("Add room button tapped!")
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath) as! RoomTableViewCell
        let room = rooms[indexPath.row]
        cell.configure(with: room)
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
