//
//  Consumer.swift
//  DS
//
//  Created by Rajneesh Biswal on 08/07/21.
//

import Foundation

//class MessageConsumer: Consumer {
//    let messageQueue = MessageQueue.shared
//
//    let queue = DispatchQueue(label: "com.ds.consumer", attributes: .concurrent)
//    var subscribers: [MessageSubscriber] = []
//    init() {
//        observerQueue()
//    }
//
//    private func observerQueue() {
//        while true {
//            if !messageQueue.isEmpty,
//               let message = messageQueue.dequeue() {
//                consume(message)
//            }
//        }
//    }
//
//    func consume(_ message: Codable) {
//        for subscriber in subscribers {
//            queue.async { [weak subscriber] in
//                subscriber?.didReceiveMessage(message)
//            }
//        }
//    }
//}
//
//protocol Subscriber {
//    associatedtype ConsumableMessage
//    func didReceiveMessage(_ message: ConsumableMessage)
//    func addDependentSubscriber(_ subscriber: Self)
//}
//
//class MessageSubscriber: Subscriber {
//    typealias ConsumableMessage = Message
//    private var subscribers: [MessageSubscriber] = []
//    func didReceiveMessage(_ message: Message) {
//        print(message.mssgID)
//        print(message.mssgText)
//        for subscriber in subscribers {
//            DispatchQueue.global(qos: .userInitiated).async { [weak subscriber] in
//                subscriber?.didReceiveMessage(message)
//            }
//        }
//    }
//
//    func addDependentSubscriber(_ subscriber: MessageSubscriber) {
//        self.subscribers.append(subscriber)
//    }
//}
