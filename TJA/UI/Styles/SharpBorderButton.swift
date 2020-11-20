//
//  SharpBorderButton.swift
//  TJA
//
//  Created by Miron Rogovets on 20.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct SharpBorderButtonStyle: ButtonStyle {
    var filled: Bool = false
    var color: Color = Color("MainRed")
    
    public func makeBody(configuration: SharpBorderButtonStyle.Configuration) -> some View {
        
        configuration.label
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(filled ? .white : color)
            .padding(.horizontal, 4)
            .padding(.vertical, 6)
            .frame(minWidth: 40, maxWidth: .infinity, alignment: .center)
            .background(Rectangle().fill(filled ? color : Color(UIColor.systemBackground)))
            .overlay(Rectangle().stroke(color, lineWidth: 2))
            .compositingGroup()
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
        
    }
}

struct SharpBorderButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Button(action: {}) {
                Text("All")
            }.buttonStyle(SharpBorderButtonStyle())
            Button(action: {}) {
                Text("Day 33")
            }.buttonStyle(SharpBorderButtonStyle(filled: true))
        }
    }
}
