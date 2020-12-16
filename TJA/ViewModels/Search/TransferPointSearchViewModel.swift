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
    var inputFieldToken: AnyCancellable?
    var cancellationTokens = Set<AnyCancellable>()
    
    @Published private(set) var departureItems = [Location]()
    @Published private(set) var arrivalItems = [Location]()
    @Published var depSearchText: String = ""
    @Published var arrSearchText: String = ""
    @Published var transfer: Activity.Transfer = .plane
    
    private(set) var target: Activity.Transfer.Direction = .departure
    private(set) var location: String = "tokyo"
    
    init(apiService: APIService = APISession.shared) {
        self.apiSession = apiService
        super.init()
    }
    
    func configure(location: String) {
        self.location = location
    }
    
    func configure(target: Activity.Transfer.Direction) {
        self.target = target
    }
    
    func resetData() {
        clearStored()
        depSearchText = ""
        arrSearchText = ""
        transfer = .plane
    }
    
    func clearStored(cancellAll: Bool = false) {
        if cancellAll {
            self.cancellationTokens.removeAll()
        }
        self.departureItems.removeAll(keepingCapacity: true)
        self.arrivalItems.removeAll(keepingCapacity: true)
    }
    
    func enableSearch(_ enable: Bool) {
        switch self.target {
        case .departure:
            self.inputFieldToken = enable ? $depSearchText
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
                : nil //disable search if requested
        case .arrival:
            self.inputFieldToken = enable ? $arrSearchText
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
                : nil //disable search if requested
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
