//
//  Swipeable.swift
//  TJA
//
//  Created by Miron Rogovets on 01.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI

struct Swipeable<Content: View, T: Identifiable>: View {
    
    private let content: (T) -> Content
    @Binding var item: SwipeableItem<T>
    var onSwiped: (() -> ())?
    
    init(
        _ item: Binding<SwipeableItem<T>>,
        onSwiped: (() -> ())? = nil,
        @ViewBuilder content:@escaping (T) -> Content
    ) {
        self._item = item
        self.onSwiped = onSwiped
        self.content = content
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemRed)
            
            // Button
            HStack {
                Spacer()
                Button(action: {
                    withAnimation(.easeIn){ self.onSwiped?() }
                }) {
                    
                    Image(systemName: "trash")
                        .font(.title)
                        .foregroundColor(.white)
                        // default Frame....
                        .frame(width: 50)
                    //.frame(width: 24, height: 24, alignment: .center)
                }
            }
            
            self.content(self.item.item)
                .background(Color(UIColor.systemBackground))
                .contentShape(Rectangle())
                .offset(x: item.offset)
                .gesture(
                    DragGesture(minimumDistance: 20, coordinateSpace: .local)
                        .onChanged(onChanged(value:))
                        .onEnded(onEnd(value:)))
        }
    }
    
    func onChanged(value: DragGesture.Value){
        
        if value.translation.width < 0{
            
            if item.isSwiped{
                item.offset = value.translation.width - 90
            }
            else{
                item.offset = value.translation.width
            }
        }
    }
    
    func onEnd(value: DragGesture.Value){
        
        withAnimation(.easeOut){
            
            if value.translation.width < 0{
                
                // Checking...
                
                if -value.translation.width > UIScreen.main.bounds.width / 2{
                    
                    item.offset = -1000
                    self.onSwiped?()
                }
                else if -item.offset > 50{
                    // updating is Swipng...
                    item.isSwiped = true
                    item.offset = -90
                }
                else{
                    item.isSwiped = false
                    item.offset = 0
                }
            }
            else{
                item.isSwiped = false
                item.offset = 0
            }
        }
    }
}

struct Swipeable_Previews: PreviewProvider {
    static var previews: some View {
        let trip = Trip(
            id: 0,
            image: URL(string: "https://images.unsplash.com/photo-1605546741978-365c16813d0c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1575&q=80"),
            name: "New Year",
            startDate: Date().addingTimeInterval(60*60*24*2),
            endDate: Date().addingTimeInterval(60*60*24*6),
            location: nil)
        var swipeable = SwipeableItem<Trip>(item: trip, offset: 0, isSwiped: false)
        var item = Binding<SwipeableItem<Trip>>(
            get: { return swipeable },
            set: { swipeable = $0 }
        )
        Swipeable(item) { trip in
            TripCell(trip: trip)
        }.frame(height: 84)
    }
}
