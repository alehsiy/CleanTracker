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

    func request(
        url: URL,
        method: HTTPMethod
    ) async throws -> Data? {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: method).responseData { response in
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
            .accept("application/json")
        ]
//        return AF.request(request).resume().data
        return try await withCheckedThrowingContinuation { continuation in
            guard let request = ?URLConvertible else {
                fatalError()
            }
            AF.request(request as! URLConvertible, headers: headers).responseData { response in
                switch(response.result) {
                case let .success(data):
                    continuation.resume(returning: data)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func parseJSON<T: Decodable>(with model: T.Type, data: Data) throws -> T? {
        return try decoder.decode(model.self, from: data)
    }
}
