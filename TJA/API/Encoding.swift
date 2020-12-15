//
//  Encoding.swift
//  TJA
//
//  Created by Miron Rogovets on 15.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation


extension JSONEncoder {
    convenience init(_ strategy: DateEncodingStrategy) {
        self.init()
        self.dateEncodingStrategy = strategy
    }
}

extension String {
    func encodeUrl() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
    }
}
