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
}
