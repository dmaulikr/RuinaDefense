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
        
        self.addChild(myLabel)

        
        //----------------------------SPAWN CAPTAIN-----------------
        let captainAnimatedAtlas = SKTextureAtlas(named: "CapAmericaSOJ")
        var runFrames = [SKTexture]()
        
        let numImages = captainAnimatedAtlas.textureNames.count
        
        for var i=1; i <= numImages; i++ {
            let captainTextureName = "cap\(i)"
            runFrames.append(captainAnimatedAtlas.textureNamed(captainTextureName))
            print(captainTextureName)
        }
        
        captainRunningFrames = runFrames
        
        let firstFrame = captainRunningFrames[0]
        captain = SKSpriteNode(texture: firstFrame)
        captain.position = CGPoint(x: 500, y: 500)
        captain.zPosition = 5;
        self.addChild(captain)
        
        //start animation
        self.runningCaptain()
        
        //NOTE: WHY DOES THIS WORK BUT NOT THE BELOW FUNCTION -- THEY ARE IDENTICAL BESIDES SPAWN LOCATION
        
    }
    
    
    //If captain PRESSED. SPAWN CAPTAIN AND ANIMATE!--------------------------
     func spawnCaptain() {
        print("spawnCaptainCalled")
        let captainAnimatedAtlas = SKTextureAtlas(named: "CapAmericaSOJ")
        var runFrames = [SKTexture]()
        
        let numImages = captainAnimatedAtlas.textureNames.count
        
        for var i=1; i <= numImages; i++ {
            let captainTextureName = "cap\(i)"
            runFrames.append(captainAnimatedAtlas.textureNamed(captainTextureName))
            print(captainTextureName)
        }
        
        captainRunningFrames = runFrames
        
        let firstFrame = captainRunningFrames[0]
        captain = SKSpriteNode(texture: firstFrame)
        captain.position = CGPoint(x: 300, y: 300)
        captain.zPosition = 5;
        self.addChild(captain)
        //-----------------------end captain test-----------------
        
        //start animation
        self.runningCaptain()
        
    }
    
    func runningCaptain() {
        //This is our general runAction method to make our bear walk.
        captain.runAction(SKAction.repeatActionForever(
            SKAction.animateWithTextures(captainRunningFrames,
                timePerFrame: 0.1,
                resize: false,
                restore: true)),
            withKey:"runningInPlaceCaptain")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
//        for touch: AnyObject in touches {
//            let location = touch.locationInNode(self)
//            
//            
//        }
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
