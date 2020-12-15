//
//  PopUpContainer.swift
//  TJA
//
//  Created by Miron Rogovets on 30.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct PopUpContainer<Content: View>: View {
    
    @Binding var isBlurShown: Bool
    
    private let content: () -> Content
    private let onDismiss: (() -> ())?
    
    init(isShown: Binding<Bool>, onDismiss: (() -> ())? = nil, @ViewBuilder content:@escaping () -> Content) {
        self._isBlurShown = isShown
        self.content = content
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            BlurView().onTapGesture {
                self.isBlurShown = false
                self.onDismiss?()
            }
            self.content()
        }
    }
}

struct PopUpContainer_Previews: PreviewProvider {
    static var previews: some View {
        PopUpContainer(isShown: .constant(true)) {
            Text("Ok")
            .padding(.horizontal, 30)
        }.background(Color.red)
    }
}
