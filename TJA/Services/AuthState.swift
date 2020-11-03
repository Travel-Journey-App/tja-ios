//
//  AuthState.swift
//  TJA
//
//  Created by Miron Rogovets on 03.11.2020.
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
    }
    
    func restoreSession() {
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
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
    }
    
    private func handleSignUpWith(email: String, password: String) {
        // TODO: Update with API call
        self.currentUser = User(name: email, email: email)
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
        } else {
            print("DEBUG: -- Google Sign In -- Error in getting email & username")
        }
        
    }
}
