//
//  AddRoomModalScreen.swift
//  CleaningManager
//
//  Created by Zvorygin Aleksey on 19.08.2025.
//

import UIKit

protocol AddRoomModalScreenDelegate: AnyObject {
    func AddRoomModalScreen(
        _ controller: AddRoomModalScreen,
        didEnterName name: String,
        icon: String
    )
}

final class AddRoomModalScreen: UIViewController, UITextFieldDelegate, ModalScreenHandler  {
    
    weak var delegate: AddRoomModalScreenDelegate?
    var selectedIcon: String?

    // MARK: - Private properties
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    private let descriptionForIcons = UILabel()
    private let descriptionForTextField = UILabel()
    private let addRoomButton = UIButton()
    private let nameOfRoomTextField = UITextField()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        nameOfRoomTextField.delegate = self
        
        setupUI()
        setupLayout()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.addSubview(containerView)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(titleLabel)
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        titleLabel.text = "Add room"
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
        
        containerView.addSubview(descriptionForIcons)
        descriptionForIcons.font = .systemFont(ofSize: 14)
        descriptionForIcons.textAlignment = .left
        descriptionForIcons.text = "Select icon for room:"
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
        descriptionForTextField.text = "Input room name:"
        descriptionForTextField.translatesAutoresizingMaskIntoConstraints =
        false
        
        containerView.addSubview(nameOfRoomTextField)
        nameOfRoomTextField.placeholder = "Enter room name"
        nameOfRoomTextField.borderStyle = .roundedRect
        nameOfRoomTextField.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(addRoomButton)
        addRoomButton.addTarget(
            self,
            action: #selector(addRoomButtonPressed),
            for: .touchUpInside
        )
        addRoomButton.setTitle("Add room", for: .normal)
        addRoomButton.setTitleColor(.white, for: .normal)
        addRoomButton.layer.cornerRadius = 16
        addRoomButton.backgroundColor = .systemBlue
        addRoomButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayout() {
        containerView.centerXAnchor.constraint(
            equalTo: view.centerXAnchor
        ).isActive = true
        containerView.centerYAnchor.constraint(
            equalTo: view.centerYAnchor
        ).isActive = true
        containerView.widthAnchor.constraint(
            equalToConstant: 300
        ).isActive = true
        
        titleLabel.centerXAnchor.constraint(
            equalTo: containerView.centerXAnchor
        ).isActive = true
        titleLabel.topAnchor.constraint(
            equalTo: containerView.topAnchor,
            constant: 16
        ).isActive = true
        
        setupDescriptionsForElements()
        
        nameOfRoomTextField.centerXAnchor.constraint(
            equalTo: containerView.centerXAnchor
        ).isActive = true
        nameOfRoomTextField.topAnchor.constraint(
            equalTo: descriptionForTextField.bottomAnchor,
            constant: 4
        ).isActive = true
        nameOfRoomTextField.leadingAnchor.constraint(
            equalTo: containerView.leadingAnchor,
            constant: 16
        ).isActive = true
        nameOfRoomTextField.trailingAnchor.constraint(
            equalTo: containerView.trailingAnchor,
            constant: -16
        ).isActive = true
        
        setupIconsButtonsStack()
        
        addRoomButton.centerXAnchor.constraint(
            equalTo: containerView.centerXAnchor
        ).isActive = true
        addRoomButton.topAnchor.constraint(
            equalTo: nameOfRoomTextField.bottomAnchor,
            constant: 16
        ).isActive = true
        addRoomButton.widthAnchor.constraint(
            equalToConstant: 268
        ).isActive = true
        addRoomButton.heightAnchor.constraint(
            equalToConstant: 40
        ).isActive = true
        addRoomButton.bottomAnchor.constraint(
            equalTo: containerView.bottomAnchor,
            constant: -16
        ).isActive = true
        
        closeButton.topAnchor.constraint(
            equalTo: containerView.topAnchor,
            constant: 16
        ).isActive = true
        closeButton.trailingAnchor.constraint(
            equalTo: containerView.trailingAnchor,
            constant: -16
        ).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 16).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
    
    private func setupDescriptionsForElements() {
        descriptionForIcons.topAnchor.constraint(
            equalTo: titleLabel.bottomAnchor,
            constant: 8
        ).isActive = true
        descriptionForIcons.leadingAnchor.constraint(
            equalTo: containerView.leadingAnchor,
            constant: 16
        ).isActive = true
        descriptionForIcons.trailingAnchor.constraint(
            equalTo: containerView.trailingAnchor,
            constant: -16
        ).isActive = true
        
        moreEmojisButton.topAnchor.constraint(
            equalTo: iconsButtonsStackView.bottomAnchor,
            constant: 8).isActive = true
        moreEmojisButton.centerXAnchor.constraint(
            equalTo: containerView.centerXAnchor,
            constant: 0).isActive = true
        moreEmojisButton.widthAnchor.constraint(
            equalToConstant: 120).isActive = true
        moreEmojisButton.heightAnchor.constraint(
            equalToConstant: 38).isActive = true
        
        descriptionForTextField.topAnchor.constraint(
            equalTo: moreEmojisButton.bottomAnchor,
            constant: 8
        ).isActive = true
        descriptionForTextField.leadingAnchor.constraint(
            equalTo: containerView.leadingAnchor,
            constant: 16
        ).isActive = true
        descriptionForTextField.trailingAnchor.constraint(
            equalTo: containerView.trailingAnchor,
            constant: -16
        ).isActive = true
    }
    
    private func setupIconsButtonsStack() {
        iconsButtonsStackView.topAnchor.constraint(
            equalTo: descriptionForIcons.bottomAnchor,
            constant: 6
        ).isActive = true
        iconsButtonsStackView.leadingAnchor.constraint(
            equalTo: containerView.leadingAnchor,
            constant: 16
        ).isActive = true
        iconsButtonsStackView.trailingAnchor.constraint(
            equalTo: containerView.trailingAnchor,
            constant: -16
        ).isActive = true
        iconsButtonsStackView.heightAnchor.constraint(
            equalToConstant: 40
        ).isActive = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        addRoomButtonPressed()
        return true
    }
    
    private func makeIconButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 28)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 0
        button.backgroundColor = .systemGray6
        return button
    }
    
    lazy var iconsButtonsStackView: UIStackView = {
        let kitchen = makeIconButton(title: "🍽️")
        let bathroom = makeIconButton(title: "🚿")
        let bed = makeIconButton(title: "🛏️")
        let wardrobe = makeIconButton(title: "🗄️")
        let garden = makeIconButton(title: "🏡")
        
        let stack = UIStackView(arrangedSubviews: [
            kitchen, bathroom, bed, wardrobe, garden
        ])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.isLayoutMarginsRelativeArrangement = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        // обработка нажатий для всех кнопок
        for button in stack.arrangedSubviews.compactMap({ $0 as? UIButton }) {
            button.addTarget(
                self,
                action: #selector(iconTapped(_:)),
                for: .touchUpInside
            )
        }
        
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
    private func addRoomButtonPressed() {
        
        let roomName = nameOfRoomTextField.text ?? ""
        let roomIcon = selectedIcon ?? ""
        Task {
            try await RoomService.shared.createRoom(name: roomName, icon: roomIcon)
        }
        delegate?.AddRoomModalScreen(
            self,
            didEnterName: roomName,
            icon: roomIcon
        )
        print("Введено: \(roomName), Выбрана иконка: \(roomIcon)")
    }
}
