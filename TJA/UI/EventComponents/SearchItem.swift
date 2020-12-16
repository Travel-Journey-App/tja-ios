//
//  SearchItem.swift
//  TJA
//
//  Created by Miron Rogovets on 17.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct SearchItem: View {
    
    var title: String
    var description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color(UIColor.label))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(description)
                .font(.system(size: 10, weight: .light))
                .foregroundColor(Color(UIColor.label))
                .lineLimit(nil)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.all, 8)
        .frame(height: 90)
        .background(
            Color(UIColor.systemBackground)
                .shadow(color: .black, radius: 4))
        .overlay(Rectangle().stroke(Color.mainRed, lineWidth: 1))
    }
}

struct SimpleSearchItem: View {
    
    var title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(Color(UIColor.label))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .frame(height: 40)
            .background(Color(UIColor.systemBackground))
            .overlay(Rectangle().stroke(Color(UIColor.opaqueSeparator), lineWidth: 1))
    }
}

struct SearchItem_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            VStack(spacing: 6) {
                SearchItem(title: "Title 1", description: "Description")
                SearchItem(title: "Title 2", description: "Description")
                SearchItem(title: "Title 3", description: "Description")
            }
            VStack(spacing: 0) {
                SimpleSearchItem(title: "Title 1")
                SimpleSearchItem(title: "Title 2")
                SimpleSearchItem(title: "Title 3")
            }
        }
    }
}
