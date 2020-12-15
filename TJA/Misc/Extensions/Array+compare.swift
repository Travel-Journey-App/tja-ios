//
//  Array+compare.swift
//  TJA
//
//  Created by Miron Rogovets on 15.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation


extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
