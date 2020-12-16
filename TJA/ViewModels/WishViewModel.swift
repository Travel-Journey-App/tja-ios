//
//  WishViewModel.swift
//  TJA
//
//  Created by Miron Rogovets on 14.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation
import Combine

class WishViewModel: NSObject, ObservableObject, SearchService {
    
    let wish: WishItem
    let location: Location
    var apiSession: APIService
    var cancellationToken: AnyCancellable?
    
    @Published var items = [SuggestionPlace]()
    @Published var locations = [Place<SuggestionPlace>]()
    
    init(wish: WishItem, location: Location, apiService: APIService) {
        self.wish = wish
        self.location = location
        self.apiSession = apiService
    }
    
    func fetchItems() {
        self.cancellationToken = self.search(wish: wish, for: location.placeName)
            .sinkToResult { result in
                switch result {
                case let .failure(err):
                    print("DEBUG: -- WishItems -- Error -- \(err.localizedDescription)")
                case let .success(response):
                    print("DEBUG: -- WishItems -- Success")
                    self.items = response.items.sorted(by: { $0 > $1 })
                }
            }
    }
    
    func updateLocations() {
        locations = items.compactMap { Place<SuggestionPlace>($0) }
    }
}
