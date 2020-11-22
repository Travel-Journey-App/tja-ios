//
//  ShadowImage.swift
//  TJA
//
//  Created by Miron Rogovets on 22.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct ShadowImage: View {
    
    let name: String
    let radius: CGFloat = 4.0
    
    var body: some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .shadow(color: .black, radius: radius)
    }
}

struct ShadowImage_Previews: PreviewProvider {
    static var previews: some View {
        ShadowImage(name: "bar-category")
            .frame(width: 128, height: 128, alignment: .center)
    }
}
