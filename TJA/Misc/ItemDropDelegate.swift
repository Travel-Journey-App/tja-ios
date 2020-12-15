//
//  ItemDropDelegate.swift
//  TJA
//
//  Created by Miron Rogovets on 04.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct ItemDropDelegate: DropDelegate {
    
    var day: Int
    @Binding var active: Int
    @Binding var activeSheet: DaysContainer.ActiveSheet?
    
    func performDrop(info: DropInfo) -> Bool {
        print("DEBUG: -- DropDelegate -- Dropped at day: \(day) & location: \(info.location)")
        activeSheet = .wish
        return true
    }
    
    func dropEntered(info: DropInfo) {
        print("DEBUG: -- DropDelegate entered -- day: \(day) -- location: \(info.location)")
        self.active = day
    }
    
    func validateDrop(info: DropInfo) -> Bool {
        return info.hasItemsConforming(to: ["public.item-source"])
    }
    
    func dropExited(info: DropInfo) {
        print("DEBUG: -- DropDelegate exited")
        self.active = -1
    }
}
