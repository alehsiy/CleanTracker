//
//  Endpoints.swift
//  CleaningManager
//
//  Created by Кирилл Привалов on 12.09.2025.
//

import Foundation

final class URLBuilder {
    static let shared = URLBuilder()

    private init() {}

    enum Endpoint {
        case rooms(_ path: Rooms)
        case zones(_ path: Zones)
        case stats(_ path: Stats)
        case auth(_ path: Auth)

        var path: String {
            switch self {
            case .rooms(path: let path): "\(path.path)"
            case .zones(path: let path): "zones/\(path.path)"
            case .stats(path: let path): "rooms/"
            case .auth(path: let path): "\(path.path)"
            }
        }
    }

    enum Rooms {
        case restore(id: String)
        case allRooms
        case byId(id: String)
        case roomZones(id: String)

        var path: String {
            switch self {
            case .restore(id: let id): "rooms/\(id)/restore"
            case .allRooms: "rooms"
            case .byId(id: let id): "rooms/\(id)"
            case .roomZones(id: let id): "rooms/\(id)/zones"
            }
        }
    }

    enum Zones {
        case bulkClean
        case byid(id: String)
        case clean
        case due

        var path: String {
            switch self {
            case .bulkClean: "bulk-clean"
            case .byid(id: let id): "\(id)"
            case .clean: "clean"
            case .due: "due"
            }
        }
    }

    enum Stats {
        case overview
    }

    enum Auth {
        case login
        case register
        case refresh
        case me

        var path: String {
            switch self {
            case .login: "login"
            case .register: "register"
            case .refresh: "refresh"
            case .me: "me"
            }
        }
    }

    func create(for endpoint: Endpoint) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "localhost"
        urlComponents.port = 8080
        urlComponents.path = "/api/v1/\(endpoint.path)"
        return urlComponents.url!
    }
}
