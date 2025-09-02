//
//  ModalScreenViewController.swift
//  CleaningManager
//
//  Created by Zvorygin Aleksey on 19.08.2025.
//

import UIKit

protocol ModalScreenViewControllerDelegate: AnyObject {
    func modalScreenViewController(
        _ controller: ModalScreenViewController,
        didEnterName name: String,
        icon: String
    )
}

final class ModalScreenViewController: UIViewController, UITextFieldDelegate {
    
    weak var delegate: ModalScreenViewControllerDelegate?
    var selectedIcon: String?
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    private let descriptionForIcons = UILabel()
    private let descriptionForTextField = UILabel()
    private let buttonOkModalScreen = UIButton()
    private let nameOfRoomTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        nameOfRoomTextField.delegate = self
        
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        view.addSubview(containerView)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 15
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(titleLabel)
        titleLabel.font = .boldSystemFont(ofSize: 17)
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
        closeButton.tintColor = .label
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(descriptionForIcons)
        descriptionForIcons.font = .systemFont(ofSize: 13)
        descriptionForIcons.textAlignment = .left
        descriptionForIcons.text = "Select icon for room:"
        descriptionForIcons.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(iconsButtonsStackView)
        
        containerView.addSubview(descriptionForTextField)
        descriptionForTextField.font = .systemFont(ofSize: 13)
        descriptionForTextField.textAlignment = .left
        descriptionForTextField.text = "Input room name:"
        descriptionForTextField.translatesAutoresizingMaskIntoConstraints =
        false
        
        containerView.addSubview(nameOfRoomTextField)
        nameOfRoomTextField.placeholder = "Enter room name"
        nameOfRoomTextField.borderStyle = .roundedRect
        nameOfRoomTextField.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(buttonOkModalScreen)
        buttonOkModalScreen.addTarget(
            self,
            action: #selector(okPressed),
            for: .touchUpInside
        )
        buttonOkModalScreen.setTitle("Ok", for: .normal)
        buttonOkModalScreen.setTitleColor(.white, for: .normal)
        buttonOkModalScreen.layer.cornerRadius = 15
        buttonOkModalScreen.backgroundColor = .systemBlue
        buttonOkModalScreen.translatesAutoresizingMaskIntoConstraints = false
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
        containerView.heightAnchor.constraint(
            equalToConstant: 300
        ).isActive = true
        
        titleLabel.centerXAnchor.constraint(
            equalTo: containerView.centerXAnchor
        ).isActive = true
        titleLabel.topAnchor.constraint(
            equalTo: containerView.topAnchor,
            constant: 15
        ).isActive = true
        
        descriptionForIcons.topAnchor.constraint(
            equalTo: titleLabel.bottomAnchor,
            constant: 20
        ).isActive = true
        descriptionForIcons.leadingAnchor.constraint(
            equalTo: containerView.leadingAnchor,
            constant: 16
        ).isActive = true
        descriptionForIcons.trailingAnchor.constraint(
            equalTo: containerView.trailingAnchor,
            constant: -16
        ).isActive = true
        
        iconsButtonsStackView.topAnchor.constraint(
            equalTo: descriptionForIcons.bottomAnchor,
            constant: 5
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
        
        descriptionForTextField.topAnchor.constraint(
            equalTo: iconsButtonsStackView.bottomAnchor,
            constant: 20
        ).isActive = true
        descriptionForTextField.leadingAnchor.constraint(
            equalTo: containerView.leadingAnchor,
            constant: 16
        ).isActive = true
        descriptionForTextField.trailingAnchor.constraint(
            equalTo: containerView.trailingAnchor,
            constant: -16
        ).isActive = true
        
        nameOfRoomTextField.centerXAnchor.constraint(
            equalTo: containerView.centerXAnchor
        ).isActive = true
        nameOfRoomTextField.topAnchor.constraint(
            equalTo: descriptionForTextField.bottomAnchor,
            constant: 5
        ).isActive = true
        nameOfRoomTextField.leadingAnchor.constraint(
            equalTo: containerView.leadingAnchor,
            constant: 16
        ).isActive = true
        nameOfRoomTextField.trailingAnchor.constraint(
            equalTo: containerView.trailingAnchor,
            constant: -16
        ).isActive = true
        
        buttonOkModalScreen.centerXAnchor.constraint(
            equalTo: containerView.centerXAnchor
        ).isActive = true
        buttonOkModalScreen.topAnchor.constraint(
            equalTo: nameOfRoomTextField.bottomAnchor,
            constant: 20
        ).isActive = true
        buttonOkModalScreen.widthAnchor.constraint(
            equalToConstant: 100
        ).isActive = true
        buttonOkModalScreen.heightAnchor.constraint(
            equalToConstant: 45
        ).isActive = true
        
        closeButton.topAnchor.constraint(
            equalTo: containerView.topAnchor,
            constant: 15
        ).isActive = true
        closeButton.trailingAnchor.constraint(
            equalTo: containerView.trailingAnchor,
            constant: -15
        ).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        okPressed()
        return true
    }
    
    private func makeIconButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 28)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemGray6
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return button
    }
    
    private lazy var iconsButtonsStackView: UIStackView = {
        let kitchen = makeIconButton(title: "🍽️")
        let bathroom = makeIconButton(title: "🚿")
        let bed = makeIconButton(title: "🛏️")
        let wardrobe = makeIconButton(title: "👕")
        
        let stack = UIStackView(arrangedSubviews: [
            kitchen, bathroom, bed, wardrobe
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
    
    @objc
    private func iconTapped(_ sender: UIButton) {
        for button in iconsButtonsStackView.arrangedSubviews.compactMap({
            $0 as? UIButton
        }) {
            button.backgroundColor = .systemGray6
        }
        sender.backgroundColor = .lightGray
        selectedIcon = sender.currentTitle
    }
    
    @objc
    private func closePressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func okPressed() {
        let roomName = nameOfRoomTextField.text ?? ""
        let roomIcon = selectedIcon ?? ""
        delegate?.modalScreenViewController(
            self,
            didEnterName: roomName,
            icon: roomIcon
        )
        print("Введено: \(roomName), Выбрана иконка: \(roomIcon)")
        dismiss(animated: true, completion: nil)
    }
}
