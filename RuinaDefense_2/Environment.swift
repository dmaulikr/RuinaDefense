//
//  Environment.swift
//  RuinaDefense_2
//
//  Created by Huynh Nguyen on 12/15/15.
//  Copyright © 2015 Ricardo Guntur. All rights reserved.
//

import Foundation
import SpriteKit

class Environment {
    
    // Environment SpriteNode names
    let backgroundName = "background"
    let snowParticleName = "heavySnowParticle"
    let flameParticleName = "flameParticle"
    let flameParticleCount = 4
    
    // Environment SpriteKitNodes
    var background: SKSpriteNode
    var snowParticle: SKEmitterNode
    var flameParticles: [SKEmitterNode] = []

    
    // Environment variables
    
    
    // Initializer
    init() {
        
        // initialize SpriteKitNodes
        background = SKSpriteNode(imageNamed: backgroundName)
        snowParticle = NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource(snowParticleName, ofType: "sks")!) as! SKEmitterNode
        
        // initialize 4 flames, two per castle
        for(var i = 0; i < flameParticleCount; i++) {
            flameParticles[i] = NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("flameParticle", ofType: "sks")!) as! SKEmitterNode
        }
        
        // set up SpriteKitNodes' properties
        setUpBackground()
        setUpSnowParticles()
        setUpFlamesParticles()
        
        // add environment SpriteKitNodes to background
        addAllChildrenToBackground()
    }
    
    func setUpBackground() {
        background.name = backgroundName
        background.anchorPoint = CGPointZero
        background.size.width = 2674
        background.size.height = 768
        background.zPosition = 0
    }
    
    func setUpSnowParticles() {
        snowParticle.zPosition = 6
    }
    
    func setUpFlamesParticles() {
        
        // Set the x and y position of all flame particles
        flameParticles[0].position = CGPoint(x: 84,y: 530)      // Left flag of left castle
        flameParticles[1].position = CGPoint(x: 354,y: 530)     // Right flag of left castle
        flameParticles[2].position = CGPoint(x: 2320,y: 530)    // Left flag of right castle
        flameParticles[3].position = CGPoint(x: 2588,y: 530)    // Right flag of right castle
        
        // Set zPosition for all flame particles to the same level
        for flameParticle in flameParticles {
            flameParticle.zPosition = 6
        }
    }
    
    func addAllChildrenToBackground() {
        
        // Add all children SpriteKit nodes
        background.addChild(snowParticle)   // Snow particle
    
        for flameParticle in flameParticles {
            background.addChild(flameParticle)  // All flame particles
        }
        
        
    }
}