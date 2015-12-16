//
//  DataStructures.swift
//  RuinaDefense_2
//
//  Created by Huynh Nguyen on 12/15/15.
//  Copyright © 2015 Ricardo Guntur. All rights reserved.
//

import Foundation

// Generic implementation of a queue with operations to check first, push and pop
struct Queue<Element> {
    var items = [Element]()
    
    // pushes an element to the end of the queue
    mutating func push(item: Element) {
        items.append(item)
    }
    
    // pops the first element of the queue
    mutating func pop() -> Element {
        return items.removeFirst()
    }
    
    // checks the front element of the queue
    func front() -> Element {
        return items.first!
    }

}

// Generic implementation of a stack with operations to check first, push and pop
struct Stack<Element> {
    var items = [Element]()
    
    // pushes an element to the top of the stack
    mutating func push(item: Element) {
        items.append(item)
    }
    
    // pops an element from the top of the stack
    mutating func pop() -> Element {
        return items.removeLast()
    }
    
    // checks the front element of the stack
    func front() -> Element {
        return items.first!
    }

}