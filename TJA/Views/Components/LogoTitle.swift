//
//  LogoTitle.swift
//  TJA
//
//  Created by Miron Rogovets on 19.10.2020.
//

import SwiftUI

struct LogoTitle: View {
    var body: some View {
        Image("LogoTitle")
            .resizable()
            .scaledToFit()
    }
}

struct LogoTitle_Previews: PreviewProvider {
    static var previews: some View {
        LogoTitle()
    }
}
