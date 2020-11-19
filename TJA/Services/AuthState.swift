//
//  AuthState.swift
//  TJA
//
//  Created by Miron Rogovets on 03.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import UIKit
import GoogleSignIn


class AuthState: NSObject, ObservableObject {
    
    @Published var currentUser: User?
    
    static let shared = AuthState()
    
    func login(with provider: AuthProvider) {
        switch provider {
        case .google:
            handleSignInWithGoogle()
        case let .emailAndPassword(email, password):
            handleSignInWith(email: email, password: password)
        }
    }
    
    func logout() {
        GIDSignIn.sharedInstance()?.signOut()
        self.currentUser = nil
        // reset provider to prevent auto login
        // clear auth token & current user
        UserDefaultsConfig.googleProviderWasUsed = false
    }
    
    func restoreSession() {
        if UserDefaultsConfig.googleProviderWasUsed {
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        } else {
            // try to restore regular session
        }
    }
    
    func updateUserProfile(name: String, phone: String) {
        guard let user = currentUser else { return }
        guard !name.isEmpty else { return }
        currentUser = User(name: name, email: user.email, phone: phone.isEmpty ? nil : phone)
    }
    
    func configureGoogleSignIn(controller: UIViewController?) {
        GIDSignIn.sharedInstance()?.clientID = googleId
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = controller
    }
    
    private func handleSignInWithGoogle() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    private func handleSignInWith(email: String, password: String) {
        // TODO: Update with API call
        self.currentUser = User(name: email, email: email)
        UserDefaultsConfig.googleProviderWasUsed = false
    }
    
    private func handleSignUpWith(email: String, password: String) {
        // TODO: Update with API call
        self.currentUser = User(name: email, email: email)
        UserDefaultsConfig.googleProviderWasUsed = false
    }
}

extension AuthState: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("DEBUG: -- Google Sign In -- The user has not signed in before or they have since signed out.")
            } else {
                print("DEBUG: -- Google Sign In -- \(error.localizedDescription)")
            }
            return
        }
        // If the previous `error` is null, then the sign-in was succesful
        print("DEBUG: -- Google Sign In -- Successful sign-in!")
        print("DEBUG: -- Google Sign In -- Token: \(user.authentication.accessToken)")
        if let name = user.profile.name, let email = user.profile.email {
            print("DEBUG: -- Google Sign In -- Email: \(email), Username: \(name)")
            self.currentUser = User(name: name, email: email)
            UserDefaultsConfig.googleProviderWasUsed = true
        } else {
            print("DEBUG: -- Google Sign In -- Error in getting email & username")
        }
        
    }
}
