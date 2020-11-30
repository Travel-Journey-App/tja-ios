//
//  DaysContainer.swift
//  TJA
//
//  Created by Miron Rogovets on 19.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct DaysContainer: View {
    
    enum ActiveSheet: Identifiable {
        case magic, wish, manual
        
        var id: Int {
            hashValue
        }
    }
    
    @EnvironmentObject var eventService: EventService
    @State var isBlurShown: Bool = false
    @State var activeSheet: ActiveSheet?
    @State var isCalendarAlertShown: Bool = false
    
    
    var body: some View {
        ZStack(alignment: .top) {
            // Content
            ScrollView {
                VStack(spacing: 5) {
                    ForEach(0..<eventService.daysCount) { day in
                        DayCell(dayNumber: day + 1)
                    }
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 10)
            }
            
            if isBlurShown {
                BlurView().onTapGesture {
                    self.isBlurShown = false
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    AddButtonsStack(
                        isExpanded: $isBlurShown,
                        calendarFlow: { self.isCalendarAlertShown = true },
                        magicFlow: { self.activeSheet = .magic },
                        ideasFlow: { self.activeSheet = .wish },
                        manualFlow: { self.activeSheet = .manual }
                    )
                }
            }
            .padding(.trailing, 16)
            .padding(.bottom, 48)
        }
        .sheet(item: $activeSheet) { item in
            switch item {
            case .magic: Text("Magic")
            case .wish: WishList().accentColor(Color("MainRed"))
            case .manual: EventCreation().accentColor(Color("MainRed"))
            }
        }
        .alert(isPresented: $isCalendarAlertShown) {
            Alert(
                title: Text("Sorry"),
                message: Text("There are no events in your calendar for current trip dates"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct DaysContainer_Previews: PreviewProvider {
    static var previews: some View {
        DaysContainer()
    }
}
