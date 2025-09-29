//
//  RoomModel.swift
//  CleaningManager
//
//  Created by Кирилл Привалов on 03.09.2025.
//

import Foundation

//final class RoomModel {
//    var name: String
//    var icon: String
//
//    var items: [RoomItem]
//
//    struct RoomItem {
//        let name: String
//        let icon: String
//    }
//}

let model = RoomModel(
    name: "Bathroom",
    emojiIcon: "🚿",
    items: [
        RoomItem(
            title: "Mirror",
            cleanlinessPercent: "0%",
            icon: "🪞",
            lastCleaningDate: "Aug 9",
            cleanCount: "0 cleans", cleaningFrequency: .daily,
            state: .cleanRequired,
            nextDate: "Aug 15"
        ),
        RoomItem(
            title: "Toilet", cleanlinessPercent: "50%",
            icon: "🚽",
            lastCleaningDate: "Aug 12",
            cleanCount: "1 clean", cleaningFrequency: .monthly,
            state: .inProgress,
            nextDate: "Aug 15"
        ),
        RoomItem(
            title: "Shower", cleanlinessPercent: "100%",
            icon: "🛁",
            lastCleaningDate: "Aug 15",
            cleanCount: "2 cleans", cleaningFrequency: .daily,
            state: .done,
            nextDate: "Aug 15"
        )
    ],
    totalCleanlinessStatus: 21
)

struct RoomItem {
    let title: String
    let cleanlinessPercent: String
    let icon: String
    let lastCleaningDate: String
    let cleanCount: String
    let cleaningFrequency: CleaningFrequency
    let state: CleaningState
    let nextDate: String
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

    var title: String {
        switch self {
        case .daily:
            return "Daily"
        case .weekly:
            return "Weekly"
        case .monthly:
            return "Monthly"
        }
    }
}

enum CleaningState {
    case cleanRequired
    case inProgress
    case done

    var title: String {
        switch self {
        case .cleanRequired:
            return "Clean Required"
        case .inProgress:
            return "In Progress"
        case .done:
            return "Done"
        }
    }
}
