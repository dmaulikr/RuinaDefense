//--------------------------------------------------------------
//  Class: GameScene.swift
//  RuinaDefense

//  Created by Ricardo Guntur on 12/2/15.
//  Copyright © 2015 Ricardo Guntur. All rights reserved.
//--------------------------------------------------------------

import SpriteKit
import Foundation

class GameScene: SKScene {
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let frameW = self.frame.size.width  //Size of frame's width
        let frameH = self.frame.size.height //Size of frame's height
        
        //Handle touches
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePanFrom:"))
        self.view!.addGestureRecognizer(gestureRecognizer)
        
        //Add background
        skyline.name = "skyline"
        skyline.anchorPoint = CGPointZero
        skyline.size.width = 2674   //Width of skyline is 2x the frame
        skyline.zPosition = 0
        //self.addChild(skyline)
        
        foreground.name = "foreground"
        foreground.anchorPoint = CGPointZero
        foreground.size.width = 2674    //Width of foreground is 2x the frame
        foreground.zPosition = 1
        
        self.scene?.addChild(foreground) //Currently, the foreground is not transparent. Need to stitch original photo correctly
        
        //Shows the hud
        showHud()
        
        //HANDLE PHYSICS FOR SCENE------------------------------------------------
        
        //Physics body that borders the screen. Set slightly above so there is space for hud
        let collisionFrame = CGRectInset(foreground.frame, 0, 150.0)    //There is a problem here. Captain does not spawn when view is to the right
        physicsBody = SKPhysicsBody(edgeLoopFromRect: collisionFrame)
        
        //Set friction of the physics body to 0
        physicsBody?.friction = 0
        
        
        //Add gravity
        physicsWorld.gravity = CGVectorMake(0, -9.8);
        //---------------------------------------------------------------
        
        
        //Creates a label in the middle of the screen
//        myLabel.name = "label"
//        myLabel.fontSize = 35
//        myLabel.position = CGPoint(x: frameW / 2, y: frameH / 2)
//        self.addChild(myLabel)

        //Create spawn button
        spawnButton = SKSpriteNode(imageNamed: "Spawnbutton")
        spawnButton.setScale(0.5)
        
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
        captain.position = CGPoint(x: 50, y: 400)
        
        captain.zPosition = 3;
        
        //Physics of Captain

        captain.physicsBody = SKPhysicsBody(circleOfRadius: captain.frame.width * 0.3)  //Create physics body for captain
        captain.physicsBody?.friction = 0
        captain.physicsBody?.restitution = 0
        captain.physicsBody?.linearDamping = 0
        captain.physicsBody?.angularDamping = 0
        captain.physicsBody?.allowsRotation = false
        
        print("Add Captain")
        foreground.addChild(captain)
        
        //start animation
        print("Start animation")
        self.runningCaptain()
        
        //Move captain rightward for 2674 in 7 seconds -- should change
        let moveRight = SKAction.moveByX(2674, y:0, duration:7.0)
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
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    //Creates Hud
    func showHud() {
        
        //Creates hud with starting coordinates 0,0 and size of ihpone 6 frame
        let myHud = hud(frame: CGRect(x: 0, y: 0, width: 1337, height: 750))
        
        self.view?.addSubview(myHud)
        
        
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
    
    //HANDLE Moving Scene
    
    func handlePanFrom(recognizer : UIPanGestureRecognizer) {
        if recognizer.state == .Began {
            var touchLocation = recognizer.locationInView(recognizer.view)
            touchLocation = self.convertPointFromView(touchLocation)
            
            self.selectNodeForTouch(touchLocation)
        } else if recognizer.state == .Changed {
            var translation = recognizer.translationInView(recognizer.view!)
            translation = CGPoint(x: translation.x, y: -translation.y)
            
            self.panForTranslation(translation)
            
            recognizer.setTranslation(CGPointZero, inView: recognizer.view)
        } else if recognizer.state == .Ended {
                let scrollDuration = 0.4
                let velocity = recognizer.velocityInView(recognizer.view)
                let pos = selectedNode.position
                
                // This just multiplies your velocity with the scroll duration.
                let p = CGPoint(x: velocity.x * CGFloat(scrollDuration), y: velocity.y * CGFloat(scrollDuration))
                
                var newPos = CGPoint(x: pos.x + p.x, y: pos.y + p.y)
                newPos = self.boundLayerPos(newPos)
                selectedNode.removeAllActions()
                
                let moveTo = SKAction.moveTo(newPos, duration: scrollDuration)
                moveTo.timingMode = .EaseOut
                selectedNode.runAction(moveTo)
        }
    }

    
    func selectNodeForTouch(touchLocation : CGPoint) {

        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if touchedNode is SKSpriteNode {

            if !selectedNode.isEqual(touchedNode) {
                selectedNode.removeAllActions()
                
                selectedNode = touchedNode as! SKSpriteNode
                
            }
        }
    }
    
    func boundLayerPos(aNewPosition : CGPoint) -> CGPoint {
        let winSize = self.size
        var retval = aNewPosition
        retval.x = CGFloat(min(retval.x, 0))
        retval.x = CGFloat(max(retval.x, -(foreground.size.width) + winSize.width))
        retval.y = self.position.y
        
        return retval
    }
    
    func panForTranslation(translation : CGPoint) {
        let position = selectedNode.position
            let aNewPosition = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
            foreground.position = self.boundLayerPos(aNewPosition)
        
    }
    
}

//TODO: Captain does not spawn when view is to the right
//TODO: Captain should ONLY disappear if it has reached the other end (for testing) -- currently disappears after it for 7 seconds
