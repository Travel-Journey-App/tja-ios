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
    
    @State var departure: String = ""
    @State var arrival: String = ""
    @State var time: String = ""
    @State var flight: String = ""
    @State var seat: String = ""
    
    @State var transfer: Activity.Transfer = .plane
    
    let filters: [Activity.Transfer] = [.plane, .train, .ship, .bus, .car]
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            HStack(spacing: 13) {
                ForEach(0..<filters.count, id: \.self) { i in
                    CircleIcon(
                        icon: filters[i].icon,
                        size: 35,
                        backgroundColor: filters[i] == transfer
                            ? Color.mainRed : Color(UIColor.systemBackground))
                        .onTapGesture {
                            self.transfer = filters[i]
                        }
                }
            }
            .resignKeyboardOnDragGesture()
            
            
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 10) {
                    
                    TextField("Departure point", text: $departure)
                        .textFieldStyle(BorderedTextField())
                    TextField("Arrival point", text: $arrival)
                        .textFieldStyle(BorderedTextField())
                    TextField("Departure time", text: $time)
                        .textFieldStyle(BorderedTextField())
                    
                    if transfer != .bus && transfer != .car {
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
        switch transfer {
        case .plane: return "Flight number"
        case .train: return "Train number"
        case .ship: return "Ship number"
        default: return ""
        }
    }
    
    var formFilled: Bool {
        true
    }
}

struct NewTransfer_Previews: PreviewProvider {
    static var previews: some View {
        NewTransfer()
    }
}
