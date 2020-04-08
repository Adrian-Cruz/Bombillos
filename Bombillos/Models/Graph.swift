//
//  Graph.swift
//  Bombillos
//
//  Created by Adrian on 06/04/20.
//  Copyright © 2020 AdrianCruz. All rights reserved.
//

import Foundation

class Graph {
    var arrayOfNodes : [[Node]]
    var combinations : [[Node]]
    var arrayOfPositions : [[Int]]
    
    init() {
        arrayOfNodes = [[Node]]()
        combinations = [[Node]]()
        arrayOfPositions = [[Int]]()
    }
    
    func createGraphFromArray(_ array: [[Int]]){
        
        //Create nodes
        for i in 0..<array.count{
            var arrayAux = [Node]()
            for j in 0..<array[i].count{
                let node = Node(value: ArrayValue(rawValue: array[i][j])!)
                arrayAux.append(node)
            }
            arrayOfNodes.append(arrayAux)
        }
        
        //create Relations
        for i in 0..<array.count{
            for j in 0..<array[i].count{
                let node = arrayOfNodes[i][j]
                if node.value == ArrayValue.empty {
                    if j+1 == array[i].count { //last node
                        
                    }else{
                        let nextNode = arrayOfNodes[i][j+1]
                        if nextNode.value == ArrayValue.empty {
                            node.right = nextNode
                            nextNode.left = node
                        }
                    }
                }
            }
        }
        
        for i in 0..<array.count{
            for j in 0..<array[i].count{
                let node = arrayOfNodes[i][j]
                if node.value == ArrayValue.empty {
                    if i+1 == array.count { //last array of nodes
                        
                    }else{
                        let downNode = arrayOfNodes[i+1][j]
                        if downNode.value == ArrayValue.empty {
                            node.down = downNode
                            downNode.up = node
                        }
                    }
                }
            }
        }
    }
    
    func callSetLightBulbs(){
//        for i in 0..<arrayOfNodes.count{
//            for j in 0..<arrayOfNodes[i].count{
//                setLightBulbs(start: arrayOfNodes.count, end: arrayOfNodes[0].count)
//            }
//        }
        
        var arrayVisited = setLightBulbs2()
        for position in arrayOfPositions {
            print(position)
        }
        for node in arrayVisited {
            node.value = .bulb
        }
        
        for array in arrayOfNodes {
            for node in array {
                if node.value == .empty && node.visited {
                    node.value = .iluminated
                }
            }
        }
    }
    
    func setLightBulbs2()-> [Node]{
        var flag = true
        var arrayOfBulbs = [Node]()
        
        
        while flag {
            var higherValue = 0
            var higherNode : Node?
            for i in 0..<arrayOfNodes.count{
                for j in 0..<arrayOfNodes[i].count{
                    let node = arrayOfNodes[i][j]
                    if !node.visited && node.value == .empty{
                        
                        let sumNodesThatCanLight = numberOfNodesThatCanLightToTheLeft(from: node) +
                            numberOfNodesThatCanLightUpward(from: node) +
                            numberOfNodesThatCanLightToTheRight(from: node) +
                            numberOfNodesThatCanLightDownward(from: node) + 1
                        
                        if sumNodesThatCanLight > higherValue {
                            higherValue = sumNodesThatCanLight
                            higherNode = node
                            arrayOfPositions.append([i,j])
                        }
                    }
                }
            }
            
            higherNode?.visited = true
            arrayOfBulbs.append(higherNode!)
            markLeftNodes(from: higherNode)
            markRightNodes(from: higherNode)
            markUpNodes(from: higherNode)
            markDownNodes(from: higherNode)
            
            if theWholeGraphWasVisited(){
                flag = false
            }
        }
        return arrayOfBulbs
    }
    
    func arrayOfNodesToArray()->[[Int]]{
        var matrix = [[Int]]()
        
        for array in arrayOfNodes {
            var aux = [Int]()
            for node in array {
                aux.append(node.value.rawValue)
            }
            matrix.append(aux)
        }
        return matrix
    }
    

