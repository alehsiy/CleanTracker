//
//  EntitySettingsModalScreen.swift
//  CleaningManager
//
//  Created by Zvorygin Aleksey on 16.09.2025.
//

import UIKit

final class EntitySettingsModalScreen: UIViewController, ModalScreenHandler {
    
    weak var delegate: AddItemModalScreenDelegate?
    var selectedIcon: String?
    var items: [Zone] = []
    var roomId: String?
    var roomName: String?
    var roomIcon: String?

    // MARK: - Private properties
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    private let descriptionForIcons = UILabel()
    private let descriptionForTextField = UILabel()
    private let descriptionForRoomItemsStack = UILabel()
    private let nameOfItemTextField = UITextField()
    private let confirmChangesButton = UIButton()
    private let deleteRoomButton = UIButton()
    var onAddingItem: (() -> Void)?
    var onDeletingRoom: (() -> Void)?

    private let tableWithRoomItems = UITableView(frame: .zero, style: .plain)
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
        
        tableWithRoomItems.dataSource = self
        tableWithRoomItems.delegate = self
        tableWithRoomItems.register(
            CollectionRoomItemCell.self,
            forCellReuseIdentifier: String(describing: CollectionRoomItemCell.self))
    }
    
    // MARK: - Setup
    private func setupUI() {
        
        setupContainerViewbaseUI()
        
        containerView.addSubview(descriptionForIcons)
        descriptionForIcons.font = .systemFont(ofSize: 14)
        descriptionForIcons.textAlignment = .left
        descriptionForIcons.text = "Select Room's new icon:"
        descriptionForIcons.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(iconsButtonsStackView)
        
        containerView.addSubview(moreEmojisButton)
            moreEmojisButton.addTarget(
                self,
                action: #selector(showEmojiPicker),
                for: .touchUpInside
            )
        
        containerView.addSubview(descriptionForTextField)
        descriptionForTextField.font = .systemFont(ofSize: 14)
        descriptionForTextField.textAlignment = .left
        descriptionForTextField.text = "Write Room's new name:"
        descriptionForTextField.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(nameOfItemTextField)
        
        nameOfItemTextField.text = roomName ?? "Type new name"
        nameOfItemTextField.borderStyle = .roundedRect
        nameOfItemTextField.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(descriptionForRoomItemsStack)
        descriptionForRoomItemsStack.font = .systemFont(ofSize: 14)
        descriptionForRoomItemsStack.textAlignment = .left
        descriptionForRoomItemsStack.text = "List of items. Tap to delete:"
        descriptionForRoomItemsStack.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(tableWithRoomItems)
        tableWithRoomItems.translatesAutoresizingMaskIntoConstraints = false
        tableWithRoomItems.separatorColor = .clear

        containerView.addSubview(confirmChangesButton)
        confirmChangesButton.addTarget(
            self,
            action: #selector(confirmChangeButtonPressed),
            for: .touchUpInside
        )
        confirmChangesButton.setTitle("Confirm changes", for: .normal)
        confirmChangesButton.setTitleColor(.white, for: .normal)
        confirmChangesButton.layer.cornerRadius = 16
        confirmChangesButton.backgroundColor = .systemBlue
        confirmChangesButton.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(deleteRoomButton)
        deleteRoomButton.addTarget(
            self,
            action: #selector(deleteRoomButtonPressed),
            for: .touchUpInside
        )
        deleteRoomButton.setTitle("Delete room", for: .normal)
        deleteRoomButton.setTitleColor(.white, for: .normal)
        deleteRoomButton.layer.cornerRadius = 16
        deleteRoomButton.backgroundColor = .systemRed
        deleteRoomButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayout() {
        setupContainerView()
        
        setupIconsStack()
        
        setupNameOfRoomField()
        
        setupRoomItemsStack()
        
        NSLayoutConstraint.activate([
        confirmChangesButton.topAnchor.constraint(
            equalTo: tableWithRoomItems.bottomAnchor,
            constant: 16),
        confirmChangesButton.leadingAnchor.constraint(
            equalTo: containerView.leadingAnchor,
            constant: 16),
        confirmChangesButton.trailingAnchor.constraint(
            equalTo: containerView.trailingAnchor,
            constant: -16),
        confirmChangesButton.heightAnchor.constraint(
            equalToConstant: 40),
        confirmChangesButton.bottomAnchor.constraint(
            equalTo: deleteRoomButton.topAnchor,
            constant: -16),
        deleteRoomButton.topAnchor.constraint(
            equalTo: confirmChangesButton.bottomAnchor,
            constant: 16),
        deleteRoomButton.leadingAnchor.constraint(
            equalTo: containerView.leadingAnchor,
            constant: 16),
        deleteRoomButton.trailingAnchor.constraint(
            equalTo: containerView.trailingAnchor,
            constant: -16),
        deleteRoomButton.heightAnchor.constraint(
            equalToConstant: 40),
        deleteRoomButton.bottomAnchor.constraint(
            equalTo: containerView.bottomAnchor,
            constant: -16)
        ])
    }
    
    private func setupRoomItemsStack() {
        NSLayoutConstraint.activate([
        descriptionForRoomItemsStack.topAnchor.constraint(
            equalTo: nameOfItemTextField.bottomAnchor,
            constant: 16),
        descriptionForRoomItemsStack.leadingAnchor.constraint(
            equalTo: containerView.leadingAnchor,
            constant: 16),
        descriptionForRoomItemsStack.trailingAnchor.constraint(
            equalTo: containerView.trailingAnchor,
            constant: -16),
        
        tableWithRoomItems.topAnchor.constraint(
            equalTo: descriptionForRoomItemsStack.bottomAnchor,
            constant: 6),
        tableWithRoomItems.leadingAnchor.constraint(
            equalTo: containerView.leadingAnchor,
            constant: 14),
        tableWithRoomItems.trailingAnchor.constraint(
            equalTo: containerView.trailingAnchor,
            constant: -14),
        tableWithRoomItems.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func makeButtonForIconsStack(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 32)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(iconTapped(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 0
        button.backgroundColor = .systemGray6
        button.widthAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true
        return button
    }
    
    internal lazy var iconsButtonsStackView: UIStackView = {
        let kitchen = makeButtonForIconsStack(title: "🍽️")
        let bathroom = makeButtonForIconsStack(title: "🛁")
        let bed = makeButtonForIconsStack(title: "🪟")
        let wardrobe = makeButtonForIconsStack(title: "🛏️")
        let garden = makeButtonForIconsStack(title: "🌸")
        
        let stack = UIStackView(arrangedSubviews: [
            kitchen, bathroom, bed, wardrobe, garden
        ])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fill
        stack.isLayoutMarginsRelativeArrangement = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    internal let moreEmojisButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("More Emojis", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemGray6
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        confirmChangeButtonPressed()
        return true
    }
}

// MARK: - extentions

extension EntitySettingsModalScreen: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: CollectionRoomItemCell.self)) as? CollectionRoomItemCell else {
            fatalError("error in cell")
        }
        let item = items[indexPath.row]
        cell.configure(with: item.name)

        return cell
    }
}

extension EntitySettingsModalScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        let selectedItemTitle = selectedItem.name
        let alert = UIAlertController(
            title: "Confirm delete \(selectedItemTitle)",
            message: "Are you sure?",
            preferredStyle: .alert)
        
        alert.addAction(
            UIAlertAction(
                title: "No",
                style: .cancel,
                handler: { _ in
                    print("user tap NO")
                }
            )
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Yes",
                style: .default,
                handler: { [weak self] _ in
                    Task {
                        try await ZoneService.shared.deleteZone(id: self!.items[indexPath.row].id)
                        self?.onAddingItem?()
                        self?.items = try await RoomService.shared.getRoomZones(id: self!.roomId!)
                        self?.tableWithRoomItems.reloadData()
                    }
                    print("user tap Yes")
                }
            )
        )
        
        present(alert, animated: true, completion: nil)
    }
}

