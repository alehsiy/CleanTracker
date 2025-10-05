//
//  AuthViewController.swift
//  CleaningManager
//
//  Created by Boyarkina Anastasiya on 29.09.2025.
//
import UIKit

final class AuthViewController: UIViewController {

    private let containerView = UIView()
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let loginButton = UIButton()
    private let registerButton = UIButton()
    private let authService = AuthService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupUI()
        setupLayout()
    }

    // MARK: - Setup
    private func setupUI() {
        view.addSubview(containerView)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(logoImageView)
        logoImageView.image = UIImage(named: "father-daughter-cleaning-apartment-together")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(titleLabel)
        titleLabel.font = .boldSystemFont(ofSize: 32)
        titleLabel.textAlignment = .center
        titleLabel.text = "Clean Quest"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(subtitleLabel)
        subtitleLabel.font = .boldSystemFont(ofSize: 18)
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = "Manage your cleaning tasks"
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

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
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            containerView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),

            logoImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 300),
            logoImageView.heightAnchor.constraint(equalToConstant: 300),

            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -16),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            loginButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
            loginButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 50),

            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 12),
            registerButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            registerButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
            registerButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -32)
        ])
    }
    
    // MARK: - Actions
    @objc
    private func loginPressed() {
        showLoginModal()
    }

    @objc
    private func registerPressed() {
        showRegisterModal()
    }

    // MARK: - Navigation
    private func showLoginModal() {
        let loginVC = LoginModalScreen()
        loginVC.onSuccess = { [weak self] in
            self?.dismiss(animated: true)
        }
        present(loginVC, animated: true)
    }

    private func showRegisterModal() {
        let registerVC = RegisterModalScreen()
        registerVC.onSuccess = { [weak self] in
            self?.dismiss(animated: true)
        }
        present(registerVC, animated: true)
    }

    // MARK: - Helpers
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
