//
//  Strings.swift
//  DS
//
//  Created by Rajneesh Biswal on 21/06/21.
//

import Foundation

class Strings {
    func getPermutationsOf(_ str: String) ->  [String] {
        var permutations: [String] = []
        func permute(_ chars: [Character], _ prefix: String) {
            if chars.count == 2 {
                permutations.append(prefix+String(chars))
                // swap contents of chars
                var chars = chars
                swapCharsAt(0, 1, in: &chars)
                permutations.append(prefix+String(chars))
                return
            }
            for (index,ch) in chars.enumerated() {
                var chars = chars
                chars.remove(at: index)
                permute(chars, prefix + "\(ch)")
            }
        }
        permute(Array(str), "")
        return permutations
    }

    func swapCharsAt(_ i: Int, _ j: Int, in str: inout [Character]) {
        let temp = str[i]
        str[i] = str[j]
        str[j] = temp
    }

    /// Jitu's implementation
    func printPermuations(_ s: [Character], _ prefix: String) {
        let len = s.count
        if len == 0 {
            print(prefix)
        } else {
            for (i,ch) in s.enumerated() {
                var s = s
                s.remove(at: i)
                printPermuations(s, prefix+"\(ch)")
            }
        }
    }

    /// Given a string, find the minimum number of substrings that it needs to be split so that there won’t be any duplicate character in each of the substrings.
    func minNoOfSubstringsWithoutDuplicateChar(_ str: String) -> Int {
        guard str.count > 0 else {
            return 0
        }
        guard str.count > 1 else {
            return 1
        }
        var count = 0
        let str = Array(str)
        var charDict: [Character: Int] = [:]
        for ch in str {
            if charDict[ch] == nil {
                charDict[ch] = 1
            } else {
                count += 1
                charDict.removeAll()
                charDict[ch] = 1
            }
        }
        if !charDict.isEmpty {
            count += 1
        }
        return count
    }
}
