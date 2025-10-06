//
//  RegisterModalScreen.swift
//  CleaningManager
//
//  Created by Boyarkina Anastasiya on 01.10.2025.
//
import UIKit

protocol RegisterModalScreenDelegate: AnyObject {
    func RegisterModalScreen(
        _ controller: RegisterModalScreen,
        name: String?,
        email: String,
        password: String,
        confirmPassword: String
    )
}

final class RegisterModalScreen: UIViewController,  UITextFieldDelegate {

    weak var delegate: RegisterModalScreenDelegate?

    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    private let nameTextField = UITextField()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let confirmPasswordTextField = UITextField()
    private let registerButton = UIButton()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    var onSuccess: (() -> Void)?
    private let authService = AuthService.shared
    private var isLoading = false {
        didSet {
            registerButton.isEnabled = !isLoading
            if isLoading {
                activityIndicator.startAnimating()
                registerButton.setTitle("", for: .normal)
            } else {
                activityIndicator.stopAnimating()
                registerButton.setTitle("Register", for: .normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        nameTextField.delegate = self

        setupUI()
        setupLayout()
    }

    // MARK: - Setup
    private func setupUI() {
        view.addSubview(containerView)
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(titleLabel)
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        titleLabel.text = "Register"
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

        containerView.addSubview(nameTextField)
        nameTextField.placeholder = "Name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.autocapitalizationType = .words
        nameTextField.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(emailTextField)
        emailTextField.placeholder = "Email*"
        emailTextField.borderStyle = .roundedRect
        emailTextField.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(passwordTextField)
        passwordTextField.placeholder = "Password*"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(confirmPasswordTextField)
        confirmPasswordTextField.placeholder = "Confirm Password*"
        confirmPasswordTextField.borderStyle = .roundedRect
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(registerButton)
        registerButton.addTarget(
            self,
            action: #selector(registerPressed),
            for: .touchUpInside
        )
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.backgroundColor = .systemBlue
        registerButton.layer.cornerRadius = 16
        registerButton.translatesAutoresizingMaskIntoConstraints = false

        registerButton.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        containerView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
        containerView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),

        titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),

        closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
        closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
        closeButton.widthAnchor.constraint(equalToConstant: 16),
        closeButton.heightAnchor.constraint(equalToConstant: 16),

        nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
        nameTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
        nameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 6),
        emailTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
        emailTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 6),
        passwordTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
        passwordTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

        confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 6),
        confirmPasswordTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
        confirmPasswordTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

        registerButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 16),
        registerButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
        registerButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
        registerButton.heightAnchor.constraint(equalToConstant: 40),
        registerButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),

        activityIndicator.centerXAnchor.constraint(equalTo: registerButton.centerXAnchor),
        activityIndicator.centerYAnchor.constraint(equalTo: registerButton.centerYAnchor)
        ])
    }

    // MARK: - Actions
    @objc private func closePressed() {
        dismiss(animated: true)
    }

    @objc private func registerPressed() {
        guard !isLoading else { return }

        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showError(message: "Please fill in all required fields")
            return
        }

        guard isValidEmail(email) else {
            showError(message: "Please enter a valid email address")
            return
        }

        guard password == confirmPassword else {
            showError(message: "Passwords do not match")
            return
        }

        guard password.count >= 8 else {
            showError(message: "Password must be at least 8 characters long")
            return
        }

        isLoading = true

        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let username = name?.isEmpty == false ? name! : email

        AuthService.shared.register(username: username, email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false

                switch result {
                case .success:
                    self?.dismiss(animated: true) {
                        self?.onSuccess?()
                    }
                case .failure(let error):
                    self?.showError(message: error.localizedDescription)
                }
            }
        }
    }

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Helpers
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
