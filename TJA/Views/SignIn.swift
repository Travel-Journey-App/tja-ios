//
//  SignIn.swift
//  TJA
//
//  Created by Miron Rogovets on 19.10.2020.
//

import SwiftUI

struct SignIn: View {
    
    @EnvironmentObject var userData: UserData
    @State var showingSignUp = false
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 10) {
                // Logo image
                HStack {
                    LogoTitle()
                        .frame(width: geometry.size.width * 2 / 3, height: geometry.size.height / 4)
                    Spacer()
                }
                .padding(.bottom, 12)
                .padding(.horizontal, -10)
                
                // Title
                if !showingSignUp {
                    Text("Register".uppercased())
                        .font(.system(size: 35))
                        .fontWeight(.light)
                        .foregroundColor(Color("MainRed"))
                        .tracking(4)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 12)
                    
                } else {
                    Spacer().frame(height: 54)
                }
                
                // Text fields
                VStack(spacing: 20) {
                    TextField("Username", text: $email)
                        .textFieldStyle(BorderedTextField())
                        
                    SecureField("Password", text: $password)
                        .textFieldStyle(BorderedTextField())
                }.padding(.bottom, 2)
                
                // Forgot pass button
                if !showingSignUp {
                    HStack {
                        Spacer()
                        Button(action: {}) {
                            Text("Forgot Password")
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                                .underline()
                                .foregroundColor(.black)
                        }.padding(.bottom, 10)
                    }
                    
                } else {
                    Spacer().frame(height: 28)
                }
                
                // Sign In buttons
                HStack(spacing: 40) {
                    if showingSignUp {
                        Button(action: {
                            print("DEBUG: Return pressed")
                            self.showingSignUp = false
                            
                        }){
                            Text("Return".uppercased())
                        }
                        .buttonStyle(FilledButtonStyle(filled: true))
                    } else {
                        Button(action: {
                            print("DEBUG: LogIn pressed")
                            
                        }){
                            Text("Login".uppercased())
                        }
                        .buttonStyle(FilledButtonStyle(filled: true))
                    }
                    
                    Button(action: {
                        print("DEBUG: SignUp pressed")
                        if self.showingSignUp {
                            print("DEBUG: Signin User Up")
                        } else {
                            self.showingSignUp = true
                        }
                        
                    }){
                        Text("Sign up".uppercased())
                    }
                    .buttonStyle(FilledButtonStyle(filled: false))
                }
                .frame(maxWidth: .infinity)
                
                // Separator
                Rectangle()
                    .fill(Color("MainRed"))
                    .frame(height: 3)
                    .padding(.vertical, 10)
                
                // Google
                Button(action: {
                    print("DEBUG: Google SignUp pressed")
                    self.userData.currenUser = User(name: "Google", email: "fake@gmail.com")
                }){
                    Text("Sign Up with Google".uppercased())
                }
                .buttonStyle(FilledButtonStyle(filled: false))
            }
            .padding(.horizontal, 20)
            .frame(
                width: geometry.size.width,
                height: geometry.size.height,
                alignment: .topLeading
            )
        }
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn().environmentObject(UserData())
    }
}
