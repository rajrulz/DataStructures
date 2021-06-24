//
//  Threading.swift
//  DS
//
//  Created by Rajneesh Biswal on 14/06/21.
//

import Foundation
import Combine
import UIKit

class Threading {
    var cancellableSubscriptions = Set<AnyCancellable>()

    func testDeadLock() {
        let dispatchQueue = DispatchQueue(label: "com.DS.threading.serial", attributes: .concurrent)
        dispatchQueue.sync {
            print("inside outer block")
            dispatchQueue.sync {
                print("inside inner block")
            }
        }
    }

    func testDispatchGroup() {
        let dispatchGroup = DispatchGroup()
         let dispatchQueue1 = DispatchQueue(label: "concurrent1")
         dispatchQueue1.async {
             dispatchGroup.enter()
             defer { dispatchGroup.leave() }
             for i in 1...3 {
                 sleep(1)
                 print("block1 \(i)")
             }
         }
         dispatchQueue1.async {
             dispatchGroup.enter()
             defer { dispatchGroup.leave() }
             for i in 1...5 {
                 sleep(1)
                 print("block2 \(i)")
             }
         }
         dispatchGroup.notify(queue: DispatchQueue.global()) {
             print("all tasks completed")
         }
    }

    func printOddEvenSynchronously() {
        let dispatchSemaphore = DispatchSemaphore(value: 1)
        let dispatchGroup = DispatchGroup()
        let dispatchQueue1 = DispatchQueue(label: "concurrent1", attributes: .concurrent)
        var i = 0
        dispatchQueue1.async(group: dispatchGroup) {
            // odd
            while i <= 10 {
                if i <= 10 && i % 2 == 1  {
                    dispatchSemaphore.wait()
                    Thread.sleep(forTimeInterval: 1)
                    print("odd \(i)")
                    i += 1
                    dispatchSemaphore.signal()
                }
            }
        }

        dispatchQueue1.async(group: dispatchGroup) {
            // even
            while i <= 10 {
                if i <= 10 && i % 2 == 0 {
                    dispatchSemaphore.wait()
                    Thread.sleep(forTimeInterval: 1)
                    print("even \(i)")
                    i += 1
                    dispatchSemaphore.signal()
                }
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.global()) {
            print("all tasks completed")
        }
    }

    func concurrentlyDownload(tasks taskCount: Int) {
        var downloadURLs: [URL] = []
        for _ in 1...12 {
            downloadURLs.append(URL(string: "https://avatars.githubusercontent.com/u/9743939?v=4")!)
        }
        var images: [UIImage] = Array(repeating: UIImage(), count: downloadURLs.count) {
            didSet {
                print("\(images)")
            }
        }
        let semaphore = DispatchSemaphore(value: taskCount)
        let dispatchGroup = DispatchGroup()
        for (i,url) in downloadURLs.enumerated() {
            dispatchGroup.enter()
            semaphore.wait()
            URLSession.shared.dataTaskPublisher(for: url)
                .compactMap { UIImage(data: $0.data)}
                .mapError { $0 as Error }
                .sink(receiveCompletion: { _ in
                    semaphore.signal()
                    dispatchGroup.leave()
                }) {
                    images[i] = $0
                }.store(in: &self.cancellableSubscriptions)
        }

        dispatchGroup.notify(queue: DispatchQueue.main) {
            print("all images downloaded successfully")
        }
    }

    func exampleOfRaceCondition() {
        var count = 0
        let q = DispatchQueue(label: "com.DS.raceCondition.concurrent", attributes: .concurrent)
        let serialQ = DispatchQueue(label: "com.DS.raceCondition.serial")
        let dispatchGroup =  DispatchGroup()
        for _ in 1...5 {
            q.async(group: dispatchGroup) {
                serialQ.sync {
                    Thread.sleep(forTimeInterval: 1)
                    count += 1
                }
            }
        }
        
        dispatchGroup.wait()
        print(count)
    }

}

class ReaderWriter {
    private var str = "Rajneesh"
    private let dispatchQ = DispatchQueue(label: "com.DS.ReaderWriter", attributes: .concurrent)
    func read() {
        dispatchQ.async { [weak self] in
            guard let self = self else { return }
           // reading asynchronously
            print("\(String(describing: Thread.current.name)) read \(self.str)")
        }
    }

    func write(str: String) {
        dispatchQ.async( flags: .barrier) { [weak self] in
            guard let self = self else { return }
            self.str = str
            Thread.sleep(forTimeInterval: 3)
            print("\(String(describing: Thread.current.name)) write \(self.str)")
        }
    }
}
