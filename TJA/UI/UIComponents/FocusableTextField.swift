//
//  FocusableTextField.swift
//  TJA
//
//  Created by Miron Rogovets on 17.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct FocusableTextField: UIViewRepresentable {

    class Coordinator: NSObject, UITextFieldDelegate {

        @Binding var text: String
        let placeholder: String
        var didBecomeFirstResponder = false
        var onEditingChanged: ((Bool) -> ())?
        var onCommit: (() -> ())?

        init(
            text: Binding<String>,
            placeholder: String,
            onEditingChanged: ((Bool) -> ())? = nil,
            onCommit: (() -> ())? = nil) {
            
            self._text = text
            self.placeholder = placeholder
            self.onEditingChanged = onEditingChanged
            self.onCommit = onCommit
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            print("DEBUG: -- textFieldDidEndEditing")
            self.onEditingChanged?(false)
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            print("DEBUG: -- textFieldDidBeginEditing")
            self.onEditingChanged?(true)
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            print("DEBUG: -- textFieldShouldReturn")
            onCommit?()
            return true
        }

    }

    @Binding var text: String
    let placeholder: String
    var isFirstResponder: Bool = false
    var onEditingChanged: ((Bool) -> ())?
    var onCommit: (() -> ())?
    

    func makeUIView(context: UIViewRepresentableContext<FocusableTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.font = .systemFont(ofSize: 18, weight: .semibold)
        textField.delegate = context.coordinator
        return textField
    }

    func makeCoordinator() -> FocusableTextField.Coordinator {
        return Coordinator(
            text: $text,
            placeholder: placeholder,
            onEditingChanged: onEditingChanged,
            onCommit: onCommit)
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<FocusableTextField>) {
        uiView.text = text
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
}

struct FocusableTextField_Previews: PreviewProvider {
    static var previews: some View {
        FocusableTextField(text: .constant(""), placeholder: "Test", isFirstResponder: true)
    }
}
