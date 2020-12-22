//
//  DraggableSplash.swift
//  TJA
//
//  Created by Miron Rogovets on 03.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct DraggableSplash: View {
    
    var title: String = "(Place it where it's planned to be)"
    
    var body: some View {
        RoundedRectangle(cornerRadius: 7, style: .continuous)
            .fill(Color.splash)
            .overlay(
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .strokeBorder(Color(UIColor.opaqueSeparator), lineWidth: 1))
            .overlay(
                Text(title)
                    .font(.system(size: 16))
                    .italic()
                    .foregroundColor(.white)
            )
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(height: 40)
            .padding(.horizontal, 25)
            .padding(.vertical, 15)
        
    }
}

struct DraggableSplashContainer: View {
    
    var body: some View {
        if #available(iOS 13.4, *) {
            return DraggableSplash()
                .onDrag({ NSItemProvider(object: "" as NSString) }).toAnyView()
        } else {
            return DraggableSplash(title: "(Choose day by tapping on it)").toAnyView()
        }
    }
}
 
struct DraggableSplash_Previews: PreviewProvider {
    static var previews: some View {
        DraggableSplash()
    }
}
