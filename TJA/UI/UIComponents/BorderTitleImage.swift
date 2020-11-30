//
//  BorderTitleImage.swift
//  TJA
//
//  Created by Miron Rogovets on 22.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct BorderTitleImage: View {
    
    enum Source {
        case transfer, accomodation, event
    }
    
    let source: Source
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity)
            .frame(height: 85, alignment: .center)
            .overlay(
                StrokeText(text: title, width: 1.0, color: .black)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 2)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 5),
                alignment: .bottomTrailing)
            .clipped()
            .border(Color("MainRed"), width: 3.0)
            .contentShape(Rectangle())
    }
    
    var title: String {
        switch source {
        case .accomodation:
            return "Accomodation"
        case .transfer:
            return "Transfer"
        case .event:
            return "Event"
        }
    }
    
    var imageName: String {
        switch source {
        case .accomodation:
            return "hotel-template"
        case .transfer:
            return "train-template"
        case .event:
            return "event-template"
        }
    }
}

struct BorderTitleImage_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 10) {
            BorderTitleImage(source: .transfer)
            BorderTitleImage(source: .accomodation)
            BorderTitleImage(source: .event)
        }.padding(10)
    }
}