private extension EntitySettingsModalScreen {
    private func setupContainerViewbaseUI() {
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        view.addSubview(containerView)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(titleLabel)
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        titleLabel.text = "Room settings"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(closeButton)
        closeButton.addTarget(
            self,
            action: #selector(closePressed),
            for: .touchUpInside
        )
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .systemBlue
        closeButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupContainerView() {
        NSLayoutConstraint.activate([
        containerView.centerXAnchor.constraint(
            equalTo: view.centerXAnchor),
        containerView.centerYAnchor.constraint(
            equalTo: view.centerYAnchor),

        containerView.leadingAnchor.constraint(
            greaterThanOrEqualTo: view.leadingAnchor,
            constant: 16),
        containerView.trailingAnchor.constraint(
            lessThanOrEqualTo: view.trailingAnchor,
            constant: -16),
        
        titleLabel.centerXAnchor.constraint(
            equalTo: containerView.centerXAnchor),
        titleLabel.topAnchor.constraint(
            equalTo: containerView.topAnchor,
            constant: 16),
        
        closeButton.topAnchor.constraint(
            equalTo: containerView.topAnchor,
            constant: 16),
        closeButton.trailingAnchor.constraint(
            equalTo: containerView.trailingAnchor,
            constant: -16),
        closeButton.widthAnchor.constraint(
            equalToConstant: 16),
        closeButton.heightAnchor.constraint(
            equalToConstant: 16)
        ])
    }
    
    private func setupIconsStack() {
        NSLayoutConstraint.activate([
            descriptionForIcons.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 8),
            descriptionForIcons.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: 16),
            descriptionForIcons.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -16),
        
            iconsButtonsStackView.topAnchor.constraint(
                equalTo: descriptionForIcons.bottomAnchor,
                constant: 6),
            iconsButtonsStackView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: 16),
            iconsButtonsStackView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -16),
            iconsButtonsStackView.heightAnchor.constraint(
                equalToConstant: 40),
            
            moreEmojisButton.topAnchor.constraint(
                equalTo: iconsButtonsStackView.bottomAnchor,
                constant: 8),
            moreEmojisButton.centerXAnchor.constraint(
                equalTo: containerView.centerXAnchor,
                constant: 0),
            moreEmojisButton.widthAnchor.constraint(
                equalToConstant: 120),
            moreEmojisButton.heightAnchor.constraint(
                equalToConstant: 38),
        ])
    }
    
    private func setupNameOfRoomField() {
        NSLayoutConstraint.activate([
        descriptionForTextField.topAnchor.constraint(
            equalTo: moreEmojisButton.bottomAnchor,
            constant: 16),
        descriptionForTextField.leadingAnchor.constraint(
            equalTo: containerView.leadingAnchor,
            constant: 16),
        descriptionForTextField.trailingAnchor.constraint(
            equalTo: containerView.trailingAnchor,
            constant: -16),
        
        nameOfItemTextField.topAnchor.constraint(
            equalTo: descriptionForTextField.bottomAnchor,
            constant: 6),
        nameOfItemTextField.leadingAnchor.constraint(
            equalTo: containerView.leadingAnchor,
            constant: 16),
        nameOfItemTextField.trailingAnchor.constraint(
            equalTo: containerView.trailingAnchor,
            constant: -16)
        ])
    }
}

