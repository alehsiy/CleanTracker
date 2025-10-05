//
//  AddItemModalScreen.swift
//  CleaningManager
//
//  Created by Zvorygin Aleksey on 10.09.2025.
//

import UIKit

protocol AddItemModalScreenDelegate: AnyObject {
    func AddItemModalScreen(
        _ controller: AddItemModalScreen,
        didEnterName name: String,
        icon: String,
        frequency: String
    )
}

final class AddItemModalScreen: UIViewController, UITextFieldDelegate, ModalScreenHandler {
    
    weak var delegate: AddItemModalScreenDelegate?
    var selectedIcon: String?
    var selectedFrequency: String?
    var roomId: String!
    var onAddingItem: (() -> Void)?

    // MARK: - Private properties
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    private let descriptionForIcons = UILabel()
    private let descriptionForTextField = UILabel()
    private let descriptionForCleaningFrequencyButtons = UILabel()
    private let nameOfItemTextField = UITextField()
    private let addItemButton = UIButton()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        nameOfItemTextField.delegate = self
        
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
        titleLabel.text = "Add item"
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
        descriptionForIcons.text = "Select item's icon:"
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
        descriptionForTextField.text = "Input item name:"
        descriptionForTextField.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(nameOfItemTextField)
        nameOfItemTextField.placeholder = "Enter item name"
        nameOfItemTextField.borderStyle = .roundedRect
        nameOfItemTextField.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(descriptionForCleaningFrequencyButtons)
        descriptionForCleaningFrequencyButtons.font = .systemFont(ofSize: 14)
        descriptionForCleaningFrequencyButtons.textAlignment = .left
        descriptionForCleaningFrequencyButtons.text = "Select cleaning frequency:"
        descriptionForCleaningFrequencyButtons.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(cleaningFrequencyStackView)
        
        containerView.addSubview(addItemButton)
        addItemButton.addTarget(
            self,
            action: #selector(addItemButtonPressed),
            for: .touchUpInside
        )
        addItemButton.setTitle("Add item", for: .normal)
        addItemButton.setTitleColor(.white, for: .normal)
        addItemButton.layer.cornerRadius = 16
        addItemButton.backgroundColor = .systemBlue
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayout() {
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
            constant: 16)
        ])
        
        setupIconsStack()
        
        setupNameOfItemField()
        
        setupCleaningFrequencyStack()
        
        NSLayoutConstraint.activate([
        addItemButton.topAnchor.constraint(
            equalTo: cleaningFrequencyStackView.bottomAnchor,
            constant: 16),
        addItemButton.leadingAnchor.constraint(
            equalTo: containerView.leadingAnchor,
            constant: 16),
        addItemButton.trailingAnchor.constraint(
            equalTo: containerView.trailingAnchor,
            constant: -16),
        addItemButton.heightAnchor.constraint(
            equalToConstant: 40),
        addItemButton.bottomAnchor.constraint(
            equalTo: containerView.bottomAnchor,
            constant: -16)
        ])
        
        NSLayoutConstraint.activate([
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
                equalToConstant: 40)
        ])
    }
    
    private func setupNameOfItemField() {
        NSLayoutConstraint.activate([
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
            
        descriptionForTextField.topAnchor.constraint(
            equalTo: moreEmojisButton.bottomAnchor,
            constant: 6),
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
    
    private func setupCleaningFrequencyStack() {
        NSLayoutConstraint.activate([
        descriptionForCleaningFrequencyButtons.topAnchor.constraint(
            equalTo: nameOfItemTextField.bottomAnchor,
            constant: 16),
        descriptionForCleaningFrequencyButtons.leadingAnchor.constraint(
            equalTo: containerView.leadingAnchor,
            constant: 16),
        descriptionForCleaningFrequencyButtons.trailingAnchor.constraint(
            equalTo: containerView.trailingAnchor,
            constant: -16),
        
        cleaningFrequencyStackView.topAnchor.constraint(
            equalTo: descriptionForCleaningFrequencyButtons.bottomAnchor,
            constant: 6),
        cleaningFrequencyStackView.leadingAnchor.constraint(
            equalTo: containerView.leadingAnchor,
            constant: 16),
        cleaningFrequencyStackView.trailingAnchor.constraint(
            equalTo: containerView.trailingAnchor,
            constant: -16),
        cleaningFrequencyStackView.heightAnchor.constraint(
            equalToConstant: 40)
        ])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        addItemButtonPressed()
        return true
    }
    
    private func makeButtonForStack(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemGray6
        button.widthAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true
        button.layer.borderWidth = 0
        return button
    }
    
    internal lazy var iconsButtonsStackView: UIStackView = {
        let kitchen = makeButtonForStack(title: "🍽️")
        let bathroom = makeButtonForStack(title: "🛁")
        let bed = makeButtonForStack(title: "🪟")
        let wardrobe = makeButtonForStack(title: "🛏️")
        let garden = makeButtonForStack(title: "🥬")
        
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
    
    private lazy var cleaningFrequencyStackView: UIStackView = {
        let daily = makeButtonForStack(title: "Daily")
        let weekly = makeButtonForStack(title: "Weekly")
        let monthly = makeButtonForStack(title: "Monthly")
        
        let stack = UIStackView(arrangedSubviews: [
            daily, weekly, monthly
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
                action: #selector(frequencyTapped(_:)),
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
}

extension AddItemModalScreen {
    
    @objc
    internal func showEmojiPicker() {
        shared_showEmojiPicker()
    }
    
    @objc
    internal func iconTapped(_ sender: UIButton) {
        shared_iconTapped(sender)
    }
    
    @objc
    private func frequencyTapped(_ sender: UIButton) {
        for button in cleaningFrequencyStackView.arrangedSubviews.compactMap({
            $0 as? UIButton
        }) {
            button.backgroundColor = .systemGray6
            button.layer.borderWidth = 0
        }
        sender.layer.borderWidth = 2
        sender.layer.borderColor = UIColor.systemBlue.cgColor
        selectedFrequency = sender.currentTitle
        
    }
    
    @objc
    private func closePressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func addItemButtonPressed() {
        let itemName = nameOfItemTextField.text ?? ""
        let itemIcon = selectedIcon ?? ""
        let itemFrequency = selectedFrequency?.lowercased() ?? ""
        delegate?.AddItemModalScreen(
            self,
            didEnterName: itemName,
            icon: itemIcon,
            frequency: itemFrequency
        )
        Task {
            try await RoomService.shared.createZone(id: roomId, name: itemName, icon: itemIcon, frequency: itemFrequency)
            onAddingItem?()
        }
        dismiss(animated: true, completion: nil)
        print("Введено: \(itemName), Выбрана иконка: \(itemIcon), Выбрана частота:\(itemFrequency)")
    }
}
