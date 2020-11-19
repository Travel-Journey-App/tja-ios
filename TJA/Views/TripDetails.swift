//
//  TripDetails.swift
//  TJA
//
//  Created by Miron Rogovets on 10.11.2020.
//

import SwiftUI

struct TripDetails: View {
    
    @State var selectedTab = Tab.pipeline
    
    var tripname = ""
    var daysCount = 2
    
    enum Tab: Int {
        case pipeline, map
        
        var icon: String {
            switch self {
            case .pipeline: return "list.bullet"
            case .map: return "mappin.circle"
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                // Segment control
                Picker("", selection: $selectedTab) {
                    Image(systemName: Tab.pipeline.icon)
                        .tag(Tab.pipeline)
                        .frame(width: 24, height: 24, alignment: .center)
                    Image(systemName: Tab.map.icon)
                        .tag(Tab.map)
                        .frame(width: 24, height: 24, alignment: .center)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 10)
                .padding(.top, 10)
                
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
        .navigationBarTitle(Text(tripname.uppercased()), displayMode: .inline)
    }
}

struct TripDetails_Previews: PreviewProvider {
    static var previews: some View {
        TripDetails()
    }
}
