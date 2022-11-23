//
//  Queue.swift
//  DS
//
//  Created by Rajneesh Biswal on 08/07/21.
//
import Foundation

protocol TransferableMessage {
    var id: Int { set get }
}

struct Message: TransferableMessage {
    var id: Int
    var mssg: String

}

extension Message {
    static var dummy: Message {
        Message(id: 0, mssg: "")
    }
}

protocol Queue {
    var size: Int { get }
    func enqueue(_ message: TransferableMessage) throws
    func dequeue() throws -> TransferableMessage
}

enum QueueError: Error {
    case overflow
    case underflow
}

class SharedQueue: Queue {
    var size: Int
    private var front: Int = -1
    private var rear: Int = -1
    private var array: [TransferableMessage]

    init(size: Int) {
        self.size = size
        self.array = Array(repeating: Message.dummy, count: size)
    }
    
    func enqueue(_ message: TransferableMessage) throws {
        if self.rear == self.front - 1 || (self.rear == self.size - 1 && self.front == 0) {
            throw QueueError.overflow
        }
        
        if self.front == self.rear && self.front == -1 {
            self.front = 0
            self.rear = 0
        } else if self.rear == self.size - 1 {
            self.rear = 0
        } else {
            self.rear += 1
        }
        self.array[rear] = message
    }
    
    func dequeue() throws -> TransferableMessage {
        if rear == -1 {
            throw QueueError.underflow
        }
        
        var message: TransferableMessage
        if front == rear {
            message = array[rear]
            array[rear] = Message.dummy
            front = -1
            rear = -1
        } else if front == size - 1 {
            message = array[front]
            array[front] = Message.dummy
            front = 0
        } else {
            message = array[front]
            array[front] = Message.dummy
            front += 1
        }
        return message
    }
}
