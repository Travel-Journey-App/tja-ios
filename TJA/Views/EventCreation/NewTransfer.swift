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
    @ObservedObject var searchViewModel = TransferPointSearchViewModel(apiService: APISession.shared)
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: ActivityViewModel
    
    @State var departurePlace: Location? = nil
    @State var arrivalPlace: Location? = nil
    @State var date: Date? = nil
    
    @State var departure: String = ""
    @State var arrival: String = ""
    @State var time: String = ""
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
                    
                    TextField("Departure point", text: $searchViewModel.depSearchText)
                        .textFieldStyle(BorderedTextField())
                        .overlay(dropDownListDep, alignment: .top)
                    TextField("Arrival point", text: $searchViewModel.arrSearchText)
                        .textFieldStyle(BorderedTextField())
                        .overlay(dropDownListArr, alignment: .top)
                    TextField("Departure time", text: $time)
                        .textFieldStyle(BorderedTextField())
                    
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
    
    var dropDownListDep: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<searchViewModel.depItems.count, id: \.self) { i in
                Text(searchViewModel.depItems[i].placeName)
                    .font(.system(size: 16))
                    .foregroundColor(Color(UIColor.label))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 32)
                    .onTapGesture {
                        print("DEBUG -- \(i) tapped")
                        let dest = searchViewModel.depItems[i]
                        self.searchViewModel.depSearchText = dest.placeName
                        self.departurePlace = dest
                        self.hideKeyboard()
                        self.searchViewModel.clearStoredDept(cancellAll: true)
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
    
    var dropDownListArr: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<searchViewModel.arrItems.count, id: \.self) { i in
                Text(searchViewModel.arrItems[i].placeName)
                    .font(.system(size: 16))
                    .foregroundColor(Color(UIColor.label))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 32)
                    .onTapGesture {
                        print("DEBUG -- \(i) tapped")
                        let dest = searchViewModel.arrItems[i]
                        self.searchViewModel.arrSearchText = dest.placeName
                        self.arrivalPlace = dest
                        self.hideKeyboard()
                        self.searchViewModel.clearStoredArr(cancellAll: true)
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
}

struct NewTransfer_Previews: PreviewProvider {
    static var previews: some View {
        NewTransfer()
    }
}
