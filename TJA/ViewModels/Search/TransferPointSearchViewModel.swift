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
    var inputDestinationFieldToken: AnyCancellable?
    var inputArrivalFieldToken: AnyCancellable?
    var cancellationTokens = Set<AnyCancellable>()
    
    @Published private(set) var departureItems = [Location]()
    @Published private(set) var arrivalItems = [Location]()
    @Published var depSearchText: String = ""
    @Published var arrSearchText: String = ""
    @Published var transfer: Activity.Transfer = .plane
    
    private(set) var location: String = "tokyo"
    
    init(apiService: APIService = APISession.shared) {
        self.apiSession = apiService
        super.init()
        self.configureSearch()
    }
    
    func configure(location: String) {
        self.location = location
    }
    
    func clearStored(cancellAll: Bool = false) {
        if cancellAll {
            self.cancellationTokens.removeAll()
        }
        self.departureItems.removeAll(keepingCapacity: true)
        self.arrivalItems.removeAll(keepingCapacity: true)
    }
    
    private func configureSearch() {
        self.inputDestinationFieldToken = $depSearchText
            .debounce(for: .milliseconds(350), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map{ (string) -> String? in
                if string.count < 2 {
                    self.departureItems = []
                    return nil
                }
                
                return string
            }
            .compactMap{ $0 }
            .sink { (_) in
                //
            } receiveValue: { [self] (query) in
                self.search(textQuery: query, arrivalData: false)
            }
        
        self.inputArrivalFieldToken = $arrSearchText
            .debounce(for: .milliseconds(350), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map{ (string) -> String? in
                if string.count < 2 {
                    self.arrivalItems = []
                    return nil
                }
                
                return string
            }
            .compactMap{ $0 }
            .sink { (_) in
                //
            } receiveValue: { [self] (query) in
                self.search(textQuery: query, arrivalData: true)
            }
    }
    
    private func search(textQuery: String, arrivalData: Bool) {
        self.search(transferPoint: textQuery, in: self.transfer.queryString, for: location).sinkToResult { result in
            switch result {
            case let .failure(err):
                print("DEBUG: -- Search -- Error -- \(err.localizedDescription)")
            case let .success(response):
                print("DEBUG: -- Search -- Success")
                if arrivalData {
                    self.arrivalItems = response.items.compactMap { $0.location }
                } else {
                    self.departureItems = response.items.compactMap { $0.location }
                }
                
            }
        }.store(in: &cancellationTokens)
    }
}