// MARK: - objc funcs

private extension EntitySettingsModalScreen {
    @objc
    internal func showEmojiPicker() {
        shared_showEmojiPicker()
    }
    
    @objc
    internal func iconTapped(_ sender: UIButton) {
        shared_iconTapped(sender)
    }
    
    @objc
    private func closePressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func confirmChangeButtonPressed() {
        guard let id = roomId else {
            // TODO: Сделать алёрт
            return
        }
        let itemName = nameOfItemTextField.text ?? ""
        let itemIcon = selectedIcon ?? roomIcon
        Task {
            try await RoomService.shared.updateRoom(id: id, name: itemName, icon: itemIcon)
            onAddingItem?()
        }
        dismiss(animated: true, completion: nil)
        print("Введено: \(itemName), Выбрана иконка: \(itemIcon), Выбрана")
    }

    @objc
    private func deleteRoomButtonPressed() {
        guard let id = roomId else {
            // TODO: Сделать алёрт
            return
        }
        let alert = UIAlertController(
            title: "Confirm delete room",
            message: "Are you sure?",
            preferredStyle: .alert)

        alert.addAction(
            UIAlertAction(
                title: "No",
                style: .cancel,
                handler: { _ in
                    print("user tap NO")
                }
            )
        )

        alert.addAction(
            UIAlertAction(
                title: "Yes",
                style: .default,
                handler: { [weak self] _ in
                    Task {
                        try await RoomService.shared.deleteRoom(id: id)
                        self?.onDeletingRoom?()
                        self?.dismiss(animated: true)
                    }
                    print("user tap Yes")
                }
            )
        )

        present(alert, animated: true, completion: nil)
        print("Удалена комната")
    }
}
