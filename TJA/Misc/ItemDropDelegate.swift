//
//  ItemDropDelegate.swift
//  TJA
//
//  Created by Miron Rogovets on 04.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct ItemDropDelegate: DropDelegate {
    
    @Binding var active: Int
    @Binding var activeSheet: DaysContainer.ActiveSheet?
    
    func performDrop(info: DropInfo) -> Bool {
        print("DEBUG: -- DropDelegate -- location: \(info.location)")
        activeSheet = .manual
        return true
    }
    
    func dropEntered(info: DropInfo) {
        print("DEBUG: -- DropDelegate entered -- location: \(info.location)")
        self.active = 1
    }
    
    func validateDrop(info: DropInfo) -> Bool {
        return info.hasItemsConforming(to: ["public.item-source"])
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return nil
    }
    
    func dropExited(info: DropInfo) {
        print("DEBUG: -- DropDelegate exited")
        self.active = 0
    }
}
