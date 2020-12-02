//
//  BorderedTextField.swift
//  TJA
//
//  Created by Miron Rogovets on 20.10.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI


struct BorderedTextField: TextFieldStyle {
    var color: Color = Color("MainRed")
    var fontSize: CGFloat = 15
    var borderSize: CGFloat = 2
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.system(size: fontSize))
            .foregroundColor(color)
            .padding(15)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 32, maxHeight: 50)
            .background(
                RoundedRectangle(cornerRadius: 2)
                    .strokeBorder(color, lineWidth: borderSize)
            )
    }
}

struct BorderedTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TextField("Username", text: .constant(""))
                .textFieldStyle(BorderedTextField())
            SecureField("Pass", text: .constant(""))
                .textFieldStyle(BorderedTextField())
        }
    }
}
