//
//  NewTransfer.swift
//  TJA
//
//  Created by Miron Rogovets on 29.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct NewTransfer: View {
    
    @ObservedObject private var keyboard = KeyboardResponder()
    @ObservedObject var searchViewModel = TransferPointSearchViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: ActivityViewModel
    
    // Assigned automatically with selection
    @State var departurePlace: Location? = nil
    @State var arrivalPlace: Location? = nil
    
    // Assigned manually
    @State var date: Date? = nil
    @State var flight: String = ""
    @State var seat: String = ""
    
    
    let filters: [Activity.Transfer] = [.plane, .train, .ship, .bus, .car]
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            HStack(spacing: 13) {
                ForEach(0..<filters.count, id: \.self) { i in
                    CircleIcon(
                        icon: filters[i].icon,
                        size: 35,
                        backgroundColor: filters[i] == searchViewModel.transfer
                            ? Color.mainRed : Color(UIColor.systemBackground))
                        .onTapGesture {
                            self.searchViewModel.transfer = filters[i]
                        }
                }
            }
            .resignKeyboardOnDragGesture()
            
            
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 10) {
                    
                    TextField(
                        "Departure point",
                        text: $searchViewModel.depSearchText,
                        onEditingChanged: { val in
                            if val { self.searchViewModel.configure(target: .departure)}
                            self.searchViewModel.enableSearch(val)
                        },
                        onCommit:  { self.searchViewModel.clearStored() }
                    )
                    .textFieldStyle(BorderedTextField())
                    .overlay(createDropDownList(
                                searchViewModel.departureItems,
                                tapCallback: { loc in
                                    self.searchViewModel.depSearchText = loc.placeName
                                    self.departurePlace = loc
                                    self.hideKeyboard()
                                    self.searchViewModel.clearStored(cancellAll: true)
                                }), alignment: .top)
                    TextField(
                        "Arrival point",
                        text: $searchViewModel.arrSearchText,
                        onEditingChanged: { val in
                            if val { self.searchViewModel.configure(target: .arrival)}
                            self.searchViewModel.enableSearch(val)
                        },
                        onCommit:  { self.searchViewModel.clearStored() }
                    )
                    .textFieldStyle(BorderedTextField())
                    .overlay(createDropDownList(
                                searchViewModel.arrivalItems,
                                tapCallback: { loc in
                                    self.searchViewModel.arrSearchText = loc.placeName
                                    self.arrivalPlace = loc
                                    self.hideKeyboard()
                                    self.searchViewModel.clearStored(cancellAll: true)
                                }), alignment: .top)
                    
                    DateField(
                        "Time",
                        date: $date,
                        formatter: fixedTimeFormatter,
                        mode: UIDatePicker.Mode.time)
                        .padding(.horizontal, 12)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 2)
                                .strokeBorder(Color.mainRed, lineWidth: 2)
                        )
                    
                    if searchViewModel.transfer != .bus && searchViewModel.transfer != .car {
                        TextField(numberPlaceholder, text: $flight)
                            .textFieldStyle(BorderedTextField())
                        TextField("Seat", text: $seat)
                            .textFieldStyle(BorderedTextField())
                    } else {
                        Spacer()
                    }
                }
                .frame(maxHeight: .infinity)
                .padding(.vertical, 10)
            }
            
            
            Button(action: {
                print("DEBUG: -- Save button pressed")
                if let departure = departurePlace, let time  = date {
                    self.save(departure, time: time)
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
        .navigationBarTitle(Text("Add Transfer".uppercased()), displayMode: .inline)
        .onAppear(perform: configureViewModel)
    }
    
    var numberPlaceholder: String {
        switch searchViewModel.transfer {
        case .plane: return "Flight number"
        case .train: return "Train number"
        case .ship: return "Ship number"
        default: return ""
        }
    }
    
    var formFilled: Bool {
        departurePlace != nil && arrivalPlace != nil && date != nil
    }
    
    private func createDropDownList(
        _ items: [Location],
        tapCallback: @escaping ((Location) -> ())
    ) -> some View {
        return VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<items.count, id: \.self) { i in
                Text(items[i].placeName)
                    .font(.system(size: 16))
                    .foregroundColor(Color(UIColor.label))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 32)
                    .onTapGesture {
                        print("DEBUG -- \(i) tapped")
                        tapCallback(items[i])
                    }
            }.padding(.horizontal, 12)
        }
        .background(
            Rectangle()
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black, radius: 4.0))
        .overlay(Rectangle().stroke(Color(UIColor.opaqueSeparator), lineWidth: 1))
        .offset(y: 40)
    }
    
    private func save(_ location: Location, time: Date) {
        if let day = self.viewModel.activeDayNumber,
           let index = self.viewModel.activeDayIndex {
            let flightDescription = !flight.isEmpty ? "\(numberPlaceholder): \(flight)" : ""
            let seatDescription = !seat.isEmpty ? "Seat: \(seat)" : ""
            
            let description = !flightDescription.isEmpty && !seatDescription.isEmpty ?
                "\(flightDescription)\n\(seatDescription)" : flightDescription + seatDescription
            
            let timeValue = time.timeIntervalSince(Date().startOf(.day))
            
            let request = ActivityRequest.New.createRequest(
                for: self.searchViewModel.transfer,
                with: location,
                for: TimeInterval(.day * Double(day - 1) + timeValue),
                with: self.viewModel.startDate,
                with: .arrival,
                with: description)
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
        self.$searchViewModel.transfer.didSet { _ in resetFields() }
    }
    
    private func resetFields() {
        self.seat = ""
        self.flight = ""
        self.date = nil
        self.departurePlace = nil
        self.arrivalPlace = nil
    }
}

struct NewTransfer_Previews: PreviewProvider {
    static var previews: some View {
        NewTransfer()
    }
}
