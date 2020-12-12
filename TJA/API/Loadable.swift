//
//  LoadingState.swift
//  TJA
//
//  Created by Miron Rogovets on 09.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation


//typealias LoadableItem<Value> = Binding<Loadable<Value>>

enum Loadable<Value> {
    
    case idle
    case loading
    case failed(Error)
    case loaded(Value)
    
    var value: Value? {
        switch self {
        case let .loaded(value): return value
        default: return nil
        }
    }
    var error: Error? {
        switch self {
        case let .failed(error): return error
        default: return nil
        }
    }
}

extension Loadable {
    
    func map<V>(_ transform: (Value) throws -> V) -> Loadable<V> {
        do {
            switch self {
            case .idle: return .idle
            case .loading: return .loading
            case let .failed(error): return .failed(error)
            case let .loaded(value): return .loaded(try transform(value))
            }
        } catch {
            return .failed(error)
        }
    }
}

protocol SomeOptional {
    associatedtype Wrapped
    func unwrap() throws -> Wrapped
}

struct ValueIsMissingError: Error {
    var localizedDescription: String {
        NSLocalizedString("Data is missing", comment: "")
    }
}

extension Optional: SomeOptional {
    func unwrap() throws -> Wrapped {
        switch self {
        case let .some(value): return value
        case .none: throw ValueIsMissingError()
        }
    }
}

extension Loadable where Value: SomeOptional {
    func unwrap() -> Loadable<Value.Wrapped> {
        map { try $0.unwrap() }
    }
}

extension Loadable: Equatable where Value: Equatable {
    
    static func == (lhs: Loadable<Value>, rhs: Loadable<Value>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.loading, .loading): return true
        case let (.loaded(lhsV), .loaded(rhsV)): return lhsV == rhsV
        case let (.failed(lhsE), .failed(rhsE)):
            return lhsE.localizedDescription == rhsE.localizedDescription
        default: return false
        }
    }
}
