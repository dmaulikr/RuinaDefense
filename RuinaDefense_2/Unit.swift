//
//  Unit.swift
//  RuinaDefense_2
//
//  Created by Huynh Nguyen on 12/12/15.
//  Copyright © 2015 Ricardo Guntur. All rights reserved.
//
import SpriteKit

protocol Unit {
    
    // sprite kit members
    var sprite : SKSpriteNode { get }
    var assetPath : String { get set }
    
    // game mechanic stats
    var health: Int  { get set }
    var defense: Int { get set }
    var power: Int { get set }
    var speed: Int { get set }
    
    //func animate
}