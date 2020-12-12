//
//  AuthViewModel.swift
//  TJA
//
//  Created by Miron Rogovets on 11.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import UIKit
import GoogleSignIn
import Combine

class AuthViewModel: NSObject, ObservableObject, AuthService {
    
    var apiSession: APIService
    var cancellationToken: AnyCancellable?
    
    @Published var currentUser: User?
    
    init(apiService: APIService) {
        self.apiSession = apiService
    }
    
    func login(with provider: AuthProvider) {
        switch provider {
        case let .emailAndPassword(email, password):
            handleSignInWith(email: email, pass: password)
        case .google:
            GIDSignIn.sharedInstance()?.signIn()
        }
    }
    
    func signup(with provider: AuthProvider) {
        switch provider {
        case let .emailAndPassword(email, password):
            handleSignUpWith(email: email, pass: password)
        case .google:
            GIDSignIn.sharedInstance()?.signIn()
        }
    }
    
    func logout() {
        if UserDefaultsConfig.googleProviderWasUsed {
            GIDSignIn.sharedInstance()?.signOut()
        }
        self.currentUser = nil
        UserDefaultsConfig.googleProviderWasUsed = false
        UserDefaultsConfig.authToken = nil
    }
    
    func restore() {
        
        let onError: (() -> ()) = {
            UserDefaultsConfig.authToken = nil
            UserDefaultsConfig.googleProviderWasUsed = false
            self.currentUser = nil
        }
        
        
        if !UserDefaultsConfig.googleProviderWasUsed {
            // try to restore regular session
            if let token = UserDefaultsConfig.authToken {
                print("DEBUG: -- AuthToken found -- restoring session...")
                
                self.cancellationToken = self.refresh()
                    .sinkToResult { result in
                        switch result {
                        case let .failure(err):
                            print("DEBUG: -- SignIn -- Error -- \(err.localizedDescription)")
                            onError()
                        case let .success(response):
                            if let err = response.getError() {
                                print("DEBUG: -- SignIn -- Response error -- \(err.localizedDescription)")
                                onError()
                            }
                            print("DEBUG: -- SignIn -- Success -- \(response.body)")
                            UserDefaultsConfig.authToken = response.body?.secret
                            UserDefaultsConfig.googleProviderWasUsed = false
                            self.currentUser = response.body?.user
                        }
                    }
                
            } else {
                print("DEBUG: -- AuthToken not found -- falling back to AuthView")
                onError()
            }
        } else {
            // try to restore Google session
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        }
    }
    
    func configureGoogleSignIn(controller: UIViewController?) {
        GIDSignIn.sharedInstance()?.clientID = googleId
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = controller
    }
    
    private func handleSignInWith(email: String, pass: String) {
        self.cancellationToken = self.login(email: email, password: pass)
            .sinkToResult { result in
                switch result {
                case let .failure(err):
                    print("DEBUG: -- SignIn -- Error -- \(err.localizedDescription)")
                case let .success(response):
                    if let err = response.getError() {
                        print("DEBUG: -- SignIn -- Response error -- \(err.localizedDescription)")
                    }
                    print("DEBUG: -- SignIn -- Success -- \(response.body)")
                    UserDefaultsConfig.authToken = response.body?.secret
                    UserDefaultsConfig.googleProviderWasUsed = false
                    self.currentUser = response.body?.user
                }
            }
    }
    
    private func handleSignUpWith(email: String, pass: String) {
        self.cancellationToken = self.signup(email: email, password: pass)
            .sinkToResult { result in
                switch result {
                case let .failure(err):
                    print("DEBUG: -- SignIn -- Error -- \(err.localizedDescription)")
                case let .success(response):
                    if let err = response.getError() {
                        print("DEBUG: -- SignIn -- Response error -- \(err.localizedDescription)")
                    }
                    print("DEBUG: -- SignIn -- Success -- \(response.body)")
                    UserDefaultsConfig.authToken = response.body?.secret
                    UserDefaultsConfig.googleProviderWasUsed = false
                    self.currentUser = response.body?.user
                }
            }
    }
}

extension AuthViewModel: GIDSignInDelegate {
    
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
        if let token = user.authentication.idToken {
            print("DEBUG: -- Google Sign In -- idToken: \(token)")
            
            // TODO: api call
            
            UserDefaultsConfig.googleProviderWasUsed = true
        }
    }
}
