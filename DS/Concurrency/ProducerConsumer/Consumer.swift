//
//  Consumer.swift
//  DS
//
//  Created by Rajneesh Biswal on 08/07/21.
//

import Foundation

protocol Consumer {
    init(queue: Queue)
    func consume()
    func addObserver(_ observer: Observer)
}

protocol Observer {
    var childObservers: [Observer] { set get }
    func didReceiveMessage(_ message: TransferableMessage)
    func addObserver(_ observer: Observer)
}

extension Observer {
    func didReceiveMessage(_ message: TransferableMessage) {
        print("\(self) consumed message \(message)")
        for consumer in childObservers {
            DispatchQueue.global().async {
                consumer.didReceiveMessage(message)
            }
        }
    }
}

class MessageConsumer: Consumer {
    private let messagingQ: Queue
    private var childConsumers: [Observer] = []
    required init(queue: Queue) {
        self.messagingQ = queue
        self.consume()
    }
    
    func consume() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            while true {
                do {
                    let message = try self.messagingQ.dequeue()
                    semaphore.signal()
                    self.broadcastMessage(message)
                } catch {
                    semaphore.wait()
                }
            }
        }
    }

    func addObserver(_ observer: Observer) {
        childConsumers.append(observer)
    }

    private func broadcastMessage(_ message: TransferableMessage) {
        for consumer in childConsumers {
            DispatchQueue.global().async {
                consumer.didReceiveMessage(message)
            }
        }
    }
}
