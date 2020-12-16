//
//  Account.swift
//  TJA
//
//  Created by Miron Rogovets on 10.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct Account: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State var isEditing = false
    
    @State var name: String = ""
    @State var birth: Date? = nil
    @State var phone: String = ""
    
    var birthDate: String {
        if let date = birth {
            return slashedFormatter.string(from: date)
        } else {
            return "Birth date:"
        }
    }
    
    var dateField: some View {
        return DateField("01/01/2000", date: $birth, formatter: slashedFormatter)
            .font(.system(size: 18))
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 10) {
                    
                    // Account Data
                    VStack(alignment: .leading, spacing: 20) {
                        if isEditing {
                            TextField("Your Name:", text: $name)
                                .font(.system(size: 18))
                                .autocapitalization(.words)
                            dateField.frame(height: 23)
                            TextField("+00000000000", text: $phone)
                                .font(.system(size: 18))
                                .keyboardType(.phonePad)
                        } else {
                            Text(authViewModel.currentUser?.name ?? "Your Name:").font(.system(size: 18))
                            Text(birthDate).font(.system(size: 18))
                            Text(authViewModel.currentUser?.phone ?? "Phone:").font(.system(size: 18))
                        }
                        Text(authViewModel.currentUser?.email ?? "Email:").font(.system(size: 18))
                    }.padding(.vertical, 10)
                    
                    // Separator
                    Rectangle()
                        .fill(Color.mainRed)
                        .frame(height: 2)
                        .padding(.bottom, 40)
                    
                    if !isEditing {                        
                        // Logout button
                        HStack {
                            Spacer()
                            Button(action: {
                                print("DEBUG: -- Logout button tapped")
                                self.authViewModel.logout()
                            }) {
                                Text("Logout")
                                    .font(.system(size: 18))
                                    .fontWeight(.medium)
                                    .underline()
                                    .foregroundColor(Color(UIColor.systemRed))
                            }
                            Spacer()
                        }.padding(.vertical, 20)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
            }
            .navigationBarTitle(Text("Account".uppercased()))
            .navigationBarItems(
                leading: HStack {
                    if self.isEditing {
                        Button(
                            action: {
                                print("DEBUG: -- Cancel edit button pressed")
                                self.isEditing = false
                                self.setFieldsData()
                            },
                            label: { Image(systemName: "xmark") }
                        )
                    }
                },
                trailing: Button(
                    action: {
                        print("DEBUG: -- Nav bar button pressed -- is in editing mode = \(self.isEditing)")
                        if self.isEditing {
                            //save data
                            self.saveData()
                            self.setFieldsData()
                        }
                        self.isEditing.toggle()
                    },
                    label: { Text(isEditing ? "Save" : "Edit") })
            )
        }
        .onAppear(perform: setFieldsData)
        .resignKeyboardOnDragGesture()
//        .alert(isPresented: .constant(true)) {
//            Alert(
//                title: Text("Server is not available"),
//                message: Text("Try again?"),
//                primaryButton: .default(Text("Retry")),
//                secondaryButton: .cancel()
//            )
//        }
    }
    
    private func saveData() {
        print("DEBUG: -- Saving data")
        self.authViewModel.updateUser(name: self.name, phone: self.phone, birthDate: self.birth) {
            self.setFieldsData()
        }
    }
    
    private func setFieldsData() {
        self.name = authViewModel.currentUser?.name ?? ""
        self.phone = authViewModel.currentUser?.phone ?? ""
        self.birth = authViewModel.currentUser?.birth
    }
}


struct Account_Previews: PreviewProvider {
    static var previews: some View {
        Account().environmentObject(AuthViewModel(apiService: APISession.shared))
    }
}
