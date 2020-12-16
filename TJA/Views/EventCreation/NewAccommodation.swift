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
                
                ZStack(alignment: .top) {
                    VStack(alignment: .center, spacing: 10) {
                        TextField("Search...",
                            text: $searchViewModel.searchText,
                            onEditingChanged: { self.searchViewModel.enableSearch($0) }
                        )
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
                    
                    if !searchViewModel.searchText.isEmpty {
                        dropDownList
                            .padding(.top, 10 + 30)
                    }
                }
            }
            
            Button(action: {
                print("DEBUG: -- Save button pressed")
                if let loc = self.location, let d = self.checkin {
                    self.save(loc, time: d)
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
        .onAppear(perform: configureViewModel)
    }
    
    var formFilled: Bool {
        checkin != nil && location != nil
    }
    
    var dropDownList: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<searchViewModel.items.count, id: \.self) { i in
                SimpleSearchItem(title: searchViewModel.items[i].name)
                    .onTapGesture {
                        print("DEBUG -- \(i) tapped")
                        let dest = searchViewModel.items[i]
                        self.searchViewModel.searchText = dest.name
                        self.name = dest.name
                        self.location = dest
                        self.hideKeyboard()
                        self.searchViewModel.clearStored(cancellAll: true)
                        self.address = self.searchViewModel.location.capitalizedFirstLetter()
                        self.direction = "check-in"
                    }
            }
        }
        .background(
            Rectangle()
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black, radius: 4.0))
        .overlay(Rectangle().stroke(Color(UIColor.opaqueSeparator), lineWidth: 1))
    }
    
    func save(_ location: AccommodationLocation, time: Date) {
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
    
    private func configureViewModel() {
        if let locationName = self.viewModel.trip.location?.placeName {
            self.searchViewModel.configure(location: locationName.lowercased())
        }
        self.searchViewModel.resetData()
    }
}

struct NewAccommodation_Previews: PreviewProvider {
    static var previews: some View {
        NewAccommodation()
    }
}
