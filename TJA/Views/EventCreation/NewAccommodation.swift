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
    
    @State var checkin: Date? = nil
    @State var location: AccommodationLocation? = nil
    
    @State var name: String = ""
    @State var address: String = ""
    @State var time: String = ""
    @State var direction: String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 10) {
                    TextField("Search...", text: $searchViewModel.searchText, onCommit:  {
                        self.searchViewModel.clearStored()
                    })
                        .textFieldStyle(
                            BorderedTextField(color: .lightRedBorder, borderSize: 1, cornerRadius: 10)
                        )
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .frame(height: 30)
                        .padding(.bottom, 6)
                        .overlay(dropDownList, alignment: .top)

                    TextField("Name", text: $name)
                        .textFieldStyle(BorderedTextField())
                    TextField("Address", text: $address)
                        .textFieldStyle(BorderedTextField())
                    DateField(
                        "Time",
                        date: $checkin,
                        formatter: fixedTimeFormatter,
                        mode: UIDatePicker.Mode.time
                    )
                        .padding(.horizontal, 12)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 2)
                                .strokeBorder(Color.mainRed, lineWidth: 2)
                        )
                    TextField("Check-in", text: $direction)
                        .textFieldStyle(BorderedTextField())
                    
                }
                .frame(maxHeight: .infinity)
                .padding(.vertical, 10)
            }
            
            
            
            Button(action: {
                print("DEBUG: -- Save button pressed")
                if let loc = self.location, let d = self.checkin {
                    self.addItem(loc, time: d)
                }
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
        checkin != nil && location != nil
    }
    
    var dropDownList: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<searchViewModel.items.count, id: \.self) { i in
                Text(searchViewModel.items[i].name)
                    .font(.system(size: 16))
                    .foregroundColor(Color(UIColor.label))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 32)
                    .onTapGesture {
                        print("DEBUG -- \(i) tapped")
                        let dest = searchViewModel.items[i]
                        self.searchViewModel.searchText = dest.name
                        self.name = dest.name
                        self.location = dest
                        self.hideKeyboard()
                        self.searchViewModel.clearStored(cancellAll: true)
                        self.address = "Tokyo"
                        self.direction = "check-in"
                    }
            }.padding(.horizontal, 12)
        }
        .background(
            Rectangle()
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black, radius: 4.0))
        .overlay(Rectangle().stroke(Color(UIColor.opaqueSeparator), lineWidth: 1))
        .offset(y: 30)
    }
    
    func addItem(_ location: AccommodationLocation, time: Date) {
        print("Time: \(time)")
        if let day = self.viewModel.activeDayNumber,
           let index = self.viewModel.activeDayIndex {
            
            let timeValue = time.timeIntervalSince(Date().startOf(.day))
            let request = ActivityRequest.New.createRequest(
                for: location,
                for: TimeInterval(.day * Double(day - 1) + timeValue),
                with: self.viewModel.startDate,
                with: .checkin)
            
            self.viewModel.create(request, in: index) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct NewAccommodation_Previews: PreviewProvider {
    static var previews: some View {
        NewAccommodation()
    }
}
