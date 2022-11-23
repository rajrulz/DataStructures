//
//  Producer.swift
//  DS
//
//  Created by Rajneesh Biswal on 08/07/21.
//

import Foundation

protocol Producer {
    init(queue: Queue)
    func produceMessage(_ message: TransferableMessage) // continuously produce messages
}

var semaphore = DispatchSemaphore(value: 1)

class ProducerConsumerContainer {
    public var producer: Producer
    public var consumer: Consumer
    private let messagingQueue: Queue
    static let shared = ProducerConsumerContainer()

    private init() {
        self.messagingQueue = SharedQueue(size: 2)
        self.producer = MessageProducer(queue: messagingQueue)
        self.consumer = MessageConsumer(queue: messagingQueue)
    }
}

class MessageProducer: Producer {
    private let serialQueue = DispatchQueue(label: "com.producer.serial")
    private let messagingQ: Queue
    required init(queue: Queue) {
        self.messagingQ = queue
    }
    
    func produceMessage(_ message: TransferableMessage) {
        serialQueue.sync { [weak self] in
            guard let self = self else { return }
            do {
                try self.messagingQ.enqueue(message)
                print("\(self) produced message \(message)")
                semaphore.signal()
            } catch {
                semaphore.wait()
            }
        }
    }
}
