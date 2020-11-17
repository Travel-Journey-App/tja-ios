//
//  Account.swift
//  TJA
//
//  Created by Miron Rogovets on 10.11.2020.
//

import SwiftUI

struct Account: View {
    
    @EnvironmentObject var authState: AuthState
    
    @State var isEditing = false
    @State var calendarEnabled = UserDefaultsConfig.syncWithCalendar
    
    @State var name: String = ""
    @State var birth: Date? = nil
    @State var phone: String = ""
    
    var birthDate: String {
        if let date = birth {
            return slashedDateFormatter.string(from: date)
        } else {
            return "Birth date:"
        }
    }
    
    var dateField: some View {
        return DateField("01/01/2000", date: $birth, formatter: slashedDateFormatter)
            .font(.system(size: 18))
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 10) {
                    
                    // Account Data
                    VStack(alignment: .leading, spacing: 20) {
                        if isEditing {
                            TextField("Your Name", text: $name)
                                .font(.system(size: 18))
                                .autocapitalization(.words)
//                            TextField("01/01/2000", text: $birth)
//                                .font(.system(size: 18))
                            dateField.frame(height: 23)
                            TextField("+00000000000", text: $phone)
                                .font(.system(size: 18))
                                .keyboardType(.phonePad)
                        } else {
                            Text(authState.currentUser?.name ?? "Your Name").font(.system(size: 18))
                            Text(birthDate).font(.system(size: 18))
                            Text(authState.currentUser?.phone ?? "Phone:").font(.system(size: 18))
                        }
                        Text(authState.currentUser?.email ?? "Email:").font(.system(size: 18))
                    }.padding(.vertical, 10)
                    
                    // Separator
                    Rectangle()
                        .fill(Color("MainRed"))
                        .frame(height: 1)
                    
                    Text("Settings")
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                    
                    Toggle(isOn: $calendarEnabled.didSet { state in
                        print("DEBUG: -- Changing `Calendar Sync` to \(state)")
                        UserDefaultsConfig.syncWithCalendar = state
                    }){
                        Text("Sync with calendar").font(.system(size: 18))
                    }
                    .padding(.top, 15)
                    .padding(.bottom, 80)
                    
                    if !isEditing {
                        // Calendar button
                        Button(action: {
                            print("DEBUG: -- Open calendar button tapped")
                            guard let url = URL(string: "calshow://") else { return }
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }){
                            HStack(spacing: 20) {
                                Image(systemName: "calendar")
                                Text("Open calendar".uppercased())
                            }
                            .padding(.horizontal, 10)
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(FilledButtonStyle(filled: false))
                        
                        // Logout button
                        HStack {
                            Spacer()
                            Button(action: {
                                print("DEBUG: -- Logout button tapped")
                                self.authState.logout()
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
    }
    
    private func saveData() {
        print("DEBUG: -- Saving data")
        self.authState.updateUserProfile(name: self.name, phone: self.phone)
    }
    
    private func setFieldsData() {
        self.name = authState.currentUser?.name ?? ""
        self.phone = authState.currentUser?.phone ?? ""
    }
}


struct Account_Previews: PreviewProvider {
    static var previews: some View {
        Account().environmentObject(AuthState.shared)
    }
}
