//
//  AuthServices.swift
//  CleaningManager
//
//  Created by Boyarkina Anastasiya on 29.09.2025.
//
import Foundation
import Alamofire

enum AuthServiceError: Error {
    case networkError(Error)
    case decodingError
    case invalidCredentials
    case unknown
}

actor AuthService {
    static let shared = AuthService()

    private let keychainService = KeychainService.shared

    private init() {}

    // MARK: - Login
    func login(email: String, password: String) async throws -> AuthResponse {
        let url = URLBuilder.shared.create(for: .auth(.login))
        let loginRequest = LoginUser(email: email, password: password)

        do {
            let data = try await NetworkManager.shared.request(
                url: url,
                method: .post,
                body: loginRequest
            )

            guard let data = data else {
                throw AuthServiceError.unknown
            }

            let authResponse = try await NetworkManager.shared.parseJSON(with: AuthResponse.self, data: data)
            guard let authResponse = authResponse else {
                throw AuthServiceError.decodingError
            }

            try await keychainService.saveToken(authResponse.access_token)

            return authResponse
        } catch let error as AFError {
            if let statusCode = error.responseCode, statusCode == 401 {
                throw AuthServiceError.invalidCredentials
            }
            throw AuthServiceError.networkError(error)
        } catch {
            throw AuthServiceError.networkError(error)
        }
    }

    // MARK: - Register
    func register(name: String, email: String, password: String) async throws -> AuthResponse {
        let url = URLBuilder.shared.create(for: .auth(.register))
        let clientId = "ios"
        let registerRequest = RegisterUser(client_id: clientId, email: email, password: password, username: name)

        do {
            let data = try await NetworkManager.shared.request(
                url: url,
                method: .post,
                body: registerRequest
            )

            guard let data = data else {
                throw AuthServiceError.unknown
            }

            let authResponse = try await NetworkManager.shared.parseJSON(with: AuthResponse.self, data: data)
            guard let authResponse = authResponse else {
                throw AuthServiceError.decodingError
            }

            try await keychainService.saveToken(authResponse.access_token)

            return authResponse
        } catch let error as AFError {
            if let statusCode = error.responseCode, statusCode == 400 {
                throw AuthServiceError.invalidCredentials
            }
            throw AuthServiceError.networkError(error)
        } catch {
            throw AuthServiceError.networkError(error)
        }
    }

    // MARK: - Refresh Token
    func refreshToken(refreshToken: String) async throws -> AuthResponse {
        let url = URLBuilder.shared.create(for: .auth(.refresh))
        let refreshToken = RefreshTokenRequest(refresh_token: refreshToken)

        do {
            let data = try await NetworkManager.shared.request(
                url: url,
                method: .post,
                body: refreshToken
            )

            guard let data = data else {
                throw AuthServiceError.unknown
            }

            let authResponse = try await NetworkManager.shared.parseJSON(with: AuthResponse.self, data: data)
            guard let authResponse = authResponse else {
                throw AuthServiceError.decodingError
            }

            try await keychainService.saveToken(authResponse.access_token)

            return authResponse
        } catch let error as AFError {
            if let statusCode = error.responseCode, statusCode == 400 {
                throw AuthServiceError.invalidCredentials
            }
            throw AuthServiceError.networkError(error)
        } catch {
            throw AuthServiceError.networkError(error)
        }
    }

    // MARK: - Check Authentication
    func isAuthenticated() async -> Bool {
        return await keychainService.getToken() != nil
    }

    func getCurrentToken() async -> String? {
        return await keychainService.getToken()
    }
}
