//
//  SwipeableItem.swift
//  TJA
//
//  Created by Miron Rogovets on 01.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import UIKit

struct SwipeableItem<T: Identifiable>: Identifiable {
    
    var item: T
    var offset: CGFloat
    var isSwiped: Bool
    
    var id: Int {
        item.id as? Int ?? 0
    }
}
