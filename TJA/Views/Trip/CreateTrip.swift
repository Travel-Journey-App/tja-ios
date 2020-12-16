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
    @State var destination: Location? = nil
    @State var startDate: Date? = nil
    @State var endDate: Date? = nil
    @State var startDateError: Bool = false
    @State var endDateError: Bool = false
    
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var viewModel: TripsViewModel
    @ObservedObject var searchViewModel = DestinationSearchViewModel()
    
    var body: some View {
        ScrollView(.vertical) {
            ZStack(alignment: .top) {
                VStack(spacing: 10) {
                    UnderlinedTextField(text: $name, placeholder: "Trip name")
                        .frame(height: 48)
                    UnderlinedTextField(
                        text: $searchViewModel.searchText,
                        placeholder: "Trip destination",
                        onEditingChanged: { self.searchViewModel.enableSearch($0) },
                        onCommit: { self.searchViewModel.clearStored() })
                        .frame(height: 48)
                    UnderlinedDateField(
                        date: $startDate.didSet(execute: { self.startDateError = !self.checkStartDate($0)}),
                        placeholder: "Trip date start", imageName: "calendar",
                        activeColor: startDateError ? Color(UIColor.systemRed) : .mainRed)
                        .frame(height: 48)
                    UnderlinedDateField(
                        date: $endDate.didSet(execute: { self.endDateError = !self.checkEndDate($0)}),
                        placeholder: "Trip date finish", imageName: "calendar",
                        activeColor: endDateError ? Color(UIColor.systemRed) : .mainRed)
                        .frame(height: 48)
                    
                    if startDateError || endDateError {
                        Text("Select the correct \(startDateError ? "start" : endDateError ? "end" : "") date")
                            .font(.system(size: 12))
                            .foregroundColor(Color(UIColor.systemRed))
                            .frame(alignment: .leading)
                            .padding(.top, -4)
                    } else {
                        Spacer().frame(height: 10)
                    }
                    
                    // Email button
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
                            color: formFilled ? .mainRed : Color(UIColor.systemGray)
                        )
                    )
                    .disabled(!formFilled)
                    .padding(.bottom, 10)
                    
                }
                .padding(.vertical, 30)
                .padding(.horizontal, 16)
                
                if !searchViewModel.searchText.isEmpty {
                    dropDownList
                        .padding(.top, 48 + 10 + 40 + 30)
                        .padding(.horizontal, 16)
                }
            }
        }
        .navigationBarTitle(Text("Add new trip".uppercased()), displayMode: .inline)
        .resignKeyboardOnDragGesture()
        .onAppear(perform: configureViewModel)
    }
    
    var dropDownList: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<searchViewModel.items.count, id: \.self) { i in
                Text(searchViewModel.items[i].placeName)
                    .font(.system(size: 16))
                    .foregroundColor(Color(UIColor.label))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 32)
                    .onTapGesture {
                        print("DEBUG -- \(i) tapped")
                        let dest = searchViewModel.items[i]
                        self.searchViewModel.searchText = dest.placeName
                        self.destination = dest
                        self.hideKeyboard()
                        self.searchViewModel.clearStored(cancellAll: true)
                        if self.name.isEmpty {
                            self.name = dest.placeName
                        }
                    }
            }.padding(.horizontal, 12)
        }
        .background(
            Rectangle()
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black, radius: 4.0))
        .overlay(Rectangle().stroke(Color(UIColor.opaqueSeparator), lineWidth: 1))
    }
    
    var formFilled: Bool {
        return (!(name.isEmpty || destination == nil) && datesCorrect)
    }
    
    var datesCorrect: Bool {
        guard let start = startDate, let end = endDate else { return false }
        return start.startOf(.day) >= Date().startOf(.day) && end.startOf(.day) > start.startOf(.day)
    }
    
    func saveTrip() {
        guard !name.isEmpty, let dest = destination else { return }
        guard let start = startDate, let end = endDate else { return }
        self.viewModel.createTrip(
            name: name,
            destination: dest,
            startDate: start,
            endDate: end
        )
        self.presentation.wrappedValue.dismiss()
    }
    
    private func checkStartDate(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        return date.startOf(.day) >= Date().startOf(.day)
    }
    
    private func checkEndDate(_ date: Date?) -> Bool {
        guard let start = startDate, let end = date else { return false }
        return end.startOf(.day) > start.startOf(.day)
    }
    
    private func configureViewModel() {
        self.searchViewModel.resetData()
    }
}

struct CreateTrip_Previews: PreviewProvider {
    static var previews: some View {
        CreateTrip().environmentObject(DestinationSearchViewModel(apiService: APISession.shared))
    }
}
