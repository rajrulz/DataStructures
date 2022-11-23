//
//  Trie.swift
//  DS
//
//  Created by Rajneesh Biswal on 25/06/21.
//

import Foundation

fileprivate class TrieNode {
    var charDict: [Character: TrieNode] = [:]
    var isEndOfWord: Bool = false
}

class Trie {
    private var root: TrieNode
    
    init() {
        root = TrieNode()
    }

    func insert(word: String) {
        var node = root
        for ch in word {
            if let nextNode = node.charDict[ch] {
                node = nextNode
            } else {
                let newNode = TrieNode()
                node.charDict[ch] = newNode
                node = newNode
            }
        }
        node.isEndOfWord = true
    }

    func getWordsPrefixed(with prefix: String) -> [String] {
        var node = root
        for ch in prefix {
            if let nextNode = node.charDict[ch] {
                node = nextNode
            } else {
                break
            }
        }
        return getWords(from: node).map { "\(prefix)\($0)" }
    }
    
    private func getWords(from node: TrieNode) -> [String] {
        var result: [String] = []
        func populateWords(from node: TrieNode, word: String) {
            if node.isEndOfWord {
                result.append(word)
            }
            if node.charDict.isEmpty {
                return
            } else {
                for i in 65...91 {
                    let ch = Character(UnicodeScalar(i)!)
                    if let nextNode = node.charDict[ch] {
                        populateWords(from: nextNode, word: word + "\(ch)")
                    }
                }
                for i in 97...122 {
                    let ch = Character(UnicodeScalar(i)!)
                    if let nextNode = node.charDict[ch] {
                        populateWords(from: nextNode, word: word + "\(ch)")
                    }
                }
            }
        }
        populateWords(from: node, word: "")
        return result
    }
}
