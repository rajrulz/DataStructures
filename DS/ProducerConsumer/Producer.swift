//
//  Producer.swift
//  DS
//
//  Created by Rajneesh Biswal on 08/07/21.
//

import Foundation

//class MessageProducer: Producer {
//    private var serialQ = DispatchQueue(label: "com.ds.producer")
//
//    let messageQueue = MessageQueue.shared
//    func produce(_ message: TransferableMessage) {
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        if let message = message as? Encodable,
//           let jsonData = try? JSONEncoder().encode(message) {
//            serialQ.sync { [weak self] in
//                self?.messageQueue.enqueue(message)
//            }
//        }
//    }
//}
//
