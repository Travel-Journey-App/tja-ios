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
    let destination: String
    var apiSession: APIService
    var cancellationToken: AnyCancellable?
    
    @Published var items = [SuggestionPlace]()
    
    init(wish: WishItem, destination: String, apiService: APIService) {
        self.wish = wish
        self.destination = destination
        self.apiSession = apiService
    }
    
    func fetchItems() {
        self.cancellationToken = self.search(wish: wish, for: destination)
            .sinkToResult { result in
                switch result {
                case let .failure(err):
                    print("DEBUG: -- WishItems -- Error -- \(err.localizedDescription)")
                case let .success(response):
                    print("DEBUG: -- WishItems -- Success")
                    self.items = response.items
                }
            }
    }
}
