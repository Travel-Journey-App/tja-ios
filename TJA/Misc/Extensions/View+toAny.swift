//
//  View+toAny.swift
//  TJA
//
//  Created by Miron Rogovets on 19.11.2020.
//

import SwiftUI

extension View {
    func toAnyView() -> AnyView {
        AnyView(self)
    }
}
