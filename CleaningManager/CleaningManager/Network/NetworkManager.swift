//
//  NetworkManager.swift
//  CleaningManager
//
//  Created by Кирилл Привалов on 09.09.2025.
//

import Alamofire
import Foundation

actor NetworkManager {
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let keychainService = KeychainService.shared

    static let shared = NetworkManager(
        decoder: JSONDecoder(),
        encoder: JSONEncoder()
    )

    init(
        decoder: JSONDecoder,
        encoder: JSONEncoder
    ) {
        self.decoder = decoder
        self.encoder = encoder
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }

    @discardableResult
    func request(
        url: URL,
        method: HTTPMethod
    ) async throws -> Data? {
        var request = try URLRequest(url: url, method: method)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(request).responseData { response in
                switch(response.result) {
                case let .success(data):
                    continuation.resume(returning: data)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func request<T: Encodable>(
        url: URL,
        method: HTTPMethod,
        body: T? = nil
    ) async throws -> Data? {
        var request = try URLRequest(url: url, method: method)
        if let body {
            request.httpBody = try? encoder.encode(body)
        }
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                url,
                method: method,
                parameters: body,
                encoder: JSONParameterEncoder.default,
                headers: headers,
            ).responseData { response in
                switch(response.result) {
                case let .success(data):
                    continuation.resume(returning: data)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    // Для авторизованных запросов
    func authenticatedRequest(
        url: URL,
        method: HTTPMethod
    ) async throws -> Data? {
        return try await performAuthenticatedRequest(url: url, method: method)
    }

    func authenticatedRequest<T: Encodable>(
        url: URL,
        method: HTTPMethod,
        body: T? = nil
    ) async throws -> Data? {
        return try await performAuthenticatedRequest(url: url, method: method, body: body)
    }

    func parseJSON<T: Decodable>(with model: T.Type, data: Data) throws -> T? {
        return try decoder.decode(model.self, from: data)
    }

    private func performAuthenticatedRequest(
        url: URL,
        method: HTTPMethod,
        body: Encodable? = nil
    ) async throws -> Data? {
        guard let token = await keychainService.getAccessToken() else {
            throw NetworkError.unauthorized
        }
        var headers: HTTPHeaders = [
            .contentType("application/json"),
            .authorization(bearerToken: token)
        ]

        return try await withCheckedThrowingContinuation { continuation in
            if let body = body {
                AF.request(
                    url,
                    method: method,
                    parameters: body,
                    encoder: JSONParameterEncoder.default,
                    headers: headers
                ).responseData { response in
                    self.handleAuthenticatedResponse(
                        response: response,
                        url: url,
                        method: method,
                        body: body,
                        continuation: continuation
                    )
                }
            } else {
                AF.request(
                    url,
                    method: method,
                    headers: headers
                ).responseData { response in
                    self.handleAuthenticatedResponse(
                        response: response,
                        url: url,
                        method: method,
                        body: nil,
                        continuation: continuation
                    )
                }
            }
        }
    }

    private func handleAuthenticatedResponse(
        response: AFDataResponse<Data>,
        url: URL,
        method: HTTPMethod,
        body: Encodable?,
        continuation: CheckedContinuation<Data?, Error>
    ) {
        switch response.result {
        case let .success(data):
            continuation.resume(returning: data)

        case let .failure(error):
            let mappedError = self.mapError(error)

            if case NetworkError.unauthorized = mappedError {
                Task {
                    await self.handleUnauthorizedError(
                        url: url,
                        method: method,
                        body: body,
                        continuation: continuation
                    )
                }
            } else {
                continuation.resume(throwing: mappedError)
            }
        }
    }

    private func handleUnauthorizedError(
        url: URL,
        method: HTTPMethod,
        body: Encodable?,
        continuation: CheckedContinuation<Data?, Error>
    ) async {
        do {
            if let newToken = try await refreshToken() {
                if let body = body {
                    let result = try await performAuthenticatedRequest(
                        url: url,
                        method: method,
                        body: body
                    )
                    continuation.resume(returning: result)
                } else {
                    let result = try await performAuthenticatedRequest(
                        url: url,
                        method: method
                    )
                    continuation.resume(returning: result)
                }
            } else {
                continuation.resume(throwing: NetworkError.unauthorized)
            }
        } catch {
            continuation.resume(throwing: NetworkError.unauthorized)
        }
    }

    private func refreshToken() async throws -> String? {
        guard let refreshToken = await keychainService.getRefreshToken() else {
            return nil
        }
        do {
            let authResponse = try await AuthService.shared.refreshToken(refreshToken: refreshToken)
            return authResponse.access_token
        } catch {
            try? await keychainService.deleteAllTokens()
            return nil
        }
    }

    private func mapError(_ error: AFError) -> NetworkError {
        if let responseCode = error.responseCode {
            switch responseCode {
            case 401:
                return .unauthorized
            case 400...499:
                return .clientError(responseCode)
            case 500...599:
                return .serverError(responseCode)
            default:
                return .networkError(error)
            }
        } else {
            return .networkError(error)
        }
    }
}

// MARK: - Error Handling
enum NetworkError: Error {
    case unauthorized
    case clientError(Int)
    case serverError(Int)
    case networkError(Error)
    case decodingError
}

// MARK: - HTTPHeaders Extension
extension HTTPHeaders {
    static func authorization(bearerToken: String) -> HTTPHeader {
        return .authorization("Bearer \(bearerToken)")
    }
}
