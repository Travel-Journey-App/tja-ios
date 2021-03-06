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
    
    enum DragNDropTarget: Identifiable {
        case wish, manual
        var id: Int {
            hashValue
        }
    }
    
    @EnvironmentObject var locationService: LocationService
    @EnvironmentObject var viewModel: ActivityViewModel
    @EnvironmentObject var popupViewModel: PopupViewModel
    @State var isBlurShown: Bool = false
    @State var activeSheet: ActiveSheet?
    @State var dragNdropTarget: DragNDropTarget? = nil

    var body: some View {

        return ZStack(alignment: .top) {
            // Content
            content
            
            if isBlurShown {
                BlurView().onTapGesture {
                    self.isBlurShown = false
                }
            }
            
            if dragNdropTarget != nil {
                
                VStack {
                    Spacer()
                    DraggableSplashContainer()
                }
                
            } else {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        AddButtonsStack(
                            isExpanded: $isBlurShown,
                            magicFlow: { self.activeSheet = .magic },
                            ideasFlow: {
                                self.isBlurShown = false
                                self.dragNdropTarget = .wish
                            },
                            manualFlow: {
                                self.isBlurShown = false
                                self.dragNdropTarget = .manual
                            }
                        )
                    }
                }
                .padding(.trailing, 16)
                .padding(.bottom, 48)
            }
        }
        .onAppear { self.viewModel.resetSwipes() }
        .sheet(item: $activeSheet) { item in
            switch item {
            case .magic: MagicMode().accentColor(.mainRed)
            case .wish: WishList()
                .accentColor(.mainRed)
                .environmentObject(viewModel)
                .environmentObject(locationService)
            case .manual: EventCreation()
                .accentColor(.mainRed)
                .environmentObject(viewModel)
            }
        }
    }
    
    var content: some View {
        if #available(iOS 13.4, *) {
            return // Content
                ScrollView {
                    VStack(spacing: 5) {
                        ForEach(0..<viewModel.daysCount, id: \.self) { i in
                            DayCell(
                                $viewModel.trip.days[i].activities,
                                dayNumber: viewModel.trip.days[i].orderInTrip,
                                active: dragNdropTarget != nil ?
                                    viewModel.active == i ? true : false
                                    : true,
                                onRemove: { (activity) in
                                    self.viewModel.delete(activity, in: viewModel.trip.days[i].id)
                                },
                                onTap: { (activity, day) in
                                    self.popupViewModel.activity = activity
                                    self.popupViewModel.dayIndex =
                                        self.viewModel.trip.days[i].id
                                    self.popupViewModel.dayNumber = day
                                }
                            ).onDrop(
                                of: ["public.item-source"],
                                delegate: ItemDropDelegate(
                                    day: i,
                                    active: $viewModel.active,
                                    activeSheet: $activeSheet,
                                    target: $dragNdropTarget)
                            )
                        }
                    }
                    .padding(.vertical, 15)
                    .padding(.horizontal, 10)
                }.toAnyView()
            
        } else {
            return // Content
                ScrollView {
                    VStack(spacing: 5) {
                        ForEach(0..<viewModel.daysCount, id: \.self) { i in
                            DayCell(
                                $viewModel.trip.days[i].activities,
                                dayNumber: viewModel.trip.days[i].orderInTrip,
                                active: dragNdropTarget != nil ?
                                    viewModel.active == i ? true : false
                                    : true,
                                onRemove: { (activity) in
                                    self.viewModel.delete(activity, in: viewModel.trip.days[i].id)
                                },
                                onTap: { (activity, day) in
                                    self.popupViewModel.activity = activity
                                    self.popupViewModel.dayIndex =
                                        self.viewModel.trip.days[i].id
                                    self.popupViewModel.dayNumber = day
                                }
                            )
                            .onTapGesture {
                                self.viewModel.active = i
                                switch dragNdropTarget {
                                case .wish: self.activeSheet = .wish
                                case .manual: self.activeSheet = .manual
                                case .none: break
                                }
                                self.dragNdropTarget = nil
                            }
                        }
                    }
                    .padding(.vertical, 15)
                    .padding(.horizontal, 10)
                }.toAnyView()
        }
    }
}

struct DaysContainer_Previews: PreviewProvider {
    static var previews: some View {
        DaysContainer()
    }
}
