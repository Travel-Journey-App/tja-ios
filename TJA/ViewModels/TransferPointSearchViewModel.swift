//
//  TransferPointSearchViewModel.swift
//  TJA
//
//  Created by Miron Rogovets on 14.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation
import Combine

class TransferPointSearchViewModel: NSObject, ObservableObject, SearchService {
    
    var apiSession: APIService
    var cancellationTokens = Set<AnyCancellable>()
    
    init(apiService: APIService) {
        self.apiSession = apiService
    }
}
