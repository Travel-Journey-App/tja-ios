//
//  PopupViewModel.swift
//  TJA
//
//  Created by Miron Rogovets on 15.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation

class PopupViewModel: NSObject, ObservableObject {
    
    @Published var dayNumber: Int? = nil
    @Published var dayIndex: Int? = nil
    @Published var activity: Activity? = nil
    
    var hasValue: Bool {
        (dayNumber != nil) && (dayIndex != nil) && (activity != nil)
    }
    
    func reset() {
        dayIndex = nil
        dayNumber = nil
        activity = nil
    }
    
    func commit(notes: String) -> Activity? {
        self.activity?.note = notes
        return self.activity
    }
}

class PopupSuggestionViewModel: NSObject, ObservableObject {
    
    @Published var selectedIndex: Int? = nil
    
    var hasValue: Bool {
        selectedIndex != nil
    }
    
    func reset() {
        selectedIndex = nil
    }
}
