//
//  LoadingView.swift
//  TJA
//
//  Created by Miron Rogovets on 17.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Color(UIColor.systemBackground)
                    .opacity(0.5)
                ActivityIndicatorView()
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height,
                alignment: .topLeading
            )
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
