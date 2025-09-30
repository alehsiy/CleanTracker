//
//  NotificationService.swift
//  CleaningManager
//
//  Created by Zvorygin Aleksey on 23.09.2025.
//

import UIKit
import Foundation
import UserNotifications

@MainActor class NotificationService {
    static let shared = NotificationService()
    private let notificationCenter = UNUserNotificationCenter.current()
    private init () {}

    func checkForPermission() async -> Bool {
            let settings = await notificationCenter.notificationSettings()
            
            switch settings.authorizationStatus {
            case .authorized:
                return true
            case .notDetermined:
                do {
                    let granted = try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
                    if granted {
                        print("Пользователь предоставил разрешение.")
                        return true
                    } else {
                        print("Пользователь отклонил запрос на разрешение.")
                        return false
                    }
                } catch {
                    print("Ошибка при запросе разрешения: \(error.localizedDescription)")
                    return false
                }
            case .denied:
                return false
            case .provisional:
                return await checkForPermission()
            case .ephemeral:
                return false
            @unknown default:
                return false
            }
        }

    func dispatchNotification(
        identifier: String = "clining-notification",
        title: String,
        body: String,
        dateComponents: DateComponents,
        repeats: Bool
    ) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request)
    }

    func cancelAll() {
        UNUserNotificationCenter.current()
            .removeAllPendingNotificationRequests()
    }

    func getPending(completion: @escaping ([UNNotificationRequest]) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests {
            requests in
            DispatchQueue.main.async { completion(requests) }
        }
    }
}
