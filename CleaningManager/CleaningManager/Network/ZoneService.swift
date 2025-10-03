//
//  ZoneService.swift
//  CleaningManager
//
//  Created by Кирилл Привалов on 30.09.2025.
//

import Foundation

enum ZoneServiceError: Error {
    case networkError(Error)
    case decodingError
    case unknown
}

actor ZoneService {
    static let shared = ZoneService()

    private init() {}

    func deleteZone(id: String) async throws {
        let url = URLBuilder.shared.create(for: .zones(.byid(id: id)))

        do {
            try await NetworkManager.shared.authenticatedRequest(url: url, method: .delete)
        } catch {
            throw ZoneServiceError.networkError(error)
        }
    }

    func cleanZone(id: String) async throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // Set timezone to UTC
        let currentDate = dateFormatter.string(from: Date())

        let url = URLBuilder.shared.create(for: .zones(.clean(id: id)))
        
        do {
            try await NetworkManager.shared.authenticatedRequest(url: url, method: .post, body: CleanZone(cleanedAt: currentDate))
        } catch {
            throw ZoneServiceError.networkError(error)
        }
    }
}
