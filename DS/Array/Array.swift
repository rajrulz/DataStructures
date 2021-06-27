//
//  Array.swift
//  DS
//
//  Created by Rajneesh Biswal on 06/06/21.
//

import Foundation

struct DSArray {

    /// strategy insert num in sortedArray by doing a binary search for index where to be inserted
    func insert(num: Int, insortedArray array: inout [Int]) {
        var low = 0
        var high = array.count - 1
        guard high >= 0 else {
            array.append(num)
            return
        }
        
        while low < high {
            let mid = (low + high) / 2
            if array[mid] == num {
                array.insert(num, at: mid)
                return
            } else if num < array[mid] {
                high = mid - 1
            } else {
                low = mid + 1
            }
        }
        
        // control comes here when low == high 
        if num > array[low] {
            array.insert(num, at: low+1)
        } else {
            array.insert(num, at: low)
        }
    }

    func getPairsOfSum(_ targetSum: Int, inSortedArray array: [Int]) -> [(Int, Int)] {
        var i = 0
        var j = array.count - 1
        var result: [(Int, Int)] = []
        while i <  j {
            let sum = array[i] + array[j]
            if sum == targetSum {
                result.append((array[i],array[j]))
                j -= 1
            } else if sum > targetSum {
                j -= 1
            } else {
                i += 1
            }
        }
        return result
    }


    func getPairsOfSum(_ targetSum: Int,
                       inSortedAndRotatedArray array: [Int]) -> [(Int,Int)] {
        var rotatedIndex = -1
        let prevElement = array[0]
        for index in stride(from: 1, to: array.count - 1, by: 1) {
            let element = array[index]
            if element < prevElement {
                rotatedIndex = index
                break
            }
        }
        return getPairsOfSum(targetSum,inSortedArray: Array(array[0...rotatedIndex-1])) +
            getPairsOfSum(targetSum, inSortedArray: Array(array[rotatedIndex...array.count-1]))
    }
    /**
        Get Index of num in sorted and rotated array

     * iterate array get rotated index(ri) and apply binary searh [0..ri-1] and [ri...count]
     - complexity: O(n)
     * apply binary search if midElement = num then well and good
     * check array is sorted from low to mid-1 and wether num lies in b/w
     * then search in sorted array [low ... mid-1]
     * else search in unsorted array [mid+1..high]
     * check array is sorted from mid+1 to high and wether num lies in b/w
     * then search in sorted array [mid+1 ... high]
     * else search in unsorted array [low .. mid-1]
     - complexity: O(logn)
     */
    func indexOfNum(_ num: Int, inSortedAndRotatedArray array: [Int]) -> Int {
        func indexOfNum(_ num: Int,from low: Int, to high: Int) -> Int {
            let mid = (low + high)/2
            if array[mid] == num {
                return mid
            } else if low >= high {
                return -1
            }
            
            // array is sorted from low to mid
            if array[low] < array[mid] {
                if array[low] <= num && num < array[mid] {
                    return indexOfNum(num, from: low, to: mid-1)
                }
                return indexOfNum(num, from: mid+1, to: high)
            }
            // array is sorted from high to mid
            if array[mid] < num && num <= array[high] {
                return indexOfNum(num, from: mid+1, to: high)
            }
            return indexOfNum(num, from: low, to: mid-1)
        }
        return indexOfNum(num, from: 0, to: array.count - 1)
    }

    func minAdjSwapsToMakePalindrome(str: String) -> Int {
        /// check can str be transformed to valid palindrome
        var charDict: [Character: [Int]] = [:]
        func isValidPalindromeStr(str: String) -> Bool {
            for (index,ch) in str.enumerated() {
                if charDict[ch] == nil {
                    charDict[ch] = [index]
                } else {
                    charDict[ch] = charDict[ch]! + [index]
                }
            }
            var oddFrequencyChar: Character?
            for (key,indices) in charDict {
                let value = indices.count
                if value % 2 == 1 {
                    if oddFrequencyChar == nil {
                        oddFrequencyChar = key
                    } else {
                        return false
                    }
                } else if value % 2 == 0 {
                    continue
                }
            }
            return true
        }
        
        if isValidPalindromeStr(str: str) {
            var i = 0
            var j = str.count - 1
            var str = Array(str)
            var swappingCount = 0
            while i < j {
                if str[i] != str[j] {
                    var swappedCharIndex = i
                    for index in stride(from: j, to: -1, by: -1) {
                        if str[index] == str[i] {
                            swappedCharIndex = index
                            break
                        }
                    }
                    if swappedCharIndex == i {
                        // this char occured once so require to be in middle
                        while swappedCharIndex != (str.count - 1) / 2 {
                            swappingCount += 1
                            swapCharactersAt(swappedCharIndex, swappedCharIndex+1, in: &str)
                            swappedCharIndex += 1
                        }
                    } else {
                        // swap untill swappedCharIndex equals to j
                        while swappedCharIndex != j {
                            swappingCount += 1
                            swappedCharIndex += 1
                        }
                    }
                }
                i += 1
                j -= 1
            }
            print(str)
            
            return swappingCount
        } else {
            return -1
        }
    }

    func swapCharactersAt(_ i: Int, _ j: Int, in str: inout [Character]) {
        let temp = str[i]
        str[i] = str[j]
        str[j] = temp
    }
}


//class UserMainCode {
//    enum Topology: Int {
//        case bus
//        case ring
//        case star
//        case unknown = -1
//    }
//    
//    func topologyType(input1: Int, input2: Int, input3: [Int], input4: [Int]) -> Topology {
//        let nodesCount = input1
//        let edgesCount = input2
//        let edgeStartPoints = input3
//        let edgeEndPoints = input4
//        
//        // create graph
//        typealias Node = Int
//        var graph: [Node: [Node]] = [:]
//        
//        // intialize empty graph
//        for i in 1...nodesCount {
//            graph[i] = []
//        }
//
//        // populate graph
//        for index in stride(from: 0, to: edgeStartPoints.count, by: 1) {
//            let startNode = edgeStartPoints[index]
//            let endPoint = edgeEndPoints[index]
//            if let adjacentNodes = graph[startNode] {
//                graph[startNode] = adjacentNodes + [endPoint]
//            }
//        }
//
//        // deapth first search and get continuous paths
//    }
//
//    func checkGraphIsStar(_ graph: [Int: [Int]], nodesCount: Int, edgesCount: Int) -> Bool {
//        guard edgesCount == nodesCount - 1 else {
//            return false
//        }
//        var starNode: Int?
//        for node in graph.keys {
//            if let adjNodes = graph[node], adjNodes.count == nodesCount - 1 {
//                starNode = node
//                break
//            }
//        }
//        guard let middleStarNode = starNode else {
//            return false
//        }
//        for node in 1...nodesCount {
//            if node != middleStarNode,
//               let adjNodes = graph[node],
//               adjNodes.count == 1,
//               adjNodes[0] == middleStarNode {
//                continue
//            } else {
//                return false
//            }
//        }
//        return true
//    }
//
//    func checkGraphIsRing(_ graph: [Int: [Int]], nodesCount: Int, edgesCount: Int) -> Bool {
//        
//    }
//}
