//
//  Tree.swift
//  DS
//
//  Created by Rajneesh Biswal on 26/06/21.
//

import Foundation

class Stack<T> {
    private var array: [T] = []
    func push(_ node: T) {
        array.append(node)
    }

    func pop() -> T? {
        guard !array.isEmpty else {
            return nil
        }
        return array.removeLast()
    }

    func top() -> T? {
        guard !array.isEmpty else {
            return nil
        }
        return array.last
    }

    var isEmpty: Bool {
        return array.isEmpty
    }
}
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

    init(_ vals: [NodeValType?] = []) {
        createTree(from: vals)
    }

    /// create tree from input as its present in leetcode
    private func createTree(from array: [NodeValType?]) {
        guard !array.isEmpty else {
             return
        }
        guard let firstElement = array[0] else {
            return
        }
        let arrayCount = array.count
        root = TreeNode(val: firstElement)
        var nodesArray: [TreeNode<NodeValType>?] = [root]
        for i in stride(from: 1, to: arrayCount, by: 1) {
            var node: TreeNode<NodeValType>?
            if let val = array[i] {
                node = TreeNode(val: val)
            }
            let parentIndex = (i-1)/2
            let parentNode = nodesArray[parentIndex]
            if i == parentIndex * 2 + 1 {
                parentNode?.left = node
            } else {
                parentNode?.right = node
            }
            nodesArray.append(node)
        }
    }

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

    func convertTreeToFullBinaryTree(_ root: TreeNode<NodeValType>?) -> TreeNode<NodeValType>? {
        if let node = root {
            let leftTree = convertTreeToFullBinaryTree(node.left)
            let rightTree = convertTreeToFullBinaryTree(node.right)
            if leftTree == nil && rightTree != nil {
                // has only right child
                return rightTree
            } else if rightTree == nil && leftTree != nil {
                // has only left child
                return leftTree
            } else {
                // has both childs
                node.left = leftTree
                node.right = rightTree
                return node
            }
        } else {
            return nil
        }
    }

    func iterativePostOrderTraversal(ofTree node: TreeNode<NodeValType>?) {
        // same as inorder traversal if we consider right first then left
        var node = node
        let stack = Stack<TreeNode<NodeValType>>()
        while true {
            while node != nil {
                print(node?.val as Any)
                stack.push(node!)
                node = node?.right
            }
            
            if stack.isEmpty {
                break
            } else {
                node = stack.pop()
                node = node?.left
            }
        }
    }

//    func possiblePreOrdersFromInorder(_ inorder: [Int]) {
//        
//        var preorders: [[Int]] = []
//        func preOrderTraversal(from root: TreeNode<Int>?) {
//            if let root = root {
//                
//            }
//        }
//        func constructTree(fromInorder inorder: [Int] ) -> TreeNode<Int>? {
//            if inorder.isEmpty {
//                return nil
//            }
//            for (index,element) in inorder.enumerated() {
//                let root = TreeNode<Int>(val: element)
//                if index > 0 && index < inorder.count - 1 {
//                    root.left = constructTree(fromInorder: Array(inorder[0...(index-1)]))
//                    root.right = constructTree(fromInorder: Array(inorder[(index+1)...]))
//                } else if index == 0{
//                    root.right = constructTree(fromInorder: Array(inorder[(index+1)...]))
//                } else {
//                    root.left = constructTree(fromInorder: Array(inorder[0...(index-1)]))
//                }
//                return root
//            }
//        }
//        
//        
//    }
}
