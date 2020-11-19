//
//  CreateTrip.swift
//  TJA
//
//  Created by Miron Rogovets on 17.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct CreateTrip: View {
    
    @State var name: String = ""
    @State var destination: String = ""
    @State var startDate: Date? = nil
    @State var endDate: Date? = nil
    
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var tripService: TripService
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 10) {
                UnderlinedTextField(text: $name, placeholder: "Trip name")
                    .frame(height: 48)
                UnderlinedTextField(text: $destination, placeholder: "Trip destination")
                    .frame(height: 48)
                UnderlinedDateField(date: $startDate, placeholder: "Trip date start", imageName: "calendar")
                    .frame(height: 48)
                UnderlinedDateField(date: $endDate, placeholder: "Trip date finish", imageName: "calendar")
                    .frame(height: 48)
                
                // Email button
                // Calendar button
                Button(action: {
                    print("DEBUG: -- Open email client button tapped")
                    guard let url = URL(string: "message://") else { return }
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }){
                    HStack(spacing: 20) {
                        Text("Open email client".uppercased())
                        Image(systemName: "envelope")
                    }
                    .padding(.horizontal, 10)
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(FilledButtonStyle(filled: false))
                .frame(height: 50)
                .padding(.top, 20)
                
                // Info label
                Text(Constants.Text.supportInfoText)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(UIColor.systemGray))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 2)
                
                // Save button
                Button(action: {
                    print("DEBUG: -- Save button pressed")
                    self.saveTrip()
                }){
                    Text("Save".uppercased())
                }
                .buttonStyle(
                    FilledButtonStyle(
                        filled: true,
                        color: formFilled ? Color("MainRed") : Color(UIColor.systemGray)
                    )
                )
                .disabled(!formFilled)
                .padding(.bottom, 10)
                
            }
            .padding(.vertical, 30)
            .padding(.horizontal, 16)
        }
        .navigationBarTitle(Text("Add new trip".uppercased()), displayMode: .inline)
        .resignKeyboardOnDragGesture()
    }
    
    var formFilled: Bool {
        return !(name.isEmpty || destination.isEmpty || startDate == nil || endDate == nil)
    }
    
    func saveTrip() {
        guard !name.isEmpty && !destination.isEmpty else { return }
        guard let start = startDate, let end = endDate else { return }
        self.tripService.saveTrip(name: name, startDate: start, endDate: end)
        self.presentation.wrappedValue.dismiss()
    }
}

struct CreateTrip_Previews: PreviewProvider {
    static var previews: some View {
        CreateTrip()
    }
}
