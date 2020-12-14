//
//  DestinationSearchViewModel.swift
//  TJA
//
//  Created by Miron Rogovets on 14.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation
import Combine

class DestinationSearchViewModel: NSObject, ObservableObject, SearchService {
    
    var apiSession: APIService
    
    @Published var items = [Location]()
    
    init(apiService: APIService) {
        self.apiSession = apiService
    }
}
