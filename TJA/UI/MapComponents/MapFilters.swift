//
//  MapFilters.swift
//  TJA
//
//  Created by Miron Rogovets on 20.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct MapFilters: View {
    
    var daysCount: Int
    
    enum Filter: Equatable {
        case all
        case day(number: Int)
    }
    
    @State var filter: Filter = .all
    var onFilterChanged: ((Int?)->())?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                Button(action: {
                    print("DEBUG: -- Filter 'All' tapped")
                    self.filter = .all
                    self.onFilterChanged?(nil)
                }) {
                    Text("All")
                }
                .buttonStyle(SharpBorderButtonStyle(filled: isFilled(for: .all)))
                
                ForEach(0..<daysCount) { index in
                    Button(action: {
                        print("DEBUG: -- Filter 'Day \(index+1)' tapped")
                        self.filter = .day(number: index)
                        self.onFilterChanged?(index)
                    }) {
                        Text("Day \(index+1)")
                    }
                    .frame(height: 28, alignment: .center)
                    .frame(minWidth: 44)
                    .buttonStyle(SharpBorderButtonStyle(filled: isFilled(for: .day(number: index))))
                }
            }
        }
    }
    
    private func isFilled(for filter: Filter) -> Bool {
        return filter == self.filter
    }
}

struct MapFilters_Previews: PreviewProvider {
    static var previews: some View {
        MapFilters(daysCount: 3)
    }
}
