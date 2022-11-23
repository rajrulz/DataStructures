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

    /// asked in DEV REV
    /// given coordinates of queens in a chess board and queries i.e coordinates of soldiers return these soldiers will remain alive or will be attacked by queen
    func squaresUnderQueenAttack(n: Int, queens: [[Int]], queries: [[Int]]) -> [Bool] {
        var chessBoard: [[Bool]] = []
        // create chessBoard
        for _ in 0..<n {
            chessBoard.append(Array(repeating: false, count: n))
        }
        
        // mark queens coordinate and its reachable coordinates as true
        for queen in queens {
            let x = queen[0]
            let y = queen[1]
            // place queen in chessboard
            chessBoard[x][y] = true
            
            // diagonal reachable coordinates
            for i in stride(from: 1, to: n, by: 1) {
                if x - i >= 0 && y - i >= 0 {
                    chessBoard[x-i][y-i] = true
                }
                if x + i < n && y + i < n {
                    chessBoard[x+i][y+i] = true
                }
                if x - i >= 0 && y + i < n {
                    chessBoard[x-i][y+i] = true
                }
                if x + i < n && y - i >= 0 {
                    chessBoard[x+i][y-i] = true
                }
            }
            
            // row & col reachable coordinates
            for i in stride(from: 0, to: n, by: 1) {
                chessBoard[i][y] = true
                chessBoard[x][i] = true
            }
        }
        
        print(chessBoard)
        var result: [Bool] = []
        // looping queries to check their coordinates lie on any attacking zone of any queen
        // chessBoard[i][j] = false means [i,j] query can't be attacked
        for query in queries {
            result.append(chessBoard[query[0]][query[1]])
        }
        return result
    }

    /// asked in microsoft online assessment
    func solution(_ A: Int, _ B: Int) -> Int {
        var i = 1
        var count = 0
        while true {
            let product = i * (i + 1)
            if A <= product && product <= B {
                count += 1
                i += 1
            } else if product < A {
                i += 1
            } else {
                break
            }
        }
        return count
    }

        func maxset(_ A: inout [Int]) -> [Int] {
            var low = 0
            var currSum = 0
            var high = -1
            var subArray: [Int] = []
            var maxSumTuple = (0, 0, 0, Array<Int>()) // (sum, initialIndex, length, subArray)
            for num in A {
                if num >= 0 {
                    subArray.append(num)
                    high += 1
                    currSum += num
                } else {
                    if high >= low {
                        if currSum > maxSumTuple.0 {
                            maxSumTuple = (currSum, low, high - low + 1, subArray)
                        } else if currSum == maxSumTuple.0 {
                            if maxSumTuple.2 < (high - low + 1) {
                                maxSumTuple = (currSum, low, high - low + 1, subArray)
                            }
                        }
                    }
                    currSum = 0
                    low = high + 2
                    high = low - 1
                    subArray.removeAll()
                }
            }

            if high >= low {
                if currSum > maxSumTuple.0 {
                    maxSumTuple = (currSum, low, high - low + 1, subArray)
                } else if currSum == maxSumTuple.0 {
                    if maxSumTuple.2 < (high - low + 1) {
                        maxSumTuple = (currSum, low, high - low + 1, subArray)
                    }
                }
            }
            return maxSumTuple.3
        }

    ///An n-bit gray code sequence is a sequence of 2n integers where:
    
//    Every integer is in the inclusive range [0, 2n - 1],
//    The first integer is 0,
//    An integer appears no more than once in the sequence,
//    The binary representation of every pair of adjacent integers differs by exactly one bit, and
//    The binary representation of the first and last integers differs by exactly one bit.
//    Given an integer n, return any valid n-bit gray code sequence.
    func grayCode(_ n: Int) -> [Int] {
        var resultGrayCode: [String] = []
        func binaryOf(_ n: Int, bitCount: Int) -> String {
            guard n > 0 else {
                return String(Array(repeating: "0", count: bitCount))
            }
            var n = n
            var binaryArray: [Int] = []
            while n > 0 {
                let remainder = n % 2
                binaryArray.append(remainder)
                n = n / 2
            }
            for _ in stride(from: 0, to: (bitCount - binaryArray.count), by: 1) {
                binaryArray.append(0)
            }
            binaryArray.reverse()
            var binaryStr = ""
            for num in binaryArray {
                binaryStr += "\(num)"
            }
            return binaryStr
        }

        func isDiffOne(_ binary1: String, _ binary2: String) -> Bool {
            let binary1 = Array(binary1)
            let binary2 = Array(binary2)
            var countOfDiff = 0
            for i in 0..<binary1.count {
                if binary1[i] != binary2[i] {
                    if countOfDiff == 1 {
                        return false
                    } else {
                        countOfDiff += 1
                    }
                }
            }
            return countOfDiff == 1
        }

        func DFS(from vertex: String,
                 in graph: [String: [String]],
                 visited: [String:  Bool],
                 grayCode: [String]) {
            guard visited[vertex] == nil else {
                return
            }
            var visited = visited
            visited[vertex] = true
            
            if let adjVertices = graph[vertex] {
                for adjV in adjVertices {
                    if visited[adjV] == nil {
                        DFS(from: adjV, in: graph, visited: visited, grayCode: grayCode + [adjV])
                    }
                }
            } else if grayCode.count == graph.count {
                 if isDiffOne(grayCode[0], grayCode[grayCode.count - 1]) {
                     resultGrayCode = grayCode
                 }
            }
        }

        var binaryArray: [String] = []
//        for i in 0..<Int(pow(2, n)) {
//            binaryArray.append(binaryOf(i, bitCount: n))
//        }
        
        // create graph
        var graph: [String: [String]] = [:]
        for i in 0..<n {
            let key = binaryArray[i]
            for j in 0..<n {
                let value = binaryArray[j]
                if isDiffOne(key,value) {
                    if let values = graph[key] {
                        graph[key] = values + [value]
                    } else {
                        graph[key] = [value]
                    }
                }
            }
        }
        
        DFS(from: binaryArray[0],in: graph, visited: [:], grayCode: [])
        print(resultGrayCode)
        return []
    }
    
    func longestSubsequenceCount(_ arr:[Int]) -> Int {
        var longestSC = 0
        var longestSubsequence: [Int] = []
        func LSC(_ arr: [Int], _ i: Int, _ subsequence: [Int]) {
            if i >= arr.count {
                if subsequence.count > longestSC {
                    longestSubsequence = subsequence
                    longestSC = subsequence.count
                }
            } else {
                let lastElement = subsequence[subsequence.count - 1]
                if arr[i] < lastElement {
                    LSC(arr, i+1, subsequence)
                } else {
                    LSC(arr, i+1, subsequence + [arr[i]])
                    LSC(arr, i+1, subsequence)
                }
            }
        }
        
        for (index, num) in arr.enumerated() {
            LSC(arr, index + 1, [num])
        }
        print(longestSubsequence)
        return longestSC
    }
}
