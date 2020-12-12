//
//  DraggableSplash.swift
//  TJA
//
//  Created by Miron Rogovets on 03.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct DraggableSplash: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 7, style: .continuous)
            .fill(Color.splash)
            .overlay(
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .strokeBorder(Color(UIColor.opaqueSeparator), lineWidth: 1))
            .overlay(
                Text("(Place it where it's planned to be)")
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

struct DraggableSplash_Previews: PreviewProvider {
    static var previews: some View {
        DraggableSplash()
    }
}
