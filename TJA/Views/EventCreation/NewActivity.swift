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
    
    @State var selectedLocation: SuggestionPlace? = nil
    
    @State var name: String = ""
    @State var address: String = ""
    @State var time: Date? = nil
    
    let filters: [Activity.Event] = [.museum, .gallery, .sightseeing, .food, .bar, .fun]
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 10) {
            HStack(spacing: 13) {
                ForEach(0..<filters.count, id: \.self) { i in
                    CircleIcon(
                        icon: filters[i].icon,
                        size: 35,
                        backgroundColor: filters[i] == self.searchViewModel.event
                            ? Color.mainRed : Color(UIColor.systemBackground))
                        .onTapGesture {
                            self.searchViewModel.event = filters[i]
                        }
                }
            }
            .resignKeyboardOnDragGesture()
            
            
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 10) {
                    TextField(
                        "Search...",
                        text: $searchViewModel.searchText,
                        onEditingChanged: { self.searchViewModel.enableSearch($0) },
                        onCommit:  { self.searchViewModel.clearStored() }
                    )
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
                if let location = selectedLocation {
                    self.save(location, time: self.time)
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
        .navigationBarTitle(Text("Add Event".uppercased()), displayMode: .inline)
        .onAppear(perform: configureViewModel)
    }
    
    var formFilled: Bool {
        selectedLocation != nil
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
                        let place = searchViewModel.items[i]
                        self.searchViewModel.searchText = place.name
                        self.name = place.name
                        self.address = self.searchViewModel.location.capitalizedFirstLetter()
                        self.selectedLocation = place
                        self.hideKeyboard()
                        self.searchViewModel.clearStored(cancellAll: true)
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
    
    private func save(_ place: SuggestionPlace, time: Date? = nil) {
        if let day = self.viewModel.activeDayNumber,
           let index = self.viewModel.activeDayIndex {
            
            let request: NewActivityRequest
            
            if let exactTime = time {
                let timeValue = exactTime.timeIntervalSince(Date().startOf(.day))
                let interval = TimeInterval(.day * Double(day - 1) + timeValue)
                request = place.activityRequest(
                    with: self.viewModel.startDate.addingTimeInterval(interval)
                )
            } else {
                request = place.activityRequest(for: self.viewModel.startDate, day: day)
            }
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
        self.$searchViewModel.event.didSet { _ in resetFields() }
    }
    
    private func resetFields() {
        self.selectedLocation = nil
        self.time = nil
        self.name = ""
        self.address = ""
    }
}

struct NewActivity_Previews: PreviewProvider {
    static var previews: some View {
        NewActivity()
    }
}
