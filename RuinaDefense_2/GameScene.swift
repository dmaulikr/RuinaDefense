//
//  GameScene.swift
//  RuinaDefense_2
//
//  Created by Student on 12/2/15.
//  Copyright (c) 2015 Ricardo Guntur. All rights reserved.
//

import SpriteKit
import Foundation

class GameScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let frameW = self.frame.size.width
        let frameH = self.frame.size.height
        
        
        //Shows the hud
        showHud()
        
        //Creates a label in the middle of the screen
        myLabel.name = "label"
        myLabel.fontSize = 35
        myLabel.position = CGPoint(x: frameW / 2, y: frameH / 2)
        
        //self.addChild(myLabel)

        //Create button
        spawnButton = SKSpriteNode(imageNamed: "Spawnbutton")
        spawnButton.setScale(0.5)
        // Put it in the center of the scene
        spawnButton.position = CGPoint(x:1050, y:100)
        spawnButton.zPosition = 5
        self.addChild(spawnButton)
        
    }
    
    
    //If captain PRESSED. SPAWN CAPTAIN AND ANIMATE!--------------------------
    //Captain does NOT spawn if button from hud is pressed.
    //Captain DOES spawn if spritenode button from scene is pressed.
      func spawnCaptain() {
        print("Spawning Captain")
        let captainAnimatedAtlas = SKTextureAtlas(named: "CapAmericaSOJ")
        var runFrames = [SKTexture]()
        let numImages = captainAnimatedAtlas.textureNames.count
        
        //Loop through each image name and append into frames
        for var i=1; i <= numImages; i++ {
            let captainTextureName = "cap\(i)"
            runFrames.append(captainAnimatedAtlas.textureNamed(captainTextureName))
            print(captainTextureName)
        }
    
        captainRunningFrames = runFrames
        
        let firstFrame = captainRunningFrames[0]
       
        //Create captain sprite with initial texture
        captain = SKSpriteNode(texture: firstFrame)
        
        //Positioned on bottom left of screen
        captain.position = CGPoint(x: 1, y: 200)
        captain.zPosition = 3;
        
        print("Add Captain")
        self.addChild(captain)
        
        //start animation
        print("Start animation")
        self.runningCaptain()
        
        //Move captain rightward
        let moveRight = SKAction.moveByX(1340, y:0, duration:5.0)
        //Removes node from scene
        let finishedRunning = SKAction.removeFromParent()
        
        //Moves captain right, when move is finished, remove node.
        let sequence = SKAction.sequence([moveRight,finishedRunning])
        captain.runAction(sequence)
        
    }
    
    //Animates the captain sprite with running
    func runningCaptain() {
        captain.runAction(SKAction.repeatActionForever(
            SKAction.animateWithTextures(captainRunningFrames,
                timePerFrame: 0.1,
                resize: false,
                restore: true)),
            withKey:"runningInPlaceCaptain")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */

        
        
        
        
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Loop over all the touches in this event
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.locationInNode(self)
            
            // Check if the location of the touch is within the button's bounds
            if spawnButton.containsPoint(location) {
                print("Spawn Button Pressed!")
                spawnCaptain()
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    //Creates Hud
    func showHud() {
        
        //Creates hud with starting coordinates 0,0 and size of ihpone 6 frame
        let myHud = hud(frame: CGRect(x: 0, y: 0, width: 1337, height: 750))
        
        self.view?.addSubview(myHud)
        
        
    }
}
