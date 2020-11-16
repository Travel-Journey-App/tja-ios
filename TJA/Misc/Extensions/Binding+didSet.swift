//
//  Binding+didSet.swift
//  TJA
//
//  Created by Miron Rogovets on 16.11.2020.
//

import SwiftUI

extension Binding {
    func didSet(execute: @escaping (Value) -> Void) -> Binding {
        return Binding(
            get: {
                return self.wrappedValue
            },
            set: {
                self.wrappedValue = $0
                execute($0)
            }
        )
    }
}
