//
//  Keyboard.swift
//  TJA
//
//  Created by Miron Rogovets on 30.10.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI


final class KeyboardResponder: ObservableObject {
    
    private var notificationCenter: NotificationCenter
    @Published private(set) var currentHeight: CGFloat = 0

    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(
            self, selector: #selector(keyBoardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(
            self, selector: #selector(keyBoardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        )?.cgRectValue {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.currentHeight = keyboardSize.height
            }
            
        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        withAnimation(.easeInOut(duration: 0.5)) {
            self.currentHeight = 0
        }
    }
}


#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
        )
    }
    
    func resignKeyboardOnDragGesture() -> some View {
        return gesture(DragGesture().onChanged { _ in
            print("DEBUG: -- Drag Gesture -- Hide keyboard")
            self.hideKeyboard()
        })
    }
}
#endif