    func setLightBulbs()-> [Node]{
        var arrayOfVisitedNodes = [Node]()
        for i in 0..<arrayOfNodes.count{
            for j in 0..<arrayOfNodes[i].count{
                let node = arrayOfNodes[i][j]
                if !node.visited && node.value == .empty{
                    markLeftNodes(from: node)
                    markRightNodes(from: node)
                    markUpNodes(from: node)
                    markDownNodes(from: node)
                    arrayOfVisitedNodes.append(node)
                    arrayOfPositions.append([i,j])
                }
                
            }
        }
        
//        if theWholeGraphWasVisited(){
//            //arrayOfVisitedNodes.append(contentsOf: setLightBulbs())
//            combinations.append(arrayOfVisitedNodes)
//        }else {
//            arrayOfVisitedNodes.append(contentsOf: setLightBulbs())
//        }
        return arrayOfVisitedNodes
        
    }
    
    func theWholeGraphWasVisited()->Bool{
        for arrNode in arrayOfNodes {
            for node in arrNode {
                if node.visited == false && node.value != .wall{
                    return false
                }
            }
        }
        return true
    }
    
    
//    func setLightBulbs(){
//        var arrayOfVisitedNodes = [Node]()
//
//        for i in 0..<arrayOfNodes.count{
//            for j in 0..<arrayOfNodes[i].count{
//                let node = arrayOfNodes[i][j]
//                if !node.visited {
//                    markLeftNodes(from: node)
//                    markRightNodes(from: node)
//                    markUpNodes(from: node)
//                    markDownNodes(from: node)
//                    arrayOfVisitedNodes.append(node)
//                }
//            }
//        }
//    }
    
    func markLeftNodes(from node: Node?){
        if node == nil {
            return
        }
        if node?.value == ArrayValue.wall {
            return
        }
        node?.visited = true
        markLeftNodes(from: node?.left)
    }
    
    func markRightNodes(from node: Node?){
        if node == nil {
            return
        }
        if node?.value == ArrayValue.wall {
            return
        }
        node?.visited = true
        markRightNodes(from: node?.right)
    }
    
    func markUpNodes(from node: Node?){
        if node == nil {
            return
        }
        if node?.value == ArrayValue.wall {
            return
        }
        node?.visited = true
        markUpNodes(from: node?.up)
    }
    
    func markDownNodes(from node: Node?){
        if node == nil {
            return
        }
        if node?.value == ArrayValue.wall {
            return
        }
        node?.visited = true
        markDownNodes(from: node?.down)
    }
    
    
    func numberOfNodesThatCanLightToTheLeft(from node: Node?)-> Int{
        if node == nil {
            return 0
        }
        if node?.value == ArrayValue.wall {
            return 0
        }
        //node?.visited = true
        var number = 0
        if !node!.visited {
            number = 1
        }
        return (numberOfNodesThatCanLightToTheLeft(from: node?.left) + number)
    }
    
    func numberOfNodesThatCanLightToTheRight(from node: Node?)-> Int{
        if node == nil {
            return 0
        }
        if node?.value == ArrayValue.wall {
            return 0
        }
        //node?.visited = true
        var number = 0
        if !node!.visited {
            number = 1
        }
        return (numberOfNodesThatCanLightToTheRight(from: node?.right) + number)
    }
    
    func numberOfNodesThatCanLightUpward(from node: Node?)-> Int{
        if node == nil {
            return 0
        }
        if node?.value == ArrayValue.wall {
            return 0
        }
        //node?.visited = true
        var number = 0
        if !node!.visited {
            number = 1
        }
        return (numberOfNodesThatCanLightUpward(from: node?.up) + number)
    }
    
    func numberOfNodesThatCanLightDownward(from node: Node?)-> Int{
        if node == nil {
            return 0
        }
        if node?.value == ArrayValue.wall {
            return 0
        }
        //node?.visited = true
        var number = 0
        if !node!.visited {
            number = 1
        }
        return (numberOfNodesThatCanLightDownward(from: node?.down) + number)
    }
    
    
}
