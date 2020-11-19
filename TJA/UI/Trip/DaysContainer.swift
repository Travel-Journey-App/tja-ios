//
//  DaysContainer.swift
//  TJA
//
//  Created by Miron Rogovets on 19.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct DaysContainer: View {
    
    var daysCount = 2
    
    var body: some View {
        ZStack(alignment: .top) {
            // Content
            ScrollView {
                VStack(spacing: 5) {
                    ForEach(1..<daysCount+1) { day in
                        DayCell(dayNumber: day)
                    }
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 10)
            }
            
            // "+" button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        print("DEBUG: -- Add button tapped")
                    }) {
                        Image(systemName: "plus")
                            .frame(width: 24, height: 24, alignment: .center)
                    }
                    .buttonStyle(CircleButtonStyle())
                }
            }
            .padding(.trailing, 16)
            .padding(.bottom, 48)
        }
    }
}

struct DaysContainer_Previews: PreviewProvider {
    static var previews: some View {
        DaysContainer()
    }
}
