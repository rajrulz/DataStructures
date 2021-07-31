//
//  Queue.swift
//  DS
//
//  Created by Rajneesh Biswal on 08/07/21.
//
//import Combine
//import Foundation
////@inlinable public func receive<S>(subscriber: S) where Output == S.Input, Failure == S.Failure, S : Subscriber
//
//protocol Producer {
//    func produce(_ message: TransferableMessage & Encodable)
//}
//
//protocol TransferableMessage {
//    var Id: String { set get }
//}
//
//protocol Queue {
//    func enqueue(_ message: Data)
//    func dequeue() -> Data?
//    var isEmpty: Bool { get }
//}
//
//protocol Consumer {
//    func consume(_ message: TransferableMessage & Decodable)
//}
//
//struct Message: TransferableMessage {
//    var Id: String
//    var mssgText: String
//
//    enum CodingKeys: String, CodingKey {
//        case Id
//        case mssgText
//    }
//}
//
//class MessageQueue: Queue {
//    private var array: [TransferableMessage] = []
//
//    static let shared = MessageQueue()
//    private init() { }
//
//    func enqueue(_ message: TransferableMessage) {
//        array.append(message)
//    }
//
//    func dequeue() -> TransferableMessage? {
//        guard !array.isEmpty else {
//            return nil
//        }
//        return array.remove(at: 0)
//    }
//
//    var isEmpty: Bool {
//        return array.isEmpty
//    }
//}
