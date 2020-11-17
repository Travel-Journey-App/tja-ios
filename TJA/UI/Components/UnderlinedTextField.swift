//
//  UnderlinedTextField.swift
//  TJA
//
//  Created by Miron Rogovets on 15.11.2020.
//

import SwiftUI

struct UnderlinedTextField: View {
    
    @Binding var text: String
    let placeholder: String
    
    var imageName: String? = nil
    var fontSize: CGFloat = 16
    
    var keyboard: UIKeyboardType = .default
    
    private var hasIcon: Bool {
        return imageName != nil
    }
    
    private var color: Color {
        return text.isEmpty ? Color(UIColor.systemGray) : Color("MainRed")
    }
    
    private var textField: some View {
        TextField(placeholder, text: $text)
            .font(.system(size: fontSize))
            .keyboardType(keyboard)
    }
    
    var body: some View {
        VStack {
            HStack {
                textField
                Image(systemName: imageName ?? "")
                    .foregroundColor(color)
            }
            //            Divider().background(color)
            // Undeline
            Rectangle().fill(color).frame(height: 1)
            
        }
    }
}

struct UnderlinedTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            UnderlinedTextField(text: .constant(""), placeholder: "placeholder 1")
            UnderlinedTextField(
                text: .constant("Aa"), placeholder: "placeholder 2", imageName: "calendar"
            )
        }.padding(20)
    }
}
