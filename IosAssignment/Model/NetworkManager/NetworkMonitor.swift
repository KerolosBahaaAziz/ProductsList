//
//  NetworkMonitor.swift
//  IosAssignment
//
//  Created by Kerlos on 11/05/2025.
//

import Foundation
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)

    private(set) var isConnected: Bool = false
    private var observers: [(Bool) -> Void] = []

    private init() {}

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            let connected = (path.status == .satisfied)
            guard let self = self else { return }

            if self.isConnected != connected {
                self.isConnected = connected
                DispatchQueue.main.async {
                    self.notifyObservers(connected)
                }
            }
        }
        monitor.start(queue: queue)
    }

    func addObserver(_ observer: @escaping (Bool) -> Void) {
        observers.append(observer)
    }

    private func notifyObservers(_ status: Bool) {
        for observer in observers {
            observer(status)
        }
    }
}



