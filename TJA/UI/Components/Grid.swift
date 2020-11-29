//
//  Grid.swift
//  TJA
//
//  Created by Miron Rogovets on 29.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct Grid<Content: View, T: Hashable>: View {
    
    private let columns: Int
    private var list: [[T]] = []
    private let content: (T) -> Content
    private let vSpacing: CGFloat?
    private let hSpacing: CGFloat?
    
    init(
        columns: Int,
        list: [T],
        vSpacing: CGFloat? = nil,
        hSpacing: CGFloat? = nil,
        @ViewBuilder content:@escaping (T) -> Content
    ) {
        self.columns = columns
        self.content = content
        self.vSpacing = vSpacing
        self.hSpacing = hSpacing
        self.setupList(list)
    }
    
    private mutating func setupList(_ list: [T]) {
        var column = 0
        var columnIndex = 0
        
        for object in list {
            if columnIndex < self.columns {
                if columnIndex == 0 {
                    self.list.insert([object], at: column)
                    columnIndex += 1
                } else {
                    self.list[column].append(object)
                    columnIndex += 1
                }
            } else {
                column += 1
                self.list.insert([object], at: column)
                columnIndex = 1
            }
        }
    }
    
    var body: some View {
        VStack(spacing: vSpacing) {
            ForEach(0 ..< self.list.count, id: \.self) { i  in
                HStack(spacing: hSpacing) {
                    ForEach(self.list[i], id: \.self) { object in
                        self.content(object)
                    }.frame(maxWidth: .infinity)
                }
            }
        }
    }
}

struct Grid_Previews: PreviewProvider {
    static var previews: some View {
        
        let items: [WishItem] = [
            .breakfast, .lunch, .dinner, .bar,
            .gallery, .sightseeng, .museums, .fun
        ]
        
        Grid(columns: 2, list: items, vSpacing: 25) { wish in
            ShadowImage(name: wish.image)
                .frame(width: 128, height: 128)
                
        }
    }
}
