//
//  EventSearchViewModel.swift
//  TJA
//
//  Created by Miron Rogovets on 14.12.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import Foundation
import Combine

class EventSearchViewModel: NSObject, ObservableObject, SearchService {
    
    var apiSession: APIService
    var inputFieldToken: AnyCancellable?
    var cancellationTokens = Set<AnyCancellable>()
    
    @Published private(set) var items = [SuggestionPlace]()
    @Published var searchText: String = ""
    @Published var event: Activity.Event = .museum
    
    private(set) var location: String = "tokyo"
    
    init(apiService: APIService = APISession.shared) {
        self.apiSession = apiService
        super.init()
    }
    
    func resetData() {
        clearStored()
        searchText = ""
        event = .museum
    }
    
    func clearStored(cancellAll: Bool = false) {
        if cancellAll {
            self.inputFieldToken?.cancel()
            self.cancellationTokens.removeAll()
        }
        self.items.removeAll(keepingCapacity: true)
    }
    
    func configure(location: String) {
        self.location = location
    }
    
    func enableSearch(_ enable: Bool) {
        self.inputFieldToken = enable ? $searchText
            .debounce(for: .milliseconds(350), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map{ (string) -> String? in
                if string.count < 2 {
                    self.items = []
                    return nil
                }
                
                return string
            }
            .compactMap{ $0 }
            .sink { (_) in
                //
            } receiveValue: { [self] (query) in
                self.search(textQuery: query)
            }
            : nil //disable search if requested
    }
    
    private func search(textQuery: String) {
        self.search(eventPlace: textQuery, in: event.queryString, for: location).sinkToResult { result in
            switch result {
            case let .failure(err):
                print("DEBUG: -- EventSearch -- Error -- \(err.localizedDescription)")
            case let .success(response):
                print("DEBUG: -- EventSearch -- Success")
                self.items = response.items //.compactMap { $0.location }
            }
        }.store(in: &cancellationTokens)
    }
}
