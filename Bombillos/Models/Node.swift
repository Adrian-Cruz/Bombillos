//
//  Node.swift
//  Bombillos
//
//  Created by Adrian on 06/04/20.
//  Copyright © 2020 AdrianCruz. All rights reserved.
//

import Foundation

class Node {
    var value : ArrayValue
    var left : Node?
    var right : Node?
    var up : Node?
    var down : Node?
    var visited : Bool
    
    init(value: ArrayValue) {
        self.value = value
        self.visited = false
    }
}
