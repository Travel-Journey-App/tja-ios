//
//  AddButtonsStack.swift
//  TJA
//
//  Created by Miron Rogovets on 28.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct AddButtonsStack: View {
    
    @Binding var isExpanded: Bool
    @State var isHelpShown: Bool = false
    
    var calendarFlow: (() -> ())?
    var magicFlow: (() -> ())?
    var ideasFlow: (() -> ())?
    var manualFlow: (() -> ())?
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            
            if isExpanded {
                
                if UserDefaultsConfig.syncWithCalendar {
                    // Calendar
                    Button(action: {
                        print("DEBUG: -- Calendar flow tapped")
                        self.calendarFlow?()
                    }) {
                        Image(systemName: "calendar")
                            .frame(width: 24, height: 24, alignment: .center)
                    }
                    .buttonStyle(CircleButtonStyle(secondaryColor: Color(UIColor.systemYellow)))
                }
                
                // Magic
                Button(action: {
                    print("DEBUG: -- Magic flow tapped")
                    self.magicFlow?()
                }) {
                    Image(systemName: "wand.and.stars")
                        .frame(width: 24, height: 24, alignment: .center)
                }
                .buttonStyle(CircleButtonStyle(secondaryColor: Color(UIColor.systemYellow)))
                
                
                // Ideas
                Button(action: {
                    print("DEBUG: -- Ideas flow tapped")
                    self.ideasFlow?()
                }) {
                    Image(systemName: "lightbulb")
                        .frame(width: 24, height: 24, alignment: .center)
                }
                .buttonStyle(CircleButtonStyle(secondaryColor: Color(UIColor.systemYellow)))
                
                // Manual
                Button(action: {
                    print("DEBUG: -- Manual flow tapped")
                    self.manualFlow?()
                }) {
                    Image(systemName: "pencil")
                        .frame(width: 24, height: 24, alignment: .center)
                }
                .buttonStyle(CircleButtonStyle(secondaryColor: Color(UIColor.systemYellow)))
            }
            
            
            // Plus / cancel button
            Button(action: {
                self.isExpanded.toggle()
            }) {
                Image(systemName: isExpanded ? "xmark" : "plus")
                    .frame(width: 24, height: 24, alignment: .center)
            }
            .buttonStyle(CircleButtonStyle())
            
        }.animation(.spring())
    }
}

struct AddButtonsStack_Previews: PreviewProvider {
    static var previews: some View {
        AddButtonsStack(isExpanded: .constant(true))
    }
}
