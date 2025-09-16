//
//  ZoneModel.swift
//  CleaningManager
//
//  Created by Boyarkina Anastasiya on 10.09.2025.
//
import Foundation

//struct ZoneResponse: Codable {
//    let zones: [Zone]
//}

struct Zone: Codable, Identifiable {
    let id: String
    let roomId: String
    let name: String
    let icon: String
    let frequency: Frequency
    let customIntervalDays: Int?
    let createdAt: Date
    let updatedAt: Date
    let deletedAt: Date?
    let lastCleanedAt: Date?
    let isDue: Bool
    let nextDueAt: Date?

    enum CodingKeys: String, CodingKey {
        case id, name, icon, frequency
        case roomId = "room_id"
        case customIntervalDays = "custom_interval_days"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case lastCleanedAt = "last_cleaned_at"
        case isDue = "is_due"
        case nextDueAt = "next_due_at"
    }
}

enum Frequency: String, Codable {
    case daily = "daily"
    case weekly = "weekly"
    case monthly = "monthly"
    case custom = "custom"
}

struct NewZone: Codable {
    let name: String
    let icon: String?
    let frequency: Frequency
    let customIntervalDays: Int?
}

struct UpdateZone: Codable {
    let name: String?
    let icon: String?
    let frequency: Frequency?
    let customIntervalDays: Int?
}
