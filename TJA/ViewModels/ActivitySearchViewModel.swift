//
//  ActivitySearchViewModel.swift
//  TJA
//
//  Created by Miron Rogovets on 14.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation
import Combine

class ActivitySearchViewModel: NSObject, ObservableObject, SearchService {
    
    var apiSession: APIService
    
    init(apiService: APIService) {
        self.apiSession = apiService
    }
}
