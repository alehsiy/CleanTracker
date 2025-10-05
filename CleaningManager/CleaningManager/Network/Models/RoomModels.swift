//
//  Room.swift
//  CleaningManager
//
//  Created by Boyarkina Anastasiya on 25.08.2025.
//
import Foundation

struct RoomResponse: Codable {
    let rooms: [Room]
}

struct Room: Codable, Identifiable {
    let id: String
    let name: String
    let icon: String
    let completedZones: Int
    let totalZones: Int
    let createdAt: Date
    let deletedAt: Date?
    let updatedAt: Date

    var progress: Float {
        return Float(completedZones) / Float(totalZones)
    }

    var progressText: String {
        if completedZones == 0 , totalZones == 0 {
            return "Nothing to do yet!"
        } else {
            return "\(completedZones)/\(totalZones) tasks done"
        }
    }

    var statusText: String? {
        return needsAttention ? " needs attention " : nil
    }

    var needsAttention: Bool {
        return progress < 1.0
    }

    enum CodingKeys: String, CodingKey {
        case id, name, icon
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case totalZones = "zones_total"
        case completedZones = "zones_cleaned_count"
    }
}
