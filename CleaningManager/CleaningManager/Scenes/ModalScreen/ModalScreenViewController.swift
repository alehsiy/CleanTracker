//
//  ModalScreenViewController.swift
//  CleaningManager
//
//  Created by Zvorygin Aleksey on 19.08.2025.
//

import UIKit

protocol ModalScreenViewControllerDelegate: AnyObject {
    func modalScreenViewController(_ controller: ModalScreenViewController, didEnterName name: String, icon: String)
}

final class ModalScreenViewController: UIViewController, UITextFieldDelegate {
    
    weak var delegate: ModalScreenViewControllerDelegate?
    var selectedIcon: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        
        nameTextField.delegate = self
        
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 15
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            containerView.heightAnchor.constraint(equalToConstant: 300)])
        
        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15)
        ])
        
        containerView.addSubview(descriptionForIcons)
        NSLayoutConstraint.activate([
            descriptionForIcons.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionForIcons.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            descriptionForIcons.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)])
        
        containerView.addSubview(iconsButtonsStackView)
        NSLayoutConstraint.activate([
            iconsButtonsStackView.topAnchor.constraint(equalTo: descriptionForIcons.bottomAnchor, constant: 5),
            iconsButtonsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconsButtonsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            iconsButtonsStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        containerView.addSubview(descriptionForTextField)
        NSLayoutConstraint.activate([
            descriptionForTextField.topAnchor.constraint(equalTo: iconsButtonsStackView.bottomAnchor, constant: 10),
            descriptionForTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            descriptionForTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)])
        
        containerView.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            nameTextField.topAnchor.constraint(equalTo: descriptionForTextField.bottomAnchor, constant: 5),
            nameTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
        
        containerView.addSubview(buttonOkModalScreen)
        buttonOkModalScreen.addTarget(self, action: #selector(okPressed), for: .touchUpInside)
        NSLayoutConstraint.activate([
            buttonOkModalScreen.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            buttonOkModalScreen.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            buttonOkModalScreen.widthAnchor.constraint(equalToConstant: 100),
            buttonOkModalScreen.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        containerView.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            closeButton.widthAnchor.constraint(equalToConstant: 15),
            closeButton.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        label.text = "Add room"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let closeButton: UIButton = {
       let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let descriptionForIcons: UILabel = {
       let descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textAlignment = .left
        descriptionLabel.text = "Select icon for room:"
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    private let descriptionForTextField: UILabel = {
       let descriptionText = UILabel()
        descriptionText.font = .systemFont(ofSize: 13)
        descriptionText.textAlignment = .left
        descriptionText.text = "Input room name:"
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        return descriptionText
    }()
    
    private let buttonOkModalScreen: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ok", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter room name"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
        
        let stack = UIStackView(arrangedSubviews: [kitchen, bathroom, bed, wardrobe])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.isLayoutMarginsRelativeArrangement = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        // обработка нажатий для всех кнопок
        for button in stack.arrangedSubviews.compactMap({ $0 as? UIButton }) {
            button.addTarget(self, action: #selector(iconTapped(_:)), for: .touchUpInside)
        }
        
        return stack
    }()
    
    @objc
    private func iconTapped(_ sender: UIButton) {
        for button in iconsButtonsStackView.arrangedSubviews.compactMap({ $0 as? UIButton }) {
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
        let roomName = nameTextField.text ?? ""
        let roomIcon = selectedIcon ?? ""
        delegate?.modalScreenViewController(self, didEnterName: roomName, icon: roomIcon)
        print("Введено: \(roomName), Выбрана иконка: \(roomIcon)")
        dismiss(animated: true, completion: nil)
    }
}
