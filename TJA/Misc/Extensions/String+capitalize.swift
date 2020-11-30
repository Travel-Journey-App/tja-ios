//
//  String+capitalize.swift
//  TJA
//
//  Created by Miron Rogovets on 01.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation

extension String {
    func capitalizedFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizedFirstLetter()
    }
}
