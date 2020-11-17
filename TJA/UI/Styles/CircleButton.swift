//
//  CircleButton.swift
//  TJA
//
//  Created by Miron Rogovets on 17.11.2020.
//

import SwiftUI


struct CircleButtonStyle: ButtonStyle {
    var color: Color = Color("MainRed")
    var secondaryColor: Color? = nil
    
    var shouldChangeColor: Bool {
        return secondaryColor != nil
    }
    
    var secondaryOrDefaultColor: Color {
        if let secondary = secondaryColor {
            return secondary
        } else {
            return Color(UIColor.systemYellow)
        }
    }
    
    public func makeBody(configuration: CircleButtonStyle.Configuration) -> some View {
        
        configuration.label
            .foregroundColor(.white)
            .frame(width: 50, height: 50, alignment: .center)
            .background(
                shouldChangeColor ?
                configuration.isPressed ? secondaryOrDefaultColor : color
                : color
            )
            .clipShape(Circle())
            .shadow(radius: 4)
            .compositingGroup()
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {}) {
            Image(systemName: "xmark").frame(width: 24, height: 24, alignment: .center)
        }.buttonStyle(CircleButtonStyle(secondaryColor: Color(UIColor.systemYellow)))
    }
}
