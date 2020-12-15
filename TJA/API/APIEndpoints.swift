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
    case google(token: String)
    case refresh
    //update user data
}

enum TripEndpoint {
    case tripList
    case newTrip(trip: TripRequest)
    case updateTrip(trip: TripRequest)
    case trip(id: Int)
    case deleteTrip(id: Int)
    case magic(trip: TripRequest)
}

enum ActivityEndpoint {
    case newActivity(activity: NewActivityRequest, tripId: Int, dayId: Int)
    case updateActivity(activity: ExistingActivityRequest, tripId: Int, dayId: Int)
    case deleteActivity(activity: ExistingActivityRequest, tripId: Int, dayId: Int)
}

enum SearchEndpoint {
    case city(query: String) // destination point
    case suggestion(category: String, destination: String) // wish item
    case eventPlace(query: String, category: String, destination: String) // activity event
    case accommodation(query: String, destination: String) // accommodation place
    case transferPoint(query: String, category: String, destination: String) // transfer place
}


extension AuthEndpoint: RequestBuilder {
    
    var base: String {
        APIConstants.baseUrl
    }
    
    var path: String {
        switch self {
        case .login: return "/auth/login"
        case .signup: return "/auth/registration"
        case .refresh: return "/api/user"
        case .google: return "/auth/oauth"
        }
    }
    
    var method: String {
        switch self {
        case .login, .signup, .google:
            return "POST"
        case .refresh:
            return "GET"
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login, .signup, .google: return appJsonHeaders
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
        case let .google(token):
            let request = OAuthRequest(googleOAuthToken: token)
            return try? JSONEncoder().encode(request)
        default:
            return nil
        }
    }
}

extension TripEndpoint: RequestBuilder {
    
    var base: String {
        APIConstants.baseUrl
    }
    
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
            return try? JSONEncoder(.millisecondsSince1970).encode(trip)
        default:
            return nil
        }
    }
}

extension ActivityEndpoint: RequestBuilder {
    var base: String {
        APIConstants.baseUrl
    }
    
    var path: String {
        switch self {
        case let .newActivity(_, tripId, dayId):
            return "/api/activities/\(tripId)/\(dayId)"
        case let .updateActivity(_, tripId, dayId):
            return "/api/activities/\(tripId)/\(dayId)"
        case let .deleteActivity(_, tripId, dayId):
            return "/api/activities/\(tripId)/\(dayId)"
        }
    }
    
    var method: String {
        switch self {
        case .newActivity: return "POST"
        case .updateActivity: return "PUT"
        case .deleteActivity: return "DELETE"
        }
    }
    
    var headers: [String : String]? {
        appJsonHeaders
    }
    
    var authorizeRequest: Bool {
        true
    }
    
    func body() -> Data? {
        switch self {
        case let .newActivity(request, _, _):
            if request.activityType == "transfer",
               let req = request as? ActivityRequest.New.Transfer {
                return try? JSONEncoder(.millisecondsSince1970).encode(req)
            } else if request.activityType == "accommodation",
                      let req = request as? ActivityRequest.New.Accommodation {
                return try? JSONEncoder(.millisecondsSince1970).encode(req)
            } else if let req = request as? ActivityRequest.New.Event {
                return try? JSONEncoder(.millisecondsSince1970).encode(req)
            }
        case let .updateActivity(request, _, _), let .deleteActivity(request, _, _):
            if request.activityType == "transfer",
               let req = request as? ActivityRequest.Existing.Transfer {
                return try? JSONEncoder(.millisecondsSince1970).encode(req)
            } else if request.activityType == "accommodation",
                      let req = request as? ActivityRequest.Existing.Accommodation {
                return try? JSONEncoder(.millisecondsSince1970).encode(req)
            } else if let req = request as? ActivityRequest.Existing.Event {
                return try? JSONEncoder(.millisecondsSince1970).encode(req)
            }
        }
        return nil
    }
    
    
    
}

extension SearchEndpoint: RequestBuilder {
    
    var base: String {
        APIConstants.baseSearchUrl
    }
    
    var path: String {
        switch self {
        case let .city(query):
            return "/city?name=\(query.encodeUrl())"
        case let .suggestion(category, destination):
            return "/place?category=\(category)&city=\(destination.lowercased())"
        case let .eventPlace(query, category, destination):
            return ""
        case let .accommodation(query, destination):
            return ""
        case let .transferPoint(query, category, destination):
            return ""
        }
    }
    
    var method: String {
        "GET"
    }
    
    var headers: [String : String]? {
        nil
    }
    
    var authorizeRequest: Bool {
        false
    }
    
    func body() -> Data? {
        nil
    }
}
