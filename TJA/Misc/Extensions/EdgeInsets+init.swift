//
//  EdgeInsets+init.swift
//  TJA
//
//  Created by Miron Rogovets on 03.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI


extension EdgeInsets {
    static var zero: EdgeInsets {
        return EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    }
    
    static func vertical(_ vertical: CGFloat) -> EdgeInsets {
        return EdgeInsets(top: vertical, leading: 0, bottom: vertical, trailing: 0)
    }
    
    static func horizontal(_ horizontal: CGFloat) -> EdgeInsets {
        return EdgeInsets(top: 0, leading: horizontal, bottom: 0, trailing: horizontal)
    }
    
    static func top(_ top: CGFloat) -> EdgeInsets {
        return EdgeInsets(top: top, leading: 0, bottom: 0, trailing: 0)
    }
    
    static func bottom(_ bottom: CGFloat) -> EdgeInsets {
        return EdgeInsets(top: 0, leading: 0, bottom: bottom, trailing: 0)
    }
    
    static func leading(_ leading: CGFloat) -> EdgeInsets {
        return EdgeInsets(top: 0, leading: leading, bottom: 0, trailing: 0)
    }
    
    static func trailing(_ trailing: CGFloat) -> EdgeInsets {
        return EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: trailing)
    }
    
    static func all(_ all: CGFloat) -> EdgeInsets {
        return EdgeInsets(top: all, leading: all, bottom: all, trailing: all)
    }
}
