//
//  LoginViewController.swift
//  CleaningManager
//
//  Created by Boyarkina Anastasiya on 29.09.2025.
//
import UIKit

protocol LoginModalScreenDelegate: AnyObject {
    func LoginModalScreen(
        _ controller: LoginModalScreen,
        email: String,
        password: String
    )
}

final class LoginModalScreen: UIViewController,  UITextFieldDelegate {

    weak var delegate: LoginModalScreenDelegate?

    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    var onSuccess: (() -> Void)?
    private let authService = AuthService.shared
    private var isLoading = false {
        didSet {
            loginButton.isEnabled = !isLoading
            if isLoading {
                activityIndicator.startAnimating()
                loginButton.setTitle("", for: .normal)
            } else {
                activityIndicator.stopAnimating()
                loginButton.setTitle("Login", for: .normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
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
        titleLabel.text = "Login"
        titleLabel.textColor = .systemBlue
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

        containerView.addSubview(emailTextField)
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(passwordTextField)
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(loginButton)
        loginButton.addTarget(
            self,
            action: #selector(loginPressed),
            for: .touchUpInside
        )
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 16
        loginButton.translatesAutoresizingMaskIntoConstraints = false

        loginButton.addSubview(activityIndicator)
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

        emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
        emailTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
        emailTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 6),
        passwordTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
        passwordTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
        loginButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
        loginButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
        loginButton.heightAnchor.constraint(equalToConstant: 40),
        loginButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),

        activityIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
        activityIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor)
        ])
    }

    // MARK: - Actions
    @objc
    private func closePressed() {
        dismiss(animated: true)
    }

    @objc
    private func loginPressed() {
        guard !isLoading else { return }

        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showError(message: "Please fill in all fields")
            return
        }

        guard isValidEmail(email) else {
            showError(message: "Please enter a valid email address")
            return
        }

        isLoading = true

        Task {
            do {
                _ = try await AuthService.shared.login(email: email, password: password)

                await MainActor.run {
                    self.isLoading = false
                    self.dismiss(animated: true) {
                        self.onSuccess?()
                    }
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.showError(message: error.localizedDescription)
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
