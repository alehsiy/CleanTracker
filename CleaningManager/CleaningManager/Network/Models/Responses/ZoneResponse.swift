//
//  ZoneResponse.swift
//  CleaningManager
//
//  Created by Кирилл Привалов on 11.09.2025.
//

import Alamofire

struct ZoneResponse: Decodable {
    let createdAt: String
    let customIntervalDays: Int
    let deletedAt: String?
    let frequency: String
    let icon: String
    let id: String
    let isDue: Bool
    let lastCleanedAt: String?
    let name: String
    let nextDueAt: String?
    let roomId: String
    let updatedAt: String
}
