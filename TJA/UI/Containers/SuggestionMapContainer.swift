//
//  SuggestionMapContainer.swift
//  TJA
//
//  Created by Miron Rogovets on 16.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct SuggestionMapContainer: View {
    
    @EnvironmentObject var locationService: LocationService
    @EnvironmentObject var viewModel: WishViewModel
    @EnvironmentObject var popupViewModel: PopupSuggestionViewModel
    
    var location: Location? = nil
    
    var body: some View {
        ZStack(alignment: .top) {
            Map<SuggestionPlace>(
                places: $viewModel.locations,
                tripLocation: location?.coordinate,
                didSelect: { self.popupViewModel.selected = $0 }
            ).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                Spacer()
                
                // Current location button
                HStack {
                    Spacer()
                    Button(action: {
                        print("DEBUG: -- Current location tapped")
                        self.locationService.userTrackingMode = .follow
                    }) {
                        Image(systemName: "location.fill")
                            .frame(width: 24, height: 24, alignment: .center)
                    }
                    .buttonStyle(CircleButtonStyle())
                }
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 30)
            .padding(.top, 20)
        }
        .onAppear(perform: self.locationService.checkPermissions)
        .alert(isPresented: $locationService.servicesDisabled) {
            Alert(title: Text("Please Enable Location Access In Settings"))
        }
        .onAppear(perform: self.viewModel.updateLocations)
    }
}

struct SuggestionMapContainer_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionMapContainer()
    }
}
