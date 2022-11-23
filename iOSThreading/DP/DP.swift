//
//  DP.swift
//  DS
//
//  Created by Rajneesh Biswal on 21/06/21.
//

import Foundation

class DP {
    /// get minimum cost of path travelling from 0,0 to bottom right corner cell
    func minCostPath(in cost: [[Int]]) -> [Int] {
        
        var resultPath: [Int] = []
        var minPathSum = Int.max
        func minimumCostPath(from x: Int, _ y: Int, in cost: [[Int]], path: [Int], pathSum: Int) {
            if x == cost.count - 1 && y == cost[0].count - 1 {
                let pathSum = pathSum + cost[x][y]
                let path = path + [cost[x][y]]
                if pathSum < minPathSum {
                    resultPath = path
                    minPathSum = pathSum
                }
            } else if x == cost.count - 1 {
                minimumCostPath(from: x, y+1, in: cost, path: path + [cost[x][y]], pathSum: pathSum + cost[x][y])
            } else if y == cost[0].count - 1 {
                minimumCostPath(from: x+1, y, in: cost, path: path + [cost[x][y]], pathSum: pathSum + cost[x][y])
            } else {
                minimumCostPath(from: x, y+1, in: cost, path: path + [cost[x][y]], pathSum: pathSum + cost[x][y])
                minimumCostPath(from: x+1, y, in: cost, path: path + [cost[x][y]], pathSum: pathSum + cost[x][y])
            }
        }
        minimumCostPath(from: 0, 0, in: cost, path: [], pathSum: 0)
        return resultPath
    }

    func fibonacciOf(n: Int) -> Int {
        guard n > 0 else {
            return 0
        }
       
        if n == 1 {
            return 1
        } else if n == 2 {
            return 2
        } else {
            var p = 1
            var q = 2
            for _ in stride(from: 3, through: n, by: 1) {
                let k = q
                q = p + q
                p = k
            }
            return q
        }
    }

    /// A player can score 3,5,10 then how many ways he can score a given score of 13
    /// 5 ways
    typealias score = Int
    typealias ways = Int
    var dpDict: [score: ways] = [:]
    func noOfWaysToScore(_ score: Int, usingPoints points: [Int]) -> Int {
        if let ways = dpDict[score] {
            return ways
        }
        if score < 0 {
            dpDict[score] = 0
            return 0
        } else if score == 0 {
            dpDict[score] = 1
            return 1
        } else {
            var ways = 0
            for point in points {
                ways += noOfWaysToScore(score - point, usingPoints: points)
            }
            dpDict[score] = ways
            return ways
        }
    }

    /// longest increasing subsequence
    func lengthOfLIS(_ nums: [Int]) -> Int {
        var LISLength = 0
        func populateLengthOfLIS(in arr: [Int], from i: Int, subSequence: [Int]) {
            if i >= arr.count {
                LISLength = subSequence.count > LISLength ? subSequence.count : LISLength
            } else {
                if let lastElement = subSequence.last {
                    if arr[i] > lastElement {
                        populateLengthOfLIS(in: arr, from: i+1, subSequence: subSequence + [arr[i]])
                        populateLengthOfLIS(in: arr, from: i+1, subSequence: subSequence)
                    } else {
                        populateLengthOfLIS(in: arr, from: i+1, subSequence: subSequence)
                    }
                } else {
                    populateLengthOfLIS(in: arr, from: i+1, subSequence: subSequence + [arr[i]])
                    populateLengthOfLIS(in: arr, from: i+1, subSequence: subSequence)
                }
            }
        }
        
        populateLengthOfLIS(in: nums, from: 0, subSequence: [])
        return LISLength
    }
}
