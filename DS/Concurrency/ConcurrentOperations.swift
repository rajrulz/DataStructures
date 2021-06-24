//
//  ConcurrentOperations.swift
//  DS
//
//  Created by Rajneesh Biswal on 22/06/21.
//

import Foundation
import UIKit

class ConcurrentOperations {
    /// Block operation work as dispatch group that means we can add multiple operations to a block operation
    func testBlockOperations() {
        let operation = BlockOperation()
        for i in 0..<10 {
            operation.addExecutionBlock {
                // process of elements
//                sleep(2)
                Thread.sleep(forTimeInterval: 2)
                print("\(i)")
            }
        }
        operation.completionBlock = {
            print("all opeartions submitted are completed")
        }
        operation.start()
    }

    /// download 4 images asynchronously using operation Queues
    func testOperationQueues() {
        var downloadURLs: [URL] = []
        for _ in 1...12 {
            downloadURLs.append(URL(string: "https://avatars.githubusercontent.com/u/9743939?v=4")!)
        }
        var imageViews: [UIImageView] = Array(repeating: UIImageView(), count: 12)
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 4
        for i in 0..<12 {
            let operation = ImageDownloadOperation(url: downloadURLs[i])
            operation.completionBlock = {
                DispatchQueue.main.async {
                    imageViews[i] = UIImageView(image: operation.image)
                }
            }
            operationQueue.addOperation(operation)
        }
    }

    @objc func allOperationsFinished() {
        print("all operations finished")
    }

}

class ImageDownloadOperation: AsyncOperation {
    var image: UIImage?
    private var url: URL

    init(url: URL) {
        self.url = url
        super.init()
    }

    override func start() {
        print("started")
        main()
    }

    override func main() {
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            defer { self?.finish() }
            guard let self = self else { return }
            guard error == nil, let data = data else {
                return
            }
            guard let image = UIImage(data: data) else {
                return
            }
            Thread.sleep(forTimeInterval: 2)
            self.image = image
        }.resume()
    }
}
