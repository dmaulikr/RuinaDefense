//--------------------------------------------------------------
//  Class: GameScene.swift
//  RuinaDefense
//
//  Created by Ricardo Guntur on 12/2/15.
//  Copyright © 2015 Ricardo Guntur. All rights reserved.
//--------------------------------------------------------------

import SpriteKit
import Foundation

class GameScene: SKScene {
    
    
    override func didMoveToView(view: SKView) {
        
        /* Setup your scene here */
        //let frameW = self.frame.size.width  //Size of frame's width
        //let frameH = self.frame.size.height //Size of frame's height
        
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
        //showHud()
        
        //HANDLE PHYSICS FOR SCENE------------------------------------------------
        
        //Physics body that borders the screen. Set slightly above so there is space for hud
        let collisionFrame = CGRectInset(foreground.frame, 0, 150.0)    //There is a problem here. Captain does not spawn when view is to the right
        physicsBody = SKPhysicsBody(edgeLoopFromRect: collisionFrame)
        
        //Set friction of the physics body to 0
        physicsBody?.friction = 0
        
        
        //Add gravity
        physicsWorld.gravity = CGVectorMake(0, -9.8);
        //---------------------------------------------------------------
        
        //Add HUD Buttons
        addHud()
        
    }
    
    //Create hud labels, buttons, health, username, etc
    func addHud() {
        
        //Create spawn button
        spawnButton = SKSpriteNode(imageNamed: "Spawnbutton")
        spawnButton.setScale(0.5)
        
        spawnButton.position = CGPoint(x:1050, y:100)
        spawnButton.zPosition = 3
        self.addChild(spawnButton)
        
        //ON THE BOTTOM
        //Menu button
        MenuLabel.name = "menu"
        MenuLabel.fontColor = SKColor .blackColor()
        MenuLabel.fontSize = 35
        MenuLabel.position = CGPoint(x:100, y:50)
        MenuLabel.zPosition = 3
        self.addChild(MenuLabel)
        
        //Options Label
        OptionLabel.name = "option"
        OptionLabel.fontColor = SKColor .blackColor()
        OptionLabel.fontSize = 35
        OptionLabel.position = CGPoint(x:200, y:50)
        OptionLabel.zPosition = 3
        self.addChild(OptionLabel)
        
        //Upgrade label
        UpgradeLabel.name = "upgrade"
        UpgradeLabel.fontColor = SKColor .blackColor()
        UpgradeLabel.fontSize = 35
        UpgradeLabel.position = CGPoint(x:330, y:50)
        UpgradeLabel.zPosition = 3
        self.addChild(UpgradeLabel)
        
        //ON THE TOP
        //Username label -- should get information when game starts
        UsernameLabel.fontColor = SKColor .blackColor()
        UsernameLabel.fontSize = 35
        UsernameLabel.position = CGPoint(x:100, y:700)
        UsernameLabel.zPosition = 3
        self.addChild(UsernameLabel)
        
        //Enemyname label
        EnemynameLabel.fontColor = SKColor .blackColor()
        EnemynameLabel.fontSize = 35
        EnemynameLabel.position = CGPoint(x:CGRectGetMaxX(self.frame)-100, y:700)
        EnemynameLabel.zPosition = 3
        self.addChild(EnemynameLabel)
        
        //VS label
        VSLabel.fontColor = SKColor .blackColor()
        VSLabel.fontSize = 35
        VSLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y: 700)
        VSLabel.zPosition = 3
        self.addChild(VSLabel)
        
        //Gold label -- should start incrementing when game scene starts
        GoldLabel.fontColor = SKColor .blackColor()
        GoldLabel.fontSize = 35
        GoldLabel.position = CGPoint(x:65, y:650)
        GoldLabel.zPosition = 3
        self.addChild(GoldLabel)
        
//        optionsClose.fontColor = SKColor .blackColor()
//        optionsClose.fontSize = 35
//        optionsClose.position = CGPoint(x: CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
//        optionsClose.zPosition = 11
//        
//        self.addChild(optionsClose)
        
        //Border for the lower part of the scene for buttons and minion shop
        
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
    

    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Loop over all the touches in this event
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.locationInNode(self)
            
            
            //---------------HANDLE ALL SCENE BUTTONS------------
            
            
            // Check if the location of the touch is within the button's bounds
            if spawnButton.containsPoint(location) {
                print("Spawn Button Pressed!")
                spawnCaptain()
            }
            
            //MENU BUTTON PRESSED
            if MenuLabel.containsPoint(location) {
                print("Menu Button Pressed")
                let Menu_scene = MenuScene(size: self.size)
                let transition = SKTransition.fadeWithDuration(1.0)
                
                Menu_scene.scaleMode = SKSceneScaleMode.AspectFill
                
                //transition to scene
                self.scene!.view?.presentScene(Menu_scene, transition: transition)
            }
            
            //OPTIONS BUTTON PRESSED
            if OptionLabel.containsPoint(location) {
                print("game options button pressed")
                
                //pop up options
                openOptionsMenu()
            }
            
            
            //UPGRADE BUTTON PRESSED
            if UpgradeLabel.containsPoint(location) {
                print("upgrade button pressed")
                
                //pop up upgrade menu
                openUpgradeMenu()
            }
            
            
            
            
            
            
            
            
            //HANDLE OPTIONS MENU BUTTON TOUCHES
            if optionsClose.containsPoint(location) {
                print("options close button pressed")
                
                //Remove all nodes associated with options menu
                optionsClose.removeFromParent()
                optionsBG.removeFromParent()
            }
            
            if upgradeClose.containsPoint(location) {
                
                //Remove all nodes associated with upgrade menu
                print("upgrade close button pressed")
                upgradeClose.removeFromParent()
                upgradeBG.removeFromParent()
            }
        }
    }
    
    //OPEN OPTIONS MENU
    func openOptionsMenu() {
        
        //Options menu background -- PARENT NODE
        optionsBG.fillColor = SKColor.blackColor()
        optionsBG.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        optionsBG.zPosition = 10
        
        self.addChild(optionsBG)
        
        //CHILD NODES--------
        
        //Close button
        //Can't see but exists
        optionsClose.fontColor = SKColor.whiteColor()
        optionsClose.fontSize = 50
        optionsClose.position = CGPoint(x: CGRectGetMidX(optionsBG.frame), y: CGRectGetMidY(optionsBG.frame))
        optionsClose.zPosition = 100
        self.addChild(optionsClose) //When added as child of optionsBG -- it doesn't appear
        
    }
    
    //OPEN UPGRADE MENU
    func openUpgradeMenu() {
        
        //Upgrade menu background -- PARENT NODE
        upgradeBG.fillColor = SKColor.blackColor()
        upgradeBG.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        upgradeBG.zPosition = 10
        self.addChild(upgradeBG)
        
        //CHILD NODES
        upgradeClose.fontColor = SKColor.whiteColor()
        upgradeClose.fontSize = 50
        upgradeClose.position = CGPoint(x: CGRectGetMidX(upgradeBG.frame), y: CGRectGetMidY(upgradeBG.frame))
        upgradeClose.zPosition = 100
        self.addChild(upgradeClose)
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
