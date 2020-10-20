//
//  ButtonStyles.swift
//  TJA
//
//  Created by Miron Rogovets on 20.10.2020.
//

import SwiftUI


struct FilledButtonStyle: ButtonStyle {
    var filled: Bool = true
    var color: Color = Color("MainRed")
    
    public func makeBody(configuration: FilledButtonStyle.Configuration) -> some View {
        
        configuration.label
            .font(.system(size: 16))
            .foregroundColor(filled ? .white : color)
            .padding(18)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 32, maxHeight: 50)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(filled ? color : .clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(color, lineWidth: 2)
            )
            .compositingGroup()
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct ButtonStyles_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {}) {
            Text("Test")
        }.buttonStyle(FilledButtonStyle(filled: false))
    }
}
