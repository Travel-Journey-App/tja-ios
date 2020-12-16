//
//  NewActivity.swift
//  TJA
//
//  Created by Miron Rogovets on 29.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct NewActivity: View {
    
    @ObservedObject private var keyboard = KeyboardResponder()
    @ObservedObject var searchViewModel = EventSearchViewModel(apiService: APISession.shared)
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: ActivityViewModel
    
    @State var query: String = ""
    @State var name: String = ""
    @State var address: String = ""
    @State var time: Date? = nil
    
    @State var event: Activity.Event = .food
    
    let filters: [Activity.Event] = [.museum, .gallery, .sightseeing, .food, .bar, .fun]
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 10) {
            HStack(spacing: 13) {
                ForEach(0..<filters.count, id: \.self) { i in
                    CircleIcon(
                        icon: filters[i].icon,
                        size: 35,
                        backgroundColor: filters[i] == event
                            ? Color.mainRed : Color(UIColor.systemBackground))
                        .onTapGesture {
                            self.event = filters[i]
                        }
                }
            }
            .resignKeyboardOnDragGesture()
            
            
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
                    DateField(
                        "Time",
                        date: $time,
                        formatter: fixedTimeFormatter,
                        mode: UIDatePicker.Mode.time)
                        .padding(.horizontal, 12)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 2)
                                .strokeBorder(Color.mainRed, lineWidth: 2)
                        )
                    
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
        .navigationBarTitle(Text("Add Event".uppercased()), displayMode: .inline)
    }
    
    var formFilled: Bool {
        true
    }
}

struct NewActivity_Previews: PreviewProvider {
    static var previews: some View {
        NewActivity()
    }
}
