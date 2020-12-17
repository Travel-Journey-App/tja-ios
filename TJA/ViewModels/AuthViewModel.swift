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
    @Published var state: Loadable<Bool> = .idle
    
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
    
    func updateUser(name: String?, phone: String?, birthDate: Date?, onComplete: (() -> ())? = nil) {
        
        let onError: (() -> ()) = {
            if let email = self.currentUser?.email {
                self.currentUser = User(email: email, name: name, phone: phone, birth: birthDate)
            }
        }
        
        self.cancellationToken = update(name: name, phone: phone, birthDate: birthDate)
            .sinkToResult { result in
                switch result {
                case let .failure(err):
                    print("DEBUG: -- UpdateUser -- Error -- \(err.localizedDescription)")
                    onError()
                    onComplete?()
                case let .success(response):
                    if let err = response.getError() {
                        print("DEBUG: -- UpdateUser -- Response error -- \(err.localizedDescription)")
                        onError()
                        onComplete?()
                    }
                    print("DEBUG: -- UpdateUser -- Success -- \(response.body)")
                    UserDefaultsConfig.authToken = response.body?.secret
                    self.currentUser = response.body?.user
                    onComplete?()
                }
            }
    }
    
    func restore() {
        
        if state.isIdle { self.state = .loading }
        
        let onError: (() -> ()) = {
            UserDefaultsConfig.authToken = nil
            UserDefaultsConfig.googleProviderWasUsed = false
            self.currentUser = nil
            self.state = .loaded(false)
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
                            self.state = .loaded(true)
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
                    self.state = .loaded(false)
                case let .success(response):
                    if let err = response.getError() {
                        print("DEBUG: -- SignIn -- Response error -- \(err.localizedDescription)")
                        self.state = .loaded(false)
                    }
                    print("DEBUG: -- SignIn -- Success -- \(response.body)")
                    UserDefaultsConfig.authToken = response.body?.secret
                    UserDefaultsConfig.googleProviderWasUsed = false
                    self.currentUser = response.body?.user
                    self.state = .loaded(true)
                }
            }
    }
    
    private func handleSignUpWith(email: String, pass: String) {
        self.cancellationToken = self.signup(email: email, password: pass)
            .sinkToResult { result in
                switch result {
                case let .failure(err):
                    print("DEBUG: -- SignIn -- Error -- \(err.localizedDescription)")
                    self.state = .loaded(false)
                case let .success(response):
                    if let err = response.getError() {
                        print("DEBUG: -- SignIn -- Response error -- \(err.localizedDescription)")
                        self.state = .loaded(false)
                    }
                    print("DEBUG: -- SignIn -- Success -- \(response.body)")
                    UserDefaultsConfig.authToken = response.body?.secret
                    UserDefaultsConfig.googleProviderWasUsed = false
                    self.currentUser = response.body?.user
                    self.state = .loaded(true)
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
            self.state = .loaded(false)
            return
        }
        // If the previous `error` is null, then the sign-in was succesful
        if let token = user.authentication.idToken {
            #if DEBUG
            print("DEBUG: -- Google Sign In -- idToken: \(token)")
            #endif
            
            // TODO: api call
            self.cancellationToken = self.oauth(idToken: token)
                .sinkToResult { result in
                    switch result {
                    case let .failure(err):
                        print("DEBUG: -- Google OAuth -- Error -- \(err.localizedDescription)")
                        self.state = .loaded(false)
                    case let .success(response):
                        if let err = response.getError() {
                            print("DEBUG: -- Google OAuth -- Response error -- \(err.localizedDescription)")
                            self.state = .loaded(false)
                        }
                        #if DEBUG
                        print("DEBUG: -- Google OAuth -- Success -- \(response.body)")
                        #endif
                        UserDefaultsConfig.authToken = response.body?.secret
                        UserDefaultsConfig.googleProviderWasUsed = true
                        self.currentUser = response.body?.user
                        self.state = .loaded(true)
                    }
                }
        }
    }
}
