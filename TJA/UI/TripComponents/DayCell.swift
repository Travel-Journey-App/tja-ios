//
//  DayCell.swift
//  TJA
//
//  Created by Miron Rogovets on 17.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct DayCell: View {
    
    var dayNumber: Int = 1
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Day \(dayNumber)")
                .font(.system(size: 20))
                .fontWeight(.medium)
                .foregroundColor(Color("MainRed"))
                .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .padding(5)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color("TripCellBackground")))
    }
}

struct DayCell_Previews: PreviewProvider {
    static var previews: some View {
        DayCell()
    }
}
