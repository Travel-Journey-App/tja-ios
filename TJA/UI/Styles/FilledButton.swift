//
//  FilledButton.swift
//  TJA
//
//  Created by Miron Rogovets on 20.10.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI


struct FilledButtonStyle: ButtonStyle {
    var filled: Bool = true
    var color: Color = .mainRed
    
    var fontSize: CGFloat {
        UIScreen.main.bounds.size.width >= 375 ? 16 : 14
    }
    
    var paddingSize: CGFloat {
        UIScreen.main.bounds.size.width >= 375 ? 16 : 10
    }
    
    public func makeBody(configuration: FilledButtonStyle.Configuration) -> some View {
        
        configuration.label
            .font(.system(size: fontSize))
            .foregroundColor(filled ? .white : color)
            .padding(paddingSize)
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

struct FilledButton_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {}) {
            Text("Test")
        }.buttonStyle(FilledButtonStyle(filled: false))
    }
}
