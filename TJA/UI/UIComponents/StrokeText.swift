//
//  StrokeText.swift
//  TJA
//
//  Created by Miron Rogovets on 22.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct StrokeText: View {
    let text: String
    let width: CGFloat
    let color: Color

    var body: some View {
        ZStack{
            ZStack{
                Text(text).offset(x:  width, y:  width)
                Text(text).offset(x: -width, y: -width)
                Text(text).offset(x: -width, y:  width)
                Text(text).offset(x:  width, y: -width)
            }
            .foregroundColor(color)
            Text(text)
        }
    }
}
struct StrokeText_Previews: PreviewProvider {
    static var previews: some View {
        StrokeText(text: "Sample Text", width: 1, color: .black)
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .bold))
    }
}
