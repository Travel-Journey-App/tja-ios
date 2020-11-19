//
//  MapContainer.swift
//  TJA
//
//  Created by Miron Rogovets on 19.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct MapContainer: View {
    
    @EnvironmentObject var locationService: LocationService
    
    var body: some View {
        ZStack(alignment: .top) {
            Map(
                tripLocation: locationService.mockupCoordinate
            ).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                // Filters
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 40, height: 28)
                
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
    }
}

struct MapContainer_Previews: PreviewProvider {
    static var previews: some View {
        MapContainer()
    }
}
