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

    var isConnected: Bool = true {
        didSet {
            NotificationCenter.default.post(name: .internetStatusChanged, object: nil)
        }
    }
    private var isMonitoringStarted = false
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

    func checkConnection(completion: @escaping (Bool) -> Void) {
            if isMonitoringStarted {
                completion(isConnected)
            } else {
                startMonitoring()
                // Give it a moment to determine status
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    completion(self.isConnected)
                }
            }
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


extension Notification.Name {
    static let internetStatusChanged = Notification.Name("internetStatusChanged")
}
