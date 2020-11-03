//
//  SignIn.swift
//  TJA
//
//  Created by Miron Rogovets on 19.10.2020.
//

import SwiftUI

struct SignIn: View {
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @EnvironmentObject var authState: AuthState
    
    @State var showingSignUp = false
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 10) {
                // Logo image
                if keyboard.currentHeight == 0 {
                    HStack {
                        LogoTitle()
                            .frame(width: geometry.size.width * 2 / 3, height: geometry.size.height / 4)
                        Spacer()
                    }
                    .padding(.bottom, 12)
                    .padding(.horizontal, -10)
                } else {
                    Spacer().frame(height: 30)
                }
                
                
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
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
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
                                .foregroundColor(Color(UIColor.label))
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
                            self.resetTextFields()
                            self.showingSignUp = false
                            
                        }){
                            Text("Return".uppercased())
                        }
                        .buttonStyle(FilledButtonStyle(filled: true))
                    } else {
                        Button(action: {
                            print("DEBUG: LogIn pressed")
                            self.authState.login(with: .emailAndPassword(email: email, password: password))
                        }){
                            Text("Login".uppercased())
                        }
                        .buttonStyle(FilledButtonStyle(filled: true))
                    }
                    
                    Button(action: {
                        print("DEBUG: SignUp pressed")
                        if self.showingSignUp {
                            print("DEBUG: Signin User Up")
                            //TODO: Call sign up later
                            self.authState.login(with: .emailAndPassword(email: email, password: password))
                        } else {
                            self.resetTextFields()
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
                    self.authState.login(with: .google)
                }){
                    HStack(spacing: 20) {
                        Image("google")
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text( showingSignUp ?
                            "Sign Up with Google".uppercased() :
                                "Sign In with Google".uppercased()
                        )
                        Spacer() // for leading alignment
                    }
                    .padding(.horizontal, 10)
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(FilledButtonStyle(filled: false))
            }
            .padding(.horizontal, 20)
            .frame(
                width: geometry.size.width,
                height: geometry.size.height,
                alignment: .topLeading
            )
            .gesture(DragGesture().onChanged { _ in
                print("DEBUG: -- Drag Gesture -- Hide keyboard")
                self.hideKeyboard()
            })
        }
    }
    
    func resetTextFields() {
        self.email = ""
        self.password = ""
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn().environmentObject(AuthState.shared)
    }
}
