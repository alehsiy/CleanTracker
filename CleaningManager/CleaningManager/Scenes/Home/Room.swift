//
//  Room.swift
//  CleaningManager
//
//  Created by Boyarkina Anastasiya on 25.08.2025.
//
import Foundation

struct Room {
    let id: UUID
    let name: String
    let icon: String
    let completedTasks: Int
    let totalTasks: Int
    let needsAttention: Bool

    var progress: Float {
        return totalTasks > 0 ? Float(completedTasks) / Float(totalTasks) : 0
    }

    var progressText: String {
        return "\(completedTasks)/\(totalTasks) tasks done"
    }

    var statusText: String? {
        return needsAttention ? " needs attention " : nil
    }
}
