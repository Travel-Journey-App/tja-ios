//
//  WishList.swift
//  TJA
//
//  Created by Miron Rogovets on 29.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct WishList: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: ActivityViewModel
    
    private let items: [WishItem] = [
        .breakfast, .lunch, .dinner, .bar,
        .gallery, .sightseeng, .museums, .fun
    ]
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                Grid(columns: 2, list: items, vSpacing: 25) { wish in
                    NavigationLink(
                        destination: WishItemsContainer(onAdd: addItem(_:))
                            .environmentObject(
                                WishViewModel(
                                    wish: wish,
                                    location: viewModel.trip.location ?? Constants.defaultLocation,
                                    apiService: APISession.shared
                                ))
                            .environmentObject(PopupSuggestionViewModel())
                    ) {
                        ShadowImage(name: wish.image)
                            .frame(width: 128, height: 128, alignment: .center)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(25)
            }
            .navigationBarTitle(Text("I wish...".uppercased()), displayMode: .inline)
            .navigationBarItems(
                leading: Button(
                    action: { self.presentationMode.wrappedValue.dismiss() },
                    label: { Text("Cancel") }
                )
            )
        }.onDisappear { self.viewModel.active = -1 }
    }
    
    func addItem(_ suggestion: SuggestionPlace) {
        if let day = self.viewModel.activeDayNumber,
           let index = self.viewModel.activeDayIndex {
            
            let request = suggestion.activityRequest(for: self.viewModel.startDate, day: day)
            self.viewModel.create(request, in: index) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct WishList_Previews: PreviewProvider {
    static var previews: some View {
        WishList()
    }
}
