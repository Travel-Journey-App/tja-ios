//
//  TripContainer.swift
//  TJA
//
//  Created by Miron Rogovets on 30.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct TripContainer: View {
    
    @ObservedObject private var keyboard = KeyboardResponder()
    @EnvironmentObject var popupViewModel: PopupViewModel
    @EnvironmentObject var viewModel: ActivityViewModel
    var tripname = ""
    
    var body: some View {
        let isShown = Binding<Bool>(
            get: { return popupViewModel.hasValue },
            set: { if !$0 { popupViewModel.reset() } }
        )
        return ZStack {
            SegmentedContainer(
                list: { DaysContainer() },
                map: { MapContainer(location: viewModel.trip.location) }
            )
            if popupViewModel.hasValue {
                PopUpContainer(isShown: isShown) {
                    EventCard(
                        self.popupViewModel.activity ?? Constants.mockActivity,
                        dayNumber: popupViewModel.dayNumber ?? 0,
                        onDelete: { activity in
                            if let id = self.popupViewModel.dayIndex {
                                self.viewModel.delete(activity, in: id)
                                self.popupViewModel.reset()
                            }
                        },
                        onCommit: { note in
                            if let id = self.popupViewModel.dayIndex,
                               let activity = self.popupViewModel.commit(notes: note) {
                                self.viewModel.update(activity, in: id)
                            }
                        })
                        .padding(.horizontal, 30)
                        .frame(maxHeight: 210)
                        .offset(y: -keyboard.currentHeight / 4)
                }
                .frame(alignment: .center)
                .resignKeyboardOnDragGesture()
            }
        }
        .navigationBarTitle(Text(tripname.uppercased()), displayMode: .inline)
        .onAppear {
            self.viewModel.sort()
            self.popupViewModel.reset()
        }
    }
}
