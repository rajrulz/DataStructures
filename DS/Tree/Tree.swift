//
//  Tree.swift
//  DS
//
//  Created by Rajneesh Biswal on 26/06/21.
//

import Foundation

class TreeNode<NodeValType: Hashable> {
    var val: NodeValType
    var left: TreeNode?
    var right: TreeNode?
    
    init(val: NodeValType, left: TreeNode? = nil, right: TreeNode? = nil) {
        self.val = val
        self.left = left
        self.right = right
    }
}

class Tree<NodeValType: Hashable> {
    var root: TreeNode<NodeValType>?
    
    func create(fromInorder inorder: [NodeValType], fromPreorder preorder: [NodeValType]) -> TreeNode<NodeValType>? {
        var inorderIndexDict: [NodeValType: Int] = [:]
        var preorderIndexDict: [NodeValType: Int] = [:]
        for (index, nodeVal) in inorder.enumerated() {
            inorderIndexDict[nodeVal] = index
        }
        for (index, nodeVal) in preorder.enumerated() {
            preorderIndexDict[nodeVal] = index
        }
        
        func getMinIndex(in array: [NodeValType], comparing indexDict: [NodeValType: Int]) -> Int {
            var minIndex = NSNotFound
            for nodeVal in array {
                if let index = indexDict[nodeVal] {
                    minIndex = index < minIndex ? index : minIndex
                }
            }
            return minIndex
        }

        func subArray(from start: Int, to end: Int, in array: [NodeValType]) ->[NodeValType] {
            var result: [NodeValType] = []
            for i in stride(from: start, through: end, by: 1) {
                result.append(array[i])
            }
            return result
        }
        
        func createNode(_ low: Int, _ currentIndex: Int, _ high: Int) -> TreeNode<NodeValType>? {
            if currentIndex == NSNotFound {
                return nil
            }

            if low > high {
                return nil
            }

            let currentNodeVal = inorder[currentIndex]
            
            guard let index = inorderIndexDict[currentNodeVal] else {
                return nil
            }

            let node = TreeNode<NodeValType>(val: currentNodeVal)

            node.left = createNode(low, getMinIndex(in: subArray(from: low, to: index-1, in: inorder),
                                                    comparing: inorderIndexDict), index - 1)
            node.right = createNode(index+1, getMinIndex(in: subArray(from: index+1, to: high, in: inorder),
                                                         comparing: inorderIndexDict), high)
            return node
        }
        
        return createNode(0, getMinIndex(in: inorder, comparing: inorderIndexDict), preorder.count-1)
    }

    func inorderTraversal(_ node: TreeNode<NodeValType>?) {
        if let node = node {
            if node.left != nil {
                inorderTraversal(node.left)
            }
            print(node.val)
            if node.right != nil {
                inorderTraversal(node.right)
            }
        }
    }
}
