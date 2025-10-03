//
//  AuthModels.swift
//  CleaningManager
//
//  Created by Boyarkina Anastasiya on 29.09.2025.
//
import Foundation

// MARK: - Request Models
struct LoginUser: Codable {
    let email: String
    let password: String
}

struct RegisterUser: Codable {
    let client_id: String?
    let email: String
    //let name: String?
    let password: String
    let username: String
}

struct RefreshTokenRequest: Codable {
    let refresh_token: String
}

// MARK: - Response Models
struct AuthResponse: Codable {
    let access_token: String
    let refresh_token: String
    let token_type: String
    let expires_in: Int64
    let user: UserView
}

struct UserView: Codable {
    let id: String
    let email: String
    let username: String
    let name: String?
    let email_verified: Bool
    let created_at: String
    let updated_at: String
}

// MARK: - Error Handling
struct AuthError: Error {
    let message: String
}

struct TokenErrorResponse: Codable {
    let error: String
    let error_description: String?
}

