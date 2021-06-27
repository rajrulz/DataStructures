//
//  ViewController.swift
//  DS
//
//  Created by Rajneesh Biswal on 06/06/21.
//

import UIKit
import Combine

class ViewController: UIViewController {
    var cancellableSubscriptions = Set<AnyCancellable>()
    let threading = Threading()
    let readerWriter = ReaderWriter()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        self.testMinSwapsToMakePalindrome()
//        testDP()
//        testString()
//        testOperationQueues()
        print("view did load")
//        testArray()
//        var array = [1,5,78,6,4,3,75]
//        array.bubbleSorted { $0 > $1 }
//        print(array)
//        testTrie()
        testTreeCreation()
        print("tree creation complete")
    }

    func testGCD() {
                DispatchQueue.global().async { [weak self] in
        //            threading.printOddEvenSynchronously()
        //            threading.testDispatchGroup()
                    self?.threading.concurrentlyDownload(tasks: 4)
                }
                threading.exampleOfRaceCondition()
                
                let q = DispatchQueue(label: "concurrent", attributes: .concurrent)
                for i in 0...19 {
                    q.async { [weak self] in
                        if i % 5 == 0 {
                            self?.readerWriter.write(str: "\(i)")
                        } else {
                            self?.readerWriter.read()
                        }
                    }
                }
                threading.testDeadLock()
    }

    func testOperationQueues() {
//        ConcurrentOperations().testBlockOperations()
        ConcurrentOperations().testOperationQueues()
    }

    func testMinSwapsToMakePalindrome() {
        print(DSArray().minAdjSwapsToMakePalindrome(str: "mamad"))
        print(DSArray().minAdjSwapsToMakePalindrome(str: "aabb"))
        print(DSArray().minAdjSwapsToMakePalindrome(str: "asflkj"))
        print(DSArray().minAdjSwapsToMakePalindrome(str: "ntiin"))

    }

    func testArray() {
        let targetSum = 12
//        print("get pairs of target sum \(targetSum) in sorted array")
//        print(DSArray().getPairsOfSum(targetSum, inSortedArray: [1,2,3,4,5,6,7,8,9,10]))
//        print("get pairs of target sum \(targetSum) in sorted & rotated array")
//        print(DSArray().getPairsOfSum(targetSum, inSortedAndRotatedArray: [3,4,5,6,7,8,9,1,2]))
//
//        print("index of num \(15) in sorted & rotated array")
//        print(DSArray().indexOfNum(15, inSortedAndRotatedArray: [11,12,13,14,5,6,7,8]))
        
        let dsArray = DSArray()
        var sortedArray: [Int] = []
        dsArray.insert(num: 12, insortedArray: &sortedArray)
        dsArray.insert(num: 12, insortedArray: &sortedArray)

        print(sortedArray)
//        print(UserMainCode().topologyType(input1: 5, input2: 4, input3: [1,2,2,4,5], input4: [2,3,4,5,3]))
    }

    func testDP() {
        let dp = DP()
        print(dp.minCostPath(in: [[1,3,5,8],[4,2,1,7],[4,3,2,3]]))
        print(dp.fibonacciOf(n: 50))
        
    }

    func testString() {
        print(Strings().getPermutationsOf("abc"))
        print(Strings().printPermuations(Array("abc"), ""))
    }

    func testTrie() {
        let trie = Trie()
        trie.insert(word: "apple")
        trie.insert(word: "alphabet")
        trie.insert(word: "guava")
        trie.insert(word: "fruits")
        trie.insert(word: "papaya")
        trie.insert(word: "astonish")
//        trie.insert(word: "Rajneesh")
//        trie.insert(word: "Rashmi")
        trie.insert(word: "abacus")
        trie.insert(word: "aaa")
        trie.insert(word: "cat")
        trie.insert(word: "ball")
        print(trie.getWordsPrefixed(with: ""))
    }

    func testTreeCreation() {
        let tree = Tree<Character>()
        tree.root = tree.create(fromInorder: ["A","B","C","D","E","F"], fromPreorder: ["A","B","C","D","E","F"])
        tree.inorderTraversal(tree.root)
    }
}

extension Array where Element == Int {
    mutating func bubbleSorted(by condition: ((Int,Int)-> Bool)) {
        // bubble sort
        for i in stride(from: 0, to: self.count, by: 1) {
            for j in stride(from: 0, to: self.count - i - 1, by: 1) {
                if !condition(self[j], self[j+1]) {
                    // swap
                    let temp = self[j]
                    self[j] = self[j+1]
                    self[j+1] = temp
                }
            }
        }
    }
}
