//
//  NetworkMonitor.swift
//  TJA
//
//  Created by Miron Rogovets on 29.10.2020.
//

import Foundation
import Network


class NetworkMonitor: ObservableObject {
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue.global(qos: .background)
    
    @Published var connected: Bool = false
    
    init() {
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                OperationQueue.main.addOperation { self.connected = true }
            } else {
                OperationQueue.main.addOperation { self.connected = false }
            }
        }
    }
}
