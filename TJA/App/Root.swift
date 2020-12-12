//
//  Root.swift
//  TJA
//
//  Created by Miron Rogovets on 19.10.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct Root: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    init() {
        setupApperance()
    }
    
    var body: some View {
        Group {
            if let _ = viewModel.currentUser {
                Home()
            } else {
                SignIn()
            }
        }.onAppear(perform: viewModel.restore)
    }
    
    private func setupApperance() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "MainRed")!
        ]
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "MainRed")!
        ]
        
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor(named: "MainRed")!],
            for: .normal
        )
        
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "MainRed")
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(named: "MainRed")!], for: .normal)
        
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(named: "MainRed")
    }
}

struct Root_Previews: PreviewProvider {
    static var previews: some View {
        Root().environmentObject(AuthViewModel(apiService: APISession.shared))
    }
}
