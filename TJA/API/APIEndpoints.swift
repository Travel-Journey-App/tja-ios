//
//  APIEndpoints.swift
//  TJA
//
//  Created by Miron Rogovets on 11.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation

enum AuthEndpoint {
    case login(email: String, password: String)
    case signup(email: String, password: String)
    case refresh
}

enum TripEndpoint {
    case tripList
    case newTrip(trip: TripRequest)
    case updateTrip(trip: TripRequest)
    case trip(id: Int)
    case deleteTrip(id: Int)
    case magic
}

enum EventEndpoint {
    
}

enum WishEndpoint {
    
}

extension AuthEndpoint: RequestBuilder {
    
    var path: String {
        switch self {
        case .login: return "/auth/login"
        case .signup: return "/auth/registration"
        case .refresh: return "/api/user"
        }
    }
    
    var method: String {
        switch self {
        case .login, .signup:
            return "POST"
        case .refresh:
            return "GET"
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login, .signup: return appJsonHeaders
        case .refresh: return nil
        }
    }
    
    var authorizeRequest: Bool {
        switch self {
        case .refresh: return true
        default: return false
        }
    }
    
    func body() -> Data? {
        switch self {
        case let .login(email, password):
            let request = LoginRequest(email: email, password: password)
            return try? JSONEncoder().encode(request)
        case let .signup(email, password):
            let request = SignUpRequest(email: email, password: password, matchingPassword: password)
            return try? JSONEncoder().encode(request)
        default:
            return nil
        }
    }
}

extension TripEndpoint: RequestBuilder {
    
    var path: String {
        switch self {
        case .tripList, .newTrip, .updateTrip: return "/api/trips"
        case let .trip(id), let .deleteTrip(id): return "/api/trips/\(id)"
        case .magic: return "/api/trips/magic"
        }
    }
    
    var method: String {
        switch self {
        case .tripList, .trip, .magic:
            return "GET"
        case .newTrip:
            return "POST"
        case .updateTrip:
            return "PUT"
        case .deleteTrip:
            return "DELETE"
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .newTrip, .updateTrip: return appJsonHeaders
        default: return nil
        }
    }
    
    var authorizeRequest: Bool {
        true
    }
    
    func body() -> Data? {
        switch self {
        case let .newTrip(trip), let .updateTrip(trip):
            return try? JSONEncoder().encode(trip)
        default:
            return nil
        }
    }
}
