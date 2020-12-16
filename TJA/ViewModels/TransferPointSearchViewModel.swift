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
    var cancellationTokensD = Set<AnyCancellable>()
    var cancellationTokensA = Set<AnyCancellable>()
    
    @Published private(set) var depItems = [Location]()
    @Published private(set) var arrItems = [Location]()
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
    
    func clearStoredDept(cancellAll: Bool = false) {
        if cancellAll {
            self.cancellationTokensD.removeAll()
        }
        self.depItems.removeAll(keepingCapacity: true)
        
    }
    
    func clearStoredArr(cancellAll: Bool = false) {
        if cancellAll {
            self.cancellationTokensA.removeAll()
        }
        self.arrItems.removeAll(keepingCapacity: true)
        
    }
    
    private func configureSearch() {
        $depSearchText
            .debounce(for: .milliseconds(350), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map{ (string) -> String? in
                if string.count < 2 {
                    self.depItems = []
                    return nil
                }
                
                return string
            }
            .compactMap{ $0 }
            .sink { (_) in
                //
            } receiveValue: { [self] (query) in
                self.depSearch(textQuery: query)
            }.store(in: &cancellationTokensD)
        
        $arrSearchText
            .debounce(for: .milliseconds(350), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map{ (string) -> String? in
                if string.count < 2 {
                    self.arrItems = []
                    return nil
                }
                
                return string
            }
            .compactMap{ $0 }
            .sink { (_) in
                //
            } receiveValue: { [self] (query) in
                self.arrSearch(textQuery: query)
            }.store(in: &cancellationTokensA)
    }
    
    private func arrSearch(textQuery: String) {
        self.search(transferPoint: textQuery, in: self.transfer.queryString, for: location).sinkToResult { result in
            switch result {
            case let .failure(err):
                print("DEBUG: -- DeptCitySearch -- Error -- \(err.localizedDescription)")
            case let .success(response):
                print("DEBUG: -- DeptCitySearch -- Success")
                self.arrItems = response.items.compactMap { $0.location }
            }
        }.store(in: &cancellationTokensD)
    }
    
    private func depSearch(textQuery: String) {
        self.search(transferPoint: textQuery, in: self.transfer.queryString, for: location).sinkToResult { result in
            switch result {
            case let .failure(err):
                print("DEBUG: -- ArrCitySearch -- Error -- \(err.localizedDescription)")
            case let .success(response):
                print("DEBUG: -- ArrCitySearch -- Success")
                self.depItems = response.items.compactMap { $0.location }
            }
        }.store(in: &cancellationTokensA)
    }
}
