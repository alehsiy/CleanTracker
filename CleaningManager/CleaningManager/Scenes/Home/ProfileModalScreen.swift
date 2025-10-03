//
//  ProfileModalScreen.swift
//  CleaningManager
//
//  Created by Boyarkina Anastasiya on 03.10.2025.
//
import UIKit

protocol ProfileModalScreenDelegate: AnyObject {
    func ProfileModalScreen(
        _ controller: ProfileModalScreen,
        name: String,
        email: String
    )
}

final class ProfileModalScreen: UIViewController {

    weak var delegate: ProfileModalScreenDelegate?

    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let logoutButton = UIButton()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    var onSuccess: (() -> Void)?
    private let authService = AuthService.shared
    private var isLoading = false {
        didSet {
            logoutButton.isEnabled = !isLoading
            if isLoading {
                activityIndicator.startAnimating()
                logoutButton.setTitle("", for: .normal)
            } else {
                activityIndicator.stopAnimating()
                logoutButton.setTitle("Logout", for: .normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)

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
        titleLabel.text = "Profile"
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

        containerView.addSubview(logoutButton)
        logoutButton.addTarget(
            self,
            action: #selector(logoutPressed),
            for: .touchUpInside
        )
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.backgroundColor = .systemBlue
        logoutButton.layer.cornerRadius = 16
        logoutButton.translatesAutoresizingMaskIntoConstraints = false

        logoutButton.addSubview(activityIndicator)
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

        logoutButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
        logoutButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
        logoutButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
        logoutButton.heightAnchor.constraint(equalToConstant: 40),
        logoutButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),

        activityIndicator.centerXAnchor.constraint(equalTo: logoutButton.centerXAnchor),
        activityIndicator.centerYAnchor.constraint(equalTo: logoutButton.centerYAnchor)
        ])
    }

    // MARK: - Actions
    @objc
    private func closePressed() {
        dismiss(animated: true)
    }

    @objc
    private func logoutPressed() {
        guard !isLoading else { return }

        isLoading = true

        Task {
            do {
                _ = try await AuthService.shared.logout()

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

    // MARK: - Helpers
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
