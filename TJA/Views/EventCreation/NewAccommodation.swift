//
//  NewAccommodation.swift
//  TJA
//
//  Created by Miron Rogovets on 29.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct NewAccommodation: View {
    
    @ObservedObject private var keyboard = KeyboardResponder()
    @ObservedObject var searchViewModel = AccommodationSearchViewModel(apiService: APISession.shared)
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: ActivityViewModel
    
    @State var query: String = ""
    @State var name: String = ""
    @State var address: String = ""
    @State var time: String = ""
    @State var direction: String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 10) {
                    TextField("Search...", text: $query)
                        .textFieldStyle(
                            BorderedTextField(color: .lightRedBorder, borderSize: 1, cornerRadius: 10)
                        )
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .frame(height: 30)
                        .padding(.bottom, 6)

                    TextField("Name", text: $name)
                        .textFieldStyle(BorderedTextField())
                    TextField("Address", text: $address)
                        .textFieldStyle(BorderedTextField())
                    TextField("Time", text: $time)
                        .textFieldStyle(BorderedTextField())
                    TextField("Check-in", text: $direction)
                        .textFieldStyle(BorderedTextField())
                    
                }
                .frame(maxHeight: .infinity)
                .padding(.vertical, 10)
            }
            
            
            
            Button(action: {
                print("DEBUG: -- Save button pressed")
            }){
                Text("Save".uppercased())
            }
            .buttonStyle(
                FilledButtonStyle(
                    filled: true,
                    color: formFilled ? .mainRed : Color(UIColor.systemGray)
                )
            )
            .frame(height: 50)
            .disabled(!formFilled)
            .padding(.bottom, 10 + keyboard.currentHeight)
            .resignKeyboardOnDragGesture()
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 15)
        .navigationBarTitle(Text("Add Accommodation".uppercased()), displayMode: .inline)
    }
    
    var formFilled: Bool {
        true
    }
}

struct NewAccommodation_Previews: PreviewProvider {
    static var previews: some View {
        NewAccommodation()
    }
}
