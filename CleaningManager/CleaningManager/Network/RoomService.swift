//
//  RoomService.swift
//  CleaningManager
//
//  Created by Boyarkina Anastasiya on 16.09.2025.
//

import Foundation

enum RoomServiceError: Error {
    case networkError(Error)
    case decodingError
    case unknown
}

actor RoomService {
    static let shared = RoomService()

    private init() {}

    func fetchAllRooms() async throws -> [Room] {
        let url = URLBuilder.shared.create(for: .rooms(.allRooms))

        do {
            let data = try await NetworkManager.shared.request(url: url, method: .get)

            guard let data = data else {
                throw RoomServiceError.unknown
            }

            let rooms = try await NetworkManager.shared.parseJSON(with: [Room].self, data: data)
            return rooms ?? []
        } catch {
            throw RoomServiceError.networkError(error)
        }
    }

    func getRoomById(id: String) async throws -> Room {
        let url = URLBuilder.shared.create(for: .rooms(.byId(id: id)))

        do {
            let data = try await NetworkManager.shared.request(url: url, method: .get)

            guard let data = data else {
                throw RoomServiceError.unknown
            }

            let room = try await NetworkManager.shared.parseJSON(with: Room.self, data: data)
            guard let room = room else {
                throw RoomServiceError.decodingError
            }

            return room
        } catch {
            throw RoomServiceError.networkError(error)
        }
    }

    func createRoom(name: String, icon: String?) async throws -> Room {
        let url = URLBuilder.shared.create(for: .rooms(.allRooms))
        let newRoom = NewRoom(name: name, icon: icon)

        do {
            let data = try await NetworkManager.shared.request(
                url: url,
                method: .post,
                body: newRoom
            )

            guard let data = data else {
                throw RoomServiceError.unknown
            }

            let room = try await NetworkManager.shared.parseJSON(with: Room.self, data: data)
            guard let room = room else {
                throw RoomServiceError.decodingError
            }

            return room
        } catch {
            throw RoomServiceError.networkError(error)
        }
    }

    func updateRoom(id: String, name: String?, icon: String?) async throws -> Room {
        let url = URLBuilder.shared.create(for: .rooms(.byId(id: id)))
        let updatedRoom = UpdateRoom(name: name, icon: icon)

        do {
            let data = try await NetworkManager.shared.request(
                url: url,
                method: .patch
            )

            guard let data = data else {
                throw RoomServiceError.unknown
            }

            let room = try await NetworkManager.shared.parseJSON(with: Room.self, data: data)
            guard let room = room else {
                throw RoomServiceError.decodingError
            }

            return room
        } catch {
            throw RoomServiceError.networkError(error)
        }
    }

    func deleteRoom(id: String) async throws -> Void {
        let url = URLBuilder.shared.create(for: .rooms(.byId(id: id)))

        do {
            try await NetworkManager.shared.request(url: url, method: .delete)
        } catch {
            throw RoomServiceError.networkError(error)
        }
    }

    func getRoomZones(id: String) async throws -> [Zone] {
        let url = URLBuilder.shared.create(for: .rooms(.roomZones(id: id)))

        do {
            let data = try await NetworkManager.shared.request(url: url, method: .get)
            guard let data = data else {
                throw RoomServiceError.unknown
            }
            let zones = try await NetworkManager.shared.parseJSON(with: [Zone].self, data: data)
            guard let zones = zones else {
                throw RoomServiceError.decodingError
            }
            return zones
        } catch {
            throw RoomServiceError.networkError(error)
        }
    }

    func createZone(id: String) async throws -> NewZone {
        let url = URLBuilder.shared.create(for: .rooms(.roomZones(id: id)))

        do {
            let data = try await NetworkManager.shared.request(url: url, method: .get)
            guard let data = data else {
                throw RoomServiceError.unknown
            }
            let zone = try await NetworkManager.shared.parseJSON(with: NewZone.self, data: data)
            guard let zone = zone else {
                throw RoomServiceError.decodingError
            }
            return zone
        } catch {
            throw RoomServiceError.networkError(error)
        }
    }
}

struct NewRoom: Codable {
    let name: String
    let icon: String?
}

struct UpdateRoom: Codable {
    let name: String?
    let icon: String?
}
