//
//  SegmentedContainer.swift
//  TJA
//
//  Created by Miron Rogovets on 30.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct SegmentedContainer<ListContent: View, MapContent: View>: View {
    
    enum Tab: Int {
        case list, map
        
        var icon: String {
            switch self {
            case .list: return "list.bullet"
            case .map: return "mappin.circle"
            }
        }
    }
    
    @State var selectedTab = Tab.list
    private let list: () -> ListContent
    private let map: () -> MapContent
    
    init(@ViewBuilder list: @escaping () -> ListContent, @ViewBuilder map: @escaping () -> MapContent) {
        self.list = list
        self.map = map
    }
    
    var body: some View {
        VStack {
            // Segment control
            Picker("", selection: $selectedTab) {
                Image(systemName: Tab.list.icon)
                    .tag(Tab.list)
                    .frame(width: 24, height: 24, alignment: .center)
                Image(systemName: Tab.map.icon)
                    .tag(Tab.map)
                    .frame(width: 24, height: 24, alignment: .center)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 10)
            .padding(.top, 10)
            
            // Content
            contentSection
        }
    }
    
    var contentSection: some View {
        switch self.selectedTab {
        case .list: return self.list().toAnyView()
        case .map: return  self.map().toAnyView()
        }
    }
}
