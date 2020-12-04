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
    @State var isInDragNDropMode: Bool = true

    var body: some View {
        let dropDelegate = ItemDropDelegate(active: $eventService.active.didSet(execute: {
           id in print("Updated to \(id)")
        }), activeSheet: $activeSheet)
        return ZStack(alignment: .top) {
            // Content
            ScrollView {
                VStack(spacing: 5) {
                    ForEach(0..<eventService.daysCount) { day in
                        DayCell(
                            eventService.filterBy(day: day),
                            dayNumber: day,
                            active: isInDragNDropMode ?
                                eventService.active == day ? true : false
                                : true
                        )
                    }.onDrop(of: ["public.item-source"], delegate: dropDelegate)
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 10)
            }
            
            if isBlurShown {
                BlurView().onTapGesture {
                    self.isBlurShown = false
                }
            }
            
            if isInDragNDropMode {
                
                VStack {
                    Spacer()
                    DraggableSplash()
                        .onDrag({ NSItemProvider(object: "a" as NSString) })
                }
                
            } else {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        AddButtonsStack(
                            isExpanded: $isBlurShown,
                            magicFlow: { self.activeSheet = .magic },
                            ideasFlow: { self.activeSheet = .wish },
                            manualFlow: { self.activeSheet = .manual }
                        )
                    }
                }
                .padding(.trailing, 16)
                .padding(.bottom, 48)
            }
        }
        .sheet(item: $activeSheet) { item in
            switch item {
            case .magic: MagicMode().accentColor(Color("MainRed"))
            case .wish: WishList().accentColor(Color("MainRed"))
            case .manual: EventCreation().accentColor(Color("MainRed"))
            }
        }
    }
}

struct DaysContainer_Previews: PreviewProvider {
    static var previews: some View {
        DaysContainer()
    }
}
