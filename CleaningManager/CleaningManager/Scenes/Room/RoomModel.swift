//
//  RoomModel.swift
//  CleaningManager
//
//  Created by Кирилл Привалов on 03.09.2025.
//

import Foundation

let model = RoomModel(
    name: "Bathroom",
    emojiIcon: "🚿",
    items: [
        RoomItem(
            cleanlinessPercent: "0% clean",
            icon: .dishes,
            lastCleaningDate: Calendar.current.startOfDay(for: Date()),
            cleaningFrequency: .daily,
            state: .cleanRequired
        ),
        RoomItem(
            cleanlinessPercent: "50% clean",
            icon: .dishes,
            lastCleaningDate: Calendar.current.startOfDay(for: Date()),
            cleaningFrequency: .monthly,
            state: .cleanRequired
        ),
        RoomItem(
            cleanlinessPercent: "100% clean",
            icon: .dishes,
            lastCleaningDate: Calendar.current.startOfDay(for: Date()),
            cleaningFrequency: .daily,
            state: .cleanRequired
        )
    ],
    totalCleanlinessStatus: 21
)

struct RoomItem {
    let cleanlinessPercent: String
    let icon: RoomIcon
    let lastCleaningDate: Date
    let cleaningFrequency: CleaningFrequency
    let state: CleaningState
}

struct RoomModel {
    let name: String
    let emojiIcon: String
    let items: [RoomItem]
    let totalCleanlinessStatus: Int
}

enum CleaningFrequency {
    case daily
    case weekly
    case monthly
}

enum RoomIcon: String {
    case dishes = "🍽️"
}

enum CleaningState {
  case cleanRequired
  case inProgress
  case done
}
