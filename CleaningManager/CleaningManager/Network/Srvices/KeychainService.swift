//
//  KeychainService.swift
//  CleaningManager
//
//  Created by Boyarkina Anastasiya on 29.09.2025.
//
import Foundation
import Security

actor KeychainService {
    static let shared = KeychainService()

    private let accessTokenKey = "com.cleaningmanager.auth.accessToken"
    private let refreshTokenKey = "com.cleaningmanager.auth.refreshToken"

    private init() {}

    // MARK: - Access Token
    func saveAccessToken(_ token: String) throws {
        try save(token, forKey: accessTokenKey)
    }

    func getAccessToken() -> String? {
        return get(forKey: accessTokenKey)
    }

    // MARK: - Refresh Token
    func saveRefreshToken(_ token: String) throws {
        try save(token, forKey: refreshTokenKey)
    }

    func getRefreshToken() -> String? {
        return get(forKey: refreshTokenKey)
    }

    // MARK: - Common Methods
    private func save(_ token: String, forKey key: String) throws {
        guard let data = token.data(using: .utf8) else {
            throw KeychainError.encodingError
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]

        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.saveError(status)
        }
    }

    private func get(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess, let data = item as? Data else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    // MARK: - Cleanup
    func deleteAllTokens() throws {
        try delete(forKey: accessTokenKey)
        try delete(forKey: refreshTokenKey)
    }

    private func delete(forKey key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.deleteError(status)
        }
    }
}

enum KeychainError: Error {
    case encodingError
    case saveError(OSStatus)
    case deleteError(OSStatus)
}
