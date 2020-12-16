//
//  ActivityIndicator.swift
//  TJA
//
//  Created by Miron Rogovets on 17.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import UIKit
import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        UIActivityIndicatorView(style: .large)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        uiView.startAnimating()
    }
}


struct ActivityIndicator: View {
    var body: some View {
        ActivityIndicatorView()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicator()
            .background(Color.white)
    }
}
