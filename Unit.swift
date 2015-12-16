//
//  Unit.swift
//  RuinaDefense_2
//
//  Created by Huynh Nguyen on 12/14/15.
//  Copyright © 2015 Ricardo Guntur. All rights reserved.
//

import Foundation
import SpriteKit

class Unit {
    
    enum Status { case Attacking, Idle, Running, Dead}
    
    //------------------ class variables ---------------------//
    
    // sprite kit
    var sprite: SKSpriteNode
    
    // stats
    var health: Int
    var defense: Int
    var damage: Int
    var status: Status
    
    //------------------ class functions ---------------------//
    
    // default initializer should never be used
    init() {
        
        // sprite kit
        sprite = SKSpriteNode()
        
        // stats
        health = 1
        defense = 1
        damage = 1
        status = .Running
    }
    
    // create a unit with specified health, defense and damage
    init(spriteNode: SKSpriteNode, hp: Int, def: Int, dmg: Int) {
        
        // sprite kit
        sprite = spriteNode
        
        // stats
        health = hp
        defense = def
        damage = dmg
        status = .Running
    }
    
    // set a new status for the unit
    func setStatus(newStatus: Status) {
        status = newStatus
    }
    
    // deducts health depending on amount of damage dealt
    func tookDamage(dmg: Int) {
        
        // health cannot be less than 0
        health = max(health - dmg, 0)
    }
    
}