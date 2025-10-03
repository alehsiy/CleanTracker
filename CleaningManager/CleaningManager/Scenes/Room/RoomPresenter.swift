//
//  RoomPresenter.swift
//  CleaningManager
//
//  Created by Кирилл Привалов on 11.09.2025.
//

import Alamofire
import Foundation

final class RoomPresenter {
    func getZoneInfo() async throws -> Data? {
        var data = try await NetworkManager.shared.authenticatedRequest(
            url: URLBuilder.shared.create(for: .zones(.byid(id: "19ff716d-02e6-4824-8709-85d94a54835b"))),
            method: .get
        )
        
        return data
    }
}
