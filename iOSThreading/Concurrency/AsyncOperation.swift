//
//  AsyncOperation.swift
//  DS
//
//  Created by Rajneesh Biswal on 22/06/21.
//

import Foundation

/// By default Operation is synchronous in order to make use of asynchronous version of it. we can use this class.
class AsyncOperation: Operation {
    private let lockQueue = DispatchQueue(label: "com.swiftlee.asyncoperation", attributes: .concurrent)

    override var isAsynchronous: Bool {
        return true
    }

    private var _isExecuting: Bool = false
    override private(set) var isExecuting: Bool {
        get {
            // why we require to submit sync operation to read from the variable
            // as read operations are thread safe.
            
            // indeed read operations are thread safe. But if we dont put the read as sync task.
            // 1. there would be a race condition to read the variable
            // 2. Chances are the variable is in inconsistent state and it will be read.
            // ex: in Reader Writer problem if read operation are put as sync task then putting a bariier will hault all the tasks submitted till write operation is not completed but since read operation is independent of dispatch queue, Variable will be read in inconsistent state.
            return lockQueue.sync { () -> Bool in
                return _isExecuting
            }
        }
        set {
            willChangeValue(forKey: "isExecuting")
            lockQueue.sync(flags: [.barrier]) {
                _isExecuting = newValue
            }
            didChangeValue(forKey: "isExecuting")
        }
    }

    private var _isFinished: Bool = false
    override private(set) var isFinished: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isFinished
            }
        }
        set {
            willChangeValue(forKey: "isFinished")
            lockQueue.sync(flags: [.barrier]) {
                _isFinished = newValue
            }
            didChangeValue(forKey: "isFinished")
        }
    }

    override func start() {
        print("Starting")
        guard !isCancelled else {
            finish()
            return
        }

        isFinished = false
        isExecuting = true
        main()
    }

    override func main() {
        fatalError("Subclasses must implement `main` without overriding super.")
    }

    func finish() {
        print("finished")
        isExecuting = false
        isFinished = true
    }
}

