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
    
    //-------------------------Class Variables----------------------//
    
    //Scene
    //let scene = GameScene(fileNamed: "GameScene")
    
    //Back Ground
    let background = SKSpriteNode(imageNamed: "full_background")
    var randomNum = 0 //For random cloud variant spawning
    let rightCastle = SKSpriteNode(imageNamed: "RedCastle")
    
    //HUD
    let hudBar = SKSpriteNode(imageNamed: "hudBar")
    let hudSeparator = SKSpriteNode(imageNamed: "bar")
    let VSImage = SKSpriteNode(imageNamed: "VSImage")
    
        //HUD Buttons
        let spawnButton = SKSpriteNode(imageNamed: "Spawnbutton")
        let menuButton = SKSpriteNode(imageNamed: "menuButton")
    
        //HUD Labels
        var UsernameLabel = SKLabelNode(text: "Username")
        var EnemynameLabel = SKLabelNode(text: "Enemy")
        var gold = 0    //Gold counter
        let GoldLabel = SKLabelNode()
    
        //Options Menu Nodes
        let optionsBG = SKSpriteNode(imageNamed: "popupWindow")
        let optionsClose = SKLabelNode(text: "Close")
    
        //Upgrade Menu Nodes
        let upgradeBG = SKSpriteNode(imageNamed: "popupWindow")
        let upgradeClose = SKLabelNode(text: "Close")
    
            //Pop up menu buttons
            let optionButton = SKSpriteNode(imageNamed: "optionButton")
            let upgradeButton = SKSpriteNode(imageNamed: "upgradeButton")
    
        //Handle Touches
        var selectedNode = SKSpriteNode()
    
    //Other
    var isRunning = true
    
    
    //-----------------------Class Variables End--------------------//
    override func didMoveToView(view: SKView) {
        
        //Set isRunning to true
        isRunning = true
        
        /* Setup your scene here */
        //let frameW = self.frame.size.width  //Size of frame's width
        //let frameH = self.frame.size.height //Size of frame's height
        
        //Handle touches
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePanFrom:"))
        self.view!.addGestureRecognizer(gestureRecognizer)
        
        // add background
        background.name = "background"
        background.anchorPoint = CGPointZero
        background.size.width = 2674
        background.size.height = 768
        background.zPosition = 0
        self.addChild(background)
        
        
        // add castle
        rightCastle.position = CGPoint(x: CGRectGetMinX(self.frame)+80, y: 420)
        rightCastle.setScale(2.0)
        rightCastle.zPosition = 1
        background.addChild(rightCastle)
        
        //HANDLE PHYSICS FOR SCENE------------------------------------------------
        
        //Physics body that borders the screen. Set slightly above so there is space for hud
        let collisionFrame = CGRectInset(background.frame, -2000, 240.0)    //There is a problem here. Captain does not spawn when view is to the right
        //might have fixed problem by changing # to -2000. Not sure the consequences tho
        physicsBody = SKPhysicsBody(edgeLoopFromRect: collisionFrame)
        
        //Set friction of the physics body to 0
        physicsBody?.friction = 0
        
        
        //Add gravity
        physicsWorld.gravity = CGVectorMake(0, -9.8);
        //---------------------------------------------------------------
        
        //Add HUD Buttons
        addHud()
        
        //-------------------------------Add Clouds-------------------------------
        addGameClouds()
        NSTimer.every(15.0.seconds) {
            
            //If game is running
            if self.isRunning {
                
                //Add clouds
            self.addGameClouds()
            }
        }
        

        //-------------------------------Gold Increment-------------------------------
        //initialize gold to 0
        gold = 0
        NSTimer.every(1.second) {
            
            if self.isRunning {
                self.gold = self.gold + 1
                print("Gold: ", self.gold)
                self.GoldLabel.text = "Gold \(self.gold)"
                //Continues running when going back to menu scene -- bool will NOT fix. It will call another instance of the timer, doubling hte gold per second
                //Continues running when opening pop up menu -- can fix with isRunning bool
            }
        }
        
        
        //-------------------------------Background Music-------------------------------
        print("Play music")
        let GameSceneMusic = SKAudioNode(fileNamed: "GameSceneMusic.wav") //CURRENTLY DOESN'T PLAY
        GameSceneMusic.autoplayLooped = true
        addChild(GameSceneMusic)
        
    }
    
    //-------------------------------HEADS UP DISPLAY-------------------------------
    func addHud() {
        
        //Add hud background
        hudBar.position = CGPoint(x: CGRectGetMidY(self.frame)+293, y: 100)
        hudBar.size.height = 170
        hudBar.size.width = 1340
        hudBar.zPosition = 2
        self.addChild(hudBar)
        
        
        //Hud separator
        hudSeparator.position = CGPoint(x: CGRectGetMidX(hudBar.frame), y: 103)
        hudSeparator.zPosition = 4
        hudSeparator.setScale(0.3)
        hudSeparator.size.height = 170
        self.addChild(hudSeparator)
        
        
        //Create spawn button
        spawnButton.setScale(0.5)
        spawnButton.position = CGPoint(x:1050, y:100)
        spawnButton.zPosition = 3
        self.addChild(spawnButton)
        
        //ON THE BOTTOM
        //Menu button
        menuButton.name = "menu"
        menuButton.position = CGPoint(x:110, y:CGRectGetMidY(hudBar.frame))
        menuButton.zPosition = 3
        menuButton.setScale(0.2)
        self.addChild(menuButton)
        
        //Options Button
        optionButton.name = "option"
        optionButton.position = CGPoint(x:210, y:CGRectGetMidY(hudBar.frame))
        optionButton.zPosition = 3
        optionButton.setScale(0.2)
        self.addChild(optionButton)
        
        //Upgrade label
        upgradeButton.name = "upgrade"
        upgradeButton.position = CGPoint(x:310, y:CGRectGetMidY(hudBar.frame))
        upgradeButton.zPosition = 3
        upgradeButton.setScale(0.2)
        self.addChild(upgradeButton)
        
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
        VSImage.position = CGPoint(x:CGRectGetMidX(self.frame), y: 670)
        VSImage.setScale(0.70)
        VSImage.zPosition = 3
        self.addChild(VSImage)
        
        //Gold label -- should start incrementing when game scene starts
        GoldLabel.fontColor = SKColor .blackColor()
        GoldLabel.fontSize = 35
        GoldLabel.position = CGPoint(x:90, y:650)
        GoldLabel.zPosition = 3
        self.addChild(GoldLabel)
        
    }
    
    
    //ADD GAME CLOUDS
    private func addGameClouds() {
        
        //Random Number
        randomNum = Int(arc4random_uniform(2))
        
        //Clouds
        let gameCloud1 = SKSpriteNode(imageNamed: "gameCloud.png")
        let gameCloud2 = SKSpriteNode(imageNamed: "gameCloud2.png")
        
        //Create cloud variant 1
        //gameCloud1.name = "GameCloud1"
        gameCloud1.anchorPoint = CGPointZero
        
        //Set cloud position between y coordinates 200 and 300
        let randomHeight = CGFloat(arc4random_uniform(200) + 50)
        gameCloud1.position = CGPointMake(-300, CGRectGetMidY(self.frame) + randomHeight)
        
        gameCloud1.zPosition = 3
        gameCloud1.setScale(0.7)
        
        //Create cloud variant 2
        //gameCloud2.name = "GameCloud2"
        gameCloud2.anchorPoint = CGPointZero
        
        //Set cloud position between y coordinates 200 and 300
        gameCloud2.position = CGPointMake(-300, CGRectGetMidY(self.frame) + randomHeight)
        
        gameCloud2.zPosition = 3
        gameCloud2.setScale(0.7)
        
        //Movement
        let floatRight = SKAction.moveByX(2700, y: 0, duration: 60)
        let finishedMoving = SKAction.removeFromParent()
        let moveCloud = SKAction.sequence([floatRight, finishedMoving])
        
        //Add cloud to scene -- choosing which randomly
        print("Random Num: ", randomNum)
        if (randomNum == 0) {
            background.addChild(gameCloud2)
            gameCloud2.runAction(moveCloud)
        }
        
        if(randomNum == 1) {
            background.addChild(gameCloud1)
            gameCloud1.runAction(moveCloud)
        }
        
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
        captain.position = CGPoint(x: 50, y: 430)
        
        captain.zPosition = 3;
        
        //Physics of Captain
        
        captain.physicsBody = SKPhysicsBody(circleOfRadius: captain.frame.width * 0.3)  //Create physics body for captain
        captain.physicsBody?.friction = 0
        captain.physicsBody?.restitution = 0
        captain.physicsBody?.linearDamping = 0
        captain.physicsBody?.angularDamping = 0
        captain.physicsBody?.allowsRotation = false
        
        print("Add Captain")
        background.addChild(captain)
        
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
            if menuButton.containsPoint(location) {
                
                //Remove some nodes
                background.removeFromParent()
                hudSeparator.removeFromParent()
                hudBar.removeFromParent()
                spawnButton.removeFromParent()
                UsernameLabel.removeFromParent()
                EnemynameLabel.removeFromParent()
                optionButton.removeFromParent()
                upgradeButton.removeFromParent()
                menuButton.removeFromParent()
                GoldLabel.removeFromParent()
                VSImage.removeFromParent()
                
                print("Menu Button Pressed")
                let Menu_scene = MenuScene(size: self.size)
                let transition = SKTransition.fadeWithDuration(1.0)
                
                Menu_scene.scaleMode = SKSceneScaleMode.AspectFill
                
                //transition to scene
                self.scene!.view?.presentScene(Menu_scene, transition: transition)
            }
            
            //OPTIONS BUTTON PRESSED
            if optionButton.containsPoint(location) {
                print("game options button pressed")
                
                
                //pause the game
                self.paused = true
                isRunning = false
                
                //pop up options
                openOptionsMenu()
            }
            
            
            //UPGRADE BUTTON PRESSED
            if upgradeButton.containsPoint(location) {
                print("upgrade button pressed")
                
                //pause the game
                self.paused = true
                isRunning = false
                
                //pop up upgrade menu
                openUpgradeMenu()
            }
            
            
            
            
            
            
            
            
            //HANDLE OPTIONS MENU BUTTON TOUCHES -- THESE 'EXIST' EVEN AFTER BEING CLOSED.
            //Hulls solution: displace it and then put it back (not great but would work)
            if optionsClose.containsPoint(location) {
                print("options close button pressed")
                
                //Move the menu buttons off screen
                optionsClose.position = CGPoint(x: -50, y: -50)
                
                //Remove all nodes associated with options menu
                optionsClose.removeFromParent()
                optionsBG.removeFromParent()
                
                //resume scene
                isRunning = true
                self.paused = false
            }
            
            if upgradeClose.containsPoint(location) {
                print("upgrade close button pressed")
                
                //Move the menu buttons off screen
                upgradeClose.position = CGPoint(x: -50, y: -50)
                
                //Remove all nodes associated with upgrade menu
                upgradeClose.removeFromParent()
                upgradeBG.removeFromParent()
                
                //resume scene
                isRunning = true
                self.paused = false
            }
        }
    }
    
    //OPEN OPTIONS MENU
    func openOptionsMenu() {
        
        //Options menu background -- PARENT NODE
        optionsBG.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)+150)
        optionsBG.zPosition = 10
        optionsBG.setScale(0.7)
        
        
        
        //CHILD NODES------
        
        //Close button
        optionsClose.fontColor = SKColor.blackColor()
        optionsClose.fontSize = 50
        optionsClose.position = CGPoint(x: CGRectGetMidX(optionsBG.frame), y: CGRectGetMidY(optionsBG.frame))
        optionsClose.zPosition = 100
        
        //Add to view
        self.addChild(optionsClose) //When added as child of optionsBG -- it doesn't appear
        self.addChild(optionsBG)
        
    }
    
    //OPEN UPGRADE MENU
    func openUpgradeMenu() {
        
        //Upgrade menu background -- PARENT NODE
        upgradeBG.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)+150)
        upgradeBG.zPosition = 10
        upgradeBG.setScale(0.7)
        
        //CHILD NODES-------
        
        //Close Button
        upgradeClose.fontColor = SKColor.blackColor()
        upgradeClose.fontSize = 50
        upgradeClose.position = CGPoint(x: CGRectGetMidX(upgradeBG.frame), y: CGRectGetMidY(upgradeBG.frame))
        upgradeClose.zPosition = 100
        
        //Add to view
        self.addChild(upgradeBG)
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
        retval.x = CGFloat(max(retval.x, -(background.size.width) + winSize.width))
        retval.y = self.position.y
        
        return retval
    }
    
    func panForTranslation(translation : CGPoint) {
        let position = selectedNode.position
        let aNewPosition = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
        background.position = self.boundLayerPos(aNewPosition)
        
    }
    
}

//TODO: Captain does not spawn when view is to the right
//TODO: The options and upgrade close button exist invisibly even after being closed.
//Maybe the method for popup menus are different?

//TODO: Gold increments even when returning to menu
//TODO: Finish options menu
//TODO: Finish upgrade menu
//TODO: Finish HUD
//Health bar
//Update username

//SET USER INTERACTION TO DISABLED WHEN A POP UP MENU APPEARS

//MUSIC ISSUES:
//When returning to menu from gamescene. Music plays for only am moment, then cuts out. Attemped to fix, didn't work.
//When startin game, music starts for a moment and cuts out