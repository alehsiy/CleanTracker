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

        var path: String {
            switch self {
            case .rooms(path: let path): "rooms\(path.path)"
            case .zones(path: let path): "zones/\(path.path)"
            case .stats(path: let path): "rooms"
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
            case .restore(id: let id): "/\(id)/restore"
            case .allRooms: ""
            case .byId(id: let id): "/\(id)"
            case .roomZones(id: let id): "/\(id)/zones"
            }
        }
    }

    enum Zones {
        case bulkClean
        case byid(id: String)
        case clean(id: String)
        case due

        var path: String {
            switch self {
            case .bulkClean: "bulk-clean"
            case .byid(id: let id): "\(id)"
            case .clean(id: let id): "\(id)/clean"
            case .due: "due"
            }
        }
    }

    enum Stats {
        case overview
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
