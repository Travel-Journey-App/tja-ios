//
//  KeyedEncodingContainer+values.swift
//  TJA
//
//  Created by Miron Rogovets on 22.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation

extension KeyedEncodingContainer {
    mutating func encodeValues<V1: Encodable, V2: Encodable>(
        _ v1: V1,
        _ v2: V2,
        for key: Key) throws {

        var container = self.nestedUnkeyedContainer(forKey: key)
        try container.encode(v1)
        try container.encode(v2)
    }
}

extension KeyedDecodingContainer {
    func decodeValues<V1: Decodable, V2: Decodable>(
        for key: Key) throws -> (V1, V2) {

        var container = try self.nestedUnkeyedContainer(forKey: key)
        return (
            try container.decode(V1.self),
            try container.decode(V2.self)
        )
    }
}
