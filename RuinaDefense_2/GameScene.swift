//--------------------------------------------------------------
//  Class: GameScene.swift
//  RuinaDefense
//
//  Created by Ricardo Guntur on 12/2/15.
//  Copyright © 2015 Ricardo Guntur. All rights reserved.
//--------------------------------------------------------------

import SpriteKit
import Foundation
import AVFoundation

//Global Variables
var isRunning = false   //Is the game running

class GameScene: SKScene {
    
    //-------------------------Class Variables----------------------//

    // environment
    var environment = Environment()
    var leftBorder = CGRect(x: 0, y: 260, width: 150, height: 200)  // pos = left side, floor height.  width = left border to left spawn
    var rightBorder = CGRect(x: 2500, y: 260, width: 174, height:  200) // pos = right castle spawn, width = right spawn to right border
    
    //Back Ground
    var background = SKSpriteNode()
    var randomNum = 0 //For random cloud variant spawning
    
    //Music
    var musicPlaying = true // Utilized to mute and manage music
    
    // SKLabels
    let optionsMenuLabel = SKLabelNode(fontNamed: "Papyrus")
    let optionsClose = SKLabelNode(fontNamed: "Papyrus")
    let upgradeMenuLabel = SKLabelNode(fontNamed: "Papyrus")
    let upgradeClose = SKLabelNode(fontNamed: "Papyrus")
    
    //Options Menu Nodes
    let optionsBG = SKSpriteNode(imageNamed: "popupWindow")
    let playMusicButton = SKSpriteNode(imageNamed: "playMusicButton")
    let pauseMusicButton = SKSpriteNode(imageNamed: "pauseMusicButton")

    //Upgrade Menu Nodes
    let upgradeBG = SKSpriteNode(imageNamed: "popupWindow")
    let smallPane = SKSpriteNode(imageNamed: "smallPane1")
    let smallPane2 = SKSpriteNode(imageNamed: "smallPane1")
    let swordsmanUpgradeLabel = SKLabelNode(fontNamed: "Papyrus")
    let knightUpgradeLabel = SKLabelNode(fontNamed: "Papyrus")
    
    let purchaseSwordsmanButton = SKSpriteNode(imageNamed: "purchaseButton")
    let purchaseKnightButton = SKSpriteNode(imageNamed: "purchaseButton")
    
    var purchasedSwordsmanUpgrade = false
    var purchasedKnightUpgrade = false
    
    //Upgraded Spawn Buttons -- CONNECT THIS WITH THE UPGRADED UNITS
    let upgradedSwordsmanSpawnButton = SKSpriteNode(imageNamed: "upgradedSpawnButton")
    let upgradedKnightSpawnButton = SKSpriteNode(imageNamed: "upgradedSpawnButton")
    
    //Handle Touches
    var selectedNode = SKSpriteNode()
    
    //Other
    var clickable = true    //Used to prevent menus from opening more than once
    
    // Animation Sheets
    let Hero1_Sheet = Hero1Sheet() //Animations for Hero1
    let Hero2_Sheet = Hero2Sheet() //Animations for Hero2
    let Enemy1_Sheet = Skeleton1Sheet() //Animations for Skeleton1
    let Enemy2_Sheet = Skeleton2Sheet() //Animations for Skeleton1
    
    var playerUnits = Queue<Unit>()
    var enemyUnits = Queue<Unit>()
    
    //Burn
    let bloodEmitter = SKEmitterNode(fileNamed: "sparkParticle")
    
    // collision stuff
    var timeOfLastAttack: CFTimeInterval = 0.0
    let timePerAttack: CFTimeInterval = 1.0
    var timeOfLastDeathAnimation: CFTimeInterval = 0.0
    let timePerDeathAnimation: CFTimeInterval = 3.0
    
    //-----------------------Class Variables End--------------------//
    
    
    override func didMoveToView(view: SKView) {
        isRunning = true
  
        //Handle touches
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePanFrom:"))
        self.view!.addGestureRecognizer(gestureRecognizer)
        
        // Set up environment
        background = environment.background
        self.addChild(background)
   
        
        // Set up hud
        let HUD = hud(gameview: self)
        
        //-------------------------------Add Clouds-------------------------------
        addGameClouds() //Add initial cloud
        
        NSTimer.every(15.0.seconds) {
            
            //If game is running
            if isRunning {
                
                //Add clouds
                self.addGameClouds()
            }
        }
        
        
        
        //-------------------------------Background Music-------------------------------
        print("Play music")
    
            let musicPath = NSBundle.mainBundle().URLForResource("GameSceneMusic", withExtension: "mp3")
        
            do {
                audioPlayer = try AVAudioPlayer(contentsOfURL: musicPath!)
            }
            catch {
                fatalError("Error loading \(musicPath)")
            }
        
        audioPlayer.prepareToPlay()
        audioPlayer.currentTime = 28
        
        //Play background music
        audioPlayer.play()
        
        //Loop Forever
        audioPlayer.numberOfLoops = -1
        
    }
    
    
    
    ////----------------------ADD GAME CLOUDS----------------------
    private func addGameClouds() {
        
        //Random Number
        randomNum = random() % 2
        
        //Clouds
        let gameCloud1 = SKSpriteNode(imageNamed: "gameCloud.png")
        let gameCloud2 = SKSpriteNode(imageNamed: "gameCloud2.png")
        
        //Create cloud variant 1
        gameCloud1.anchorPoint = CGPointZero
        
        //Set cloud position between y coordinates 200 and 300
        let randomHeight = CGFloat(arc4random_uniform(200) + 50)
        gameCloud1.position = CGPointMake(-300, CGRectGetMidY(self.frame) + randomHeight)
        
        gameCloud1.zPosition = 3
        gameCloud1.setScale(0.7)
        
        //Create cloud variant 2
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
    
    //========================================UNIT SPAWNING========================================
    
    //----------------------HERO SPAWNING----------------------
    func spawnHero1() {
        
        let hero1 = SKSpriteNode(texture: Hero1_Sheet.run_1_())
        
        //Set position and physics body stuff
        hero1.name = "hero1"
        hero1.position = CGPoint(x: 160, y: 260)
        hero1.zPosition = 3
        hero1.setScale(0.5)

        //Add to scene
        background.addChild(hero1)
        
        // Create the unit
        let unit = Unit(spriteNode: hero1, hp: 5, def: 0, dmg: 1)
        
        //Animates the hero
        let run = SKAction.animateWithTextures(Hero1_Sheet.run(), timePerFrame: 0.1)
        let action = SKAction.repeatActionForever(run)
        hero1.runAction(action)
        
        //Moves hero rightward forever
        moveRight(hero1)
        
        // Add to player's spawned units
        playerUnits.push(unit)
        
    }
    
    func spawnHero2() {
        
        let hero2 = SKSpriteNode(texture: Hero2_Sheet.run_1_())
        
        //Set position and physics body stuff
        hero2.name = "hero2"
        hero2.position = CGPoint(x: 160, y: 260)
        hero2.zPosition = 3
        hero2.setScale(0.5)
        
        //Add to scene
        background.addChild(hero2)
        
        let unit = Unit(spriteNode: hero2, hp: 5, def: 0, dmg: 2)
        
        //Animates the hero
        let run = SKAction.animateWithTextures(Hero2_Sheet.run(), timePerFrame: 0.1)
        let action = SKAction.repeatActionForever(run)
        hero2.runAction(action)
        
        //Moves hero rightward forever
        moveRight(hero2)
        
        // Add to player's spawned units
        playerUnits.push(unit)
    }
    
    func spawnHero3() {
  
    }
    
    //----------------------ENEMY SPAWNING----------------------
    func spawnEnemy1() {
    let enemy1 = SKSpriteNode(texture: Enemy1_Sheet.walk_1_())
        
        //Set position and physics body stuff
        enemy1.name = "enemy1"
        enemy1.position = CGPoint(x: 2500, y: 260)
        enemy1.zPosition = 3
        enemy1.setScale(0.5)
        //enemy1.physicsBody?.mass = 500
        enemy1.xScale = enemy1.xScale * -1

        //Add to scene
        background.addChild(enemy1)
        
        let unit = Unit(spriteNode: enemy1, hp: 5, def: 0, dmg: 1)
        
        //Animates the hero
        let run = SKAction.animateWithTextures(Enemy1_Sheet.walk(), timePerFrame: 0.1)
        let action = SKAction.repeatActionForever(run)
        enemy1.runAction(action)
        
        //Move enemy leftward
        moveLeft(enemy1)
        
        // add to enemy's units
        enemyUnits.push(unit)
    }
    
    func spawnEnemy2() {
        let enemy2 = SKSpriteNode(texture: Enemy2_Sheet.walk_1_())
        
        //Set position and physics body stuff
        enemy2.name = "enemy2"
        enemy2.position = CGPoint(x: 2500, y: 260)
        enemy2.zPosition = 3
        enemy2.setScale(0.5)
        enemy2.xScale = enemy2.xScale * -1
        //Add to scene
        background.addChild(enemy2)
        
        let unit = Unit(spriteNode: enemy2, hp: 5, def: 0, dmg: 3)
        
        //Animates the hero
        //let run = SKAction.animateWithTextures(Enemy2_Sheet.run(), timePerFrame: 0.033)
        let run = SKAction.animateWithTextures(Enemy2_Sheet.walk(), timePerFrame: 0.1)
        let action = SKAction.repeatActionForever(run)
        enemy2.runAction(action)
        
        //Move enemy leftward
        moveLeft(enemy2)
        
        // add to enemy units
        enemyUnits.push(unit)
    }
    //========================================UNIT SPAWNING END========================================
    
    
    
    //========================================UNIT ANIMATION===========================================
    //Move sprite right -- NO ANIMATION
    func moveRight(sprite: SKSpriteNode) {
        
        //Moves node rightward
        let moveRight = SKAction.moveByX(2674, y:0, duration:10.0)
        
        //Removes node from scene when finished
        //let finishedRunning = SKAction.removeFromParent()
        
        //Moves captain right, when move is finished, remove node.
        //let sequence = SKAction.sequence([moveRight,finishedRunning])
        
        let moveForever = SKAction.repeatActionForever(moveRight)
        sprite.runAction(moveForever)
    }
    
    //Moves sprite left -- NO ANIMATION
    func moveLeft(sprite: SKSpriteNode) {
        
        //Moves node leftward
        let moveLeft = SKAction.moveByX(-2674, y:0, duration:10.0)
        
        //Removes node from scene when finished
        //let finishedRunning = SKAction.removeFromParent()
        
        //Moves captain right, when move is finished, remove node.
        //let sequence = SKAction.sequence([moveLeft,finishedRunning])
        
        let moveForever = SKAction.repeatActionForever(moveLeft)
        sprite.runAction(moveForever)
    }
    
    //========================================UNIT ANIMATION END==========================================
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */

        checkCollision()
        checkEndUnitIdle()
        checkReachedCastle()
        
        if(currentTime - timeOfLastAttack < timePerAttack) {
            return
        }
        
        checkFight()
        checkDeath()
        
        timeOfLastAttack = currentTime

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Loop over all the touches in this event
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.locationInNode(self)
            
            
            //---------------HANDLE ALL SCENE BUTTONS------------
            
            
            // Check if the location of the touch is within the button's bounds
            
            if spawnHero1Button.containsPoint(location) {
                print("Spawn Hero1")
                spawnHero1()
            }
            
            if spawnHero2Button.containsPoint(location) {
                print("Spawn hero2")
                spawnHero2()
            }
            
            
            if spawnEnemy1Button.containsPoint(location) {
                print("Spawn Enemy 1")
                spawnEnemy1()
                
            }
            
            if spawnEnemy2Button.containsPoint(location) {
                print("Spawn Enemy 2")
                spawnEnemy2()
                
            }
            
            if upgradedSwordsmanSpawnButton.containsPoint(location) {
                print("spawn upgraded swordsman")
                
                
            }
            
            if upgradedKnightSpawnButton.containsPoint(location) {
                print("spawn upgraded knight")
                
            }
        

            //------------Upgrade Menu Open-----------
            if optionButton.containsPoint(location) {
                print("game options button pressed")
                
                //If menu isn't open, open menu
                if(clickable == true) {
                    
                    //pause the game
                    self.paused = true
                    isRunning = false
                    
                    //pop up options
                    openOptionsMenu()
                    
                    //Set button to unclickable
                    self.clickable = false
                }
                
                else {
                    print("A menu is already open brah")
                }
            
            }
            
            //------------Upgrade Menu Open-----------
            if upgradeButton.containsPoint(location) {
                print("upgrade button pressed")
                
                //If menu isn't open, open menu
                if(clickable == true) {
                
                    //pause the game
                    self.paused = true
                    isRunning = false
                
                    //pop up upgrade menu
                    openUpgradeMenu()
                    
                    //Set button to unclickable
                    self.clickable = false
                }
                
                else {
                    print("A menu is already open brah")
                }
            
            }
            
            
            //---------------------------Close Menu Buttons---------------------------
            
            //Close Menu buttons
            if optionsClose.containsPoint(location) {
                print("options close button pressed")
                

                
                //Animation: moves sprite up
                let moveUp = SKAction.moveByX(0, y: 530, duration: 1.0)
                let finishedMoving = SKAction.removeFromParent()
                let sequence = SKAction.sequence([moveUp, finishedMoving])
                
                //Move all menu stuff up
                optionsClose.runAction(sequence)
                optionsBG.runAction(sequence)
                playMusicButton.runAction(sequence)
                pauseMusicButton.runAction(sequence)
                optionsMenuLabel.runAction(sequence)
                
                //Set button to clickable
                self.clickable = true
                
                //resume scene
                isRunning = true
                self.paused = false
            }
            
            
            if upgradeClose.containsPoint(location) {
                print("upgrade close button pressed")
                
                
                //Animate menu offscreen
                let moveUp = SKAction.moveByX(0, y: 650, duration: 1.0)
                let finishedMoving = SKAction.removeFromParent()
                let sequence = SKAction.sequence([moveUp, finishedMoving])
                
                //Move all menu stuff up
                upgradeClose.runAction(sequence)
                upgradeBG.runAction(sequence)
                upgradeMenuLabel.runAction(sequence)
                smallPane.runAction(sequence)
                smallPane2.runAction(sequence)
                purchaseSwordsmanButton.runAction(sequence)
                purchaseKnightButton.runAction(sequence)
                swordsmanUpgradeLabel.runAction(sequence)
                knightUpgradeLabel.runAction(sequence)
                
                //Set button to clickable
                self.clickable = true
                
                //resume scene
                isRunning = true
                self.paused = false
            }
            
            //---------------------------Option Menu Buttons---------------------------
            
            if pauseMusicButton.containsPoint(location) {
                print("Pause Music Pressed")
                
                if (musicPlaying == true) {
                    
                    //pause music
                    audioPlayer.pause()
                    
                    //set music playing to false
                    musicPlaying = false
                }
                
            }
            
            if playMusicButton.containsPoint(location) {
                print("Play Music Pressed")
                
                if (musicPlaying == false) {
                 
                    //play music
                    audioPlayer.play()
                    
                    //set music playing to true'
                    musicPlaying = true
                }
            }
            
            //---------------------------Upgrade Menu Buttons---------------------------
            
            //If button is pressed, change its texture and replace the swordsman spawn button with a new button
            if purchaseSwordsmanButton.containsPoint(location) {
                print("Pressed swordsman upgrade button")
                
                //If you haven't purchased this upgrade yet
                if (purchasedSwordsmanUpgrade == false) {
                    
                    print("Purchased Swordsman Upgrade!")
                    
                    //Set new texture for button
                    purchaseSwordsmanButton.texture = SKTexture(imageNamed: "purchasedButton")
                    
                    //Remove original spawn buttons
                    spawnHero1Button.position = CGPoint(x: -50,y: -50)
                    spawnHero1Button.removeFromParent()
                    
                    //replace Spawn Swordsman Button
                    upgradedSwordsmanSpawnButton.position = CGPoint(x:770, y:90)
                    upgradedSwordsmanSpawnButton.zPosition = 3
                    upgradedSwordsmanSpawnButton.setScale(0.6)
                    self.addChild(upgradedSwordsmanSpawnButton)
                    
                    purchasedSwordsmanUpgrade = true
                }
            
                else {
                    print("you already bought this upgrade")
                }
            
            
            }
            
            if purchaseKnightButton.containsPoint(location) {
                print("pressed knight upgrade button")
            
                //If you haven't purchased this upgrade yet
                if (purchasedKnightUpgrade == false) {
                 
                    print("Purchased Knight Upgrade!")
                    
                    //Set new texture for button
                    purchaseKnightButton.texture = SKTexture(imageNamed: "purchasedButton")
                    
                    //Remove original spawn button
                    spawnHero2Button.position = CGPoint(x: -50,y: -50)
                    spawnHero2Button.removeFromParent()
                    
                    //Replace Spawn Knight Button
                    upgradedKnightSpawnButton.position = CGPoint(x:920, y:90)
                    upgradedKnightSpawnButton.zPosition = 3
                    upgradedKnightSpawnButton.setScale(0.6)
                    self.addChild(upgradedKnightSpawnButton)
                    
                    purchasedKnightUpgrade = true
                    
                }
                
                else {
                    print("you already bought this upgrade")
                }
            }
            
            
            //-----------------Menu Button Pressed--------------
            if menuButton.containsPoint(location) {
                
                //Stop Music
                audioPlayer.stop()
                
                //Remove some nodes
                background.removeFromParent()
                
                print("Menu Button Pressed")
                
                let Menu_scene = MenuScene(size: self.size)
                let transition = SKTransition.fadeWithDuration(1.0)
                
                Menu_scene.scaleMode = SKSceneScaleMode.AspectFill
                
                //transition to scene
                self.scene!.view?.presentScene(Menu_scene, transition: transition)
            }
        }
    }
    
    //OPEN OPTIONS MENU
    func openOptionsMenu() {
        
        //Options menu background -- PARENT NODE
        optionsBG.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)+150)
        optionsBG.zPosition = 10
        optionsBG.setScale(0.7)
        
        //Close button
        optionsClose.fontColor = SKColor.blackColor()
        optionsClose.text = "Resume"
        optionsClose.fontSize = 50
        optionsClose.position = CGPoint(x: CGRectGetMidX(optionsBG.frame), y: CGRectGetMidY(optionsBG.frame)-200)
        optionsClose.zPosition = 100
        
        //Options Menu Label
        optionsMenuLabel.text = "Options"
        optionsMenuLabel.fontSize = 50
        optionsMenuLabel.position = CGPoint(x: CGRectGetMidX(optionsBG.frame), y: CGRectGetMidY(optionsBG.frame)+150)
        optionsMenuLabel.zPosition = 13
        optionsMenuLabel.fontColor = SKColor.blackColor()
        
        //Pause music button
        pauseMusicButton.position = CGPoint(x: CGRectGetMidX(optionsBG.frame)-100, y: CGRectGetMidY(optionsBG.frame))
        pauseMusicButton.zPosition = 11
        pauseMusicButton.setScale(0.5)
        
        //Play music button
        playMusicButton.position = CGPoint(x: CGRectGetMidX(optionsBG.frame)+100, y: CGRectGetMidY(optionsBG.frame))
        playMusicButton.zPosition = 11
        playMusicButton.setScale(0.5)
        
        //Add to view
        self.addChild(optionsClose)
        self.addChild(optionsBG)
        self.addChild(optionsMenuLabel)
        self.addChild(playMusicButton)
        self.addChild(pauseMusicButton)
        
    }
    
    //OPEN UPGRADE MENU
    func openUpgradeMenu() {
        
        //Upgrade menu background -- PARENT NODE
        upgradeBG.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)+70)
        upgradeBG.zPosition = 10
        upgradeBG.setScale(0.9)
        
        //Upgrade Menu Label
        upgradeMenuLabel.text = "Upgrades"
        upgradeMenuLabel.fontSize = 50
        upgradeMenuLabel.position = CGPoint(x: CGRectGetMidX(upgradeBG.frame), y: CGRectGetMidY(upgradeBG.frame)+190)
        upgradeMenuLabel.zPosition = 13
        upgradeMenuLabel.fontColor = SKColor.blackColor()
        
        
        //Close Button
        upgradeClose.fontColor = SKColor.blackColor()
        upgradeClose.fontSize = 50
        upgradeClose.text = "Resume"
        upgradeClose.position = CGPoint(x: CGRectGetMidX(upgradeBG.frame), y: CGRectGetMidY(upgradeBG.frame)-260)
        upgradeClose.zPosition = 100
        
        //Small Pane
        smallPane.position = CGPoint(x: CGRectGetMidX(self.frame)-110, y: CGRectGetMidY(self.frame)+130)
        smallPane.zPosition = 13
        smallPane.size.width = 450
        
        //Small Pane 2
        smallPane2.position = CGPoint(x: CGRectGetMidX(self.frame)-110, y: CGRectGetMidY(self.frame)-20)
        smallPane2.zPosition = 13
        smallPane2.size.width = 450
        
        //Swordsmen Upgrade Label
        swordsmanUpgradeLabel.text = "Upgrade Swordsman"
        swordsmanUpgradeLabel.position = CGPoint(x: CGRectGetMidX(self.frame)-70, y: CGRectGetMidY(self.frame)+115)
        swordsmanUpgradeLabel.zPosition = 14
        
        //Knight Upgrade Label
        knightUpgradeLabel.text = "Upgrade Knight"
        knightUpgradeLabel.position = CGPoint(x: CGRectGetMidX(self.frame)-75, y: CGRectGetMidY(self.frame)-33)
        knightUpgradeLabel.zPosition = 14
        
        //Purchase Swordsman Button
        purchaseSwordsmanButton.position = CGPoint(x: CGRectGetMidX(self.frame)+210, y: CGRectGetMidY(self.frame)+130)
        purchaseSwordsmanButton.zPosition = 11
        purchaseSwordsmanButton.setScale(0.7)
        
        //Purchase Knight Button
        purchaseKnightButton.position = CGPoint(x: CGRectGetMidX(self.frame)+210, y: CGRectGetMidY(self.frame)-20)
        purchaseKnightButton.zPosition = 11
        purchaseKnightButton.setScale(0.7)
        
        //Add to view
        self.addChild(upgradeBG)
        self.addChild(upgradeClose)
        self.addChild(upgradeMenuLabel)
        self.addChild(smallPane)
        self.addChild(smallPane2)
        self.addChild(swordsmanUpgradeLabel)
        self.addChild(knightUpgradeLabel)
        self.addChild(purchaseSwordsmanButton)
        self.addChild(purchaseKnightButton)
    }
    
    
    //----------------------SCREEN PANNING-------------------
    
    func handlePanFrom(recognizer : UIPanGestureRecognizer) {
        
        if recognizer.state == .Began {
            var touchLocation = recognizer.locationInView(recognizer.view)
            touchLocation = self.convertPointFromView(touchLocation)
            
            self.selectNodeForTouch(touchLocation)
        }
        
        else if recognizer.state == .Changed {
            var translation = recognizer.translationInView(recognizer.view!)
            translation = CGPoint(x: translation.x, y: -translation.y)
            
            self.panForTranslation(translation)
            
            recognizer.setTranslation(CGPointZero, inView: recognizer.view)
        }
        
        else if recognizer.state == .Ended {
            let scrollDuration = 0.4
            let velocity = recognizer.velocityInView(recognizer.view)
            let pos = selectedNode.position
            
            // This just multiplies your velocity with the scroll duration.
            let p = CGPoint(x: velocity.x * CGFloat(scrollDuration), y: velocity.y * CGFloat(scrollDuration))
            
            var newPos = CGPoint(x: pos.x + p.x, y: pos.y + p.y)
            newPos = self.boundLayerPos(newPos)
            if (selectedNode.name == background.name) {
            selectedNode.removeAllActions()
            }
            
            let moveTo = SKAction.moveTo(newPos, duration: scrollDuration)
            moveTo.timingMode = .EaseOut
            
            //ONLY IF SELECTEDNODE IS BACKGROUND WILL THE ACTION RUN
            if (selectedNode.name == background.name) {
                selectedNode.runAction(moveTo)
            }
        }
        physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectInset(background.frame, 0, 240))
    }
    
    
    //Sets selectedNode to the node you touched.
    func selectNodeForTouch(touchLocation : CGPoint) {
        
        let touchedNodes = self.nodesAtPoint(touchLocation)
        
        for node:SKNode in touchedNodes {
            
            if (!selectedNode.isEqual(node) && node.name == environment.background.name) {
   
                //Set selected node to the node you touched
                selectedNode = node as! SKSpriteNode
            }
        }
        print(selectedNode.name)
    }
    
    //Restricts pan movement to within the visible scene
    func boundLayerPos(aNewPosition : CGPoint) -> CGPoint {
        let winSize = self.size
        var retval = aNewPosition
        retval.x = CGFloat(min(retval.x, 0))
        retval.x = CGFloat(max(retval.x, -(background.size.width) + winSize.width))
        retval.y = self.position.y
        
        return retval
    }
    
    //Allows panning in real time.
    func panForTranslation(translation : CGPoint) {

        //Only if the background is selected.
        if (selectedNode.name == background.name) {
 
            let position = selectedNode.position
            let aNewPosition = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
            background.position = self.boundLayerPos(aNewPosition)
        }
        
        else {

        }
        physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectInset(background.frame, 0, 240))
    }

    func randomHero1Animation() -> [SKTexture] {
        let randomNumber = random() % 11
    
        switch (randomNumber) {
        case 0:
            return Hero1_Sheet.attack()
        case 1:
            return Hero1_Sheet.crouch_attack()
        case 2:
            return Hero1_Sheet.crouch_defend()
        case 3:
            return Hero1_Sheet.crouch_walk()
        case 4:
            return Hero1_Sheet.dead()
        case 5:
            return Hero1_Sheet.defend()
        case 6:
            return Hero1_Sheet.idle()
        case 7:
            return Hero1_Sheet.jump()
        case 8:
            return Hero1_Sheet.jump_attack()
        case 9:
            return Hero1_Sheet.run()
        case 10:
            return Hero1_Sheet.walk()
        default:
            print("Error in random Hero1 animation generator")
            return Hero1_Sheet.run()
        }
    }
    
    func randomHero2Animation() -> [SKTexture] {
        let randomNumber = random() % 11
        
        switch (randomNumber) {
        case 0:
            return Hero2_Sheet.attack()
        case 1:
            return Hero2_Sheet.crouch_attack()
        case 2:
            return Hero2_Sheet.crouch_defend()
        case 3:
            return Hero2_Sheet.crouch_walk()
        case 4:
            return Hero2_Sheet.dead()
        case 5:
            return Hero2_Sheet.defend()
        case 6:
            return Hero2_Sheet.idle()
        case 7:
            return Hero2_Sheet.jump()
        case 8:
            return Hero2_Sheet.jump_attack()
        case 9:
            return Hero2_Sheet.run()
        case 10:
            return Hero2_Sheet.walk()
        default:
            print("Error in random Hero2 animation generator")
            return Hero2_Sheet.run()
        }
    }
    
    func randomEnemy1Animation() -> [SKTexture] {
        let randomNumber = random() % 4
        
        switch ( randomNumber ) {
        case 0: return Enemy1_Sheet.attack()
        case 1: return Enemy1_Sheet.dead()
        case 2: return Enemy1_Sheet.defend()
        case 3: return Enemy1_Sheet.walk()
        default: return Enemy1_Sheet.walk()
        }
    }
    
    func randomEnemy2Animation() -> [SKTexture] {
    let randomNumber = random() % 3
    
    switch ( randomNumber ) {
    case 0: return Enemy2_Sheet.attack()
    case 1: return Enemy2_Sheet.dead()
    case 2: return Enemy2_Sheet.walk()
    default: return Enemy2_Sheet.walk()
    }
    }
    
    func unitsFighting() -> Bool {
        
        // local variables
        let playerFrontUnit = playerUnits.front()
        let enemyFrontUnit = enemyUnits.front()
        
        // units cannot be fighting if only one side has units
        if playerUnits.count() == 0 || enemyUnits.count() == 0 {
            return false
        }
        
        // check if both players are attacking, should only need to check 1 but this is more explicit
        if playerFrontUnit!.status == .Attacking && enemyFrontUnit!.status == .Attacking {
            return true
        }
        else {
            return false
        }
    }
    
    // simulates the battle between the two front units
    func checkFight() {
        
        // local variables
        let playerFrontUnit = playerUnits.front()
        let enemyFrontUnit = enemyUnits.front()
        
        // if there are units fighting
        if unitsFighting() {
            
            print("Units fighting")
            // deal damage to each other
            playerFrontUnit?.tookDamage((enemyFrontUnit?.damage)!)
            enemyFrontUnit?.tookDamage((playerFrontUnit?.damage)!)
            
            // both units died in the fight
            if playerFrontUnit?.health == 0  && enemyFrontUnit?.health == 0 {
                
                // set both units as dead
                playerFrontUnit!.status = .Dead
                enemyFrontUnit!.status = .Dead
            }
            
            // only the player's unit died
            else if playerFrontUnit?.health == 0 {
                
                // set only player's unit as dead
                playerFrontUnit!.status = .Dead
                
                // set the enemy's unit to running again
                setUnitRunning(enemyFrontUnit!)
            }
            
            // only the enemy's unit died
            else if enemyFrontUnit?.health == 0 {
                
                // set only player's unit as dead
                enemyFrontUnit!.status = .Dead
                
                // set the enemy's unit to running again
                setUnitRunning(playerFrontUnit!)
            }
        }
    }
    
    // checks if any unit has died and removes them from the battle field
    func checkDeath() {
        
        // local variables
        let playerFrontUnit = playerUnits.front()
        let enemyFrontUnit = enemyUnits.front()
        
        // only the front units can fight so we only need to check the front
        if playerUnits.count() > 0 && playerFrontUnit!.status == .Dead {
            
            // play death animation
            setUnitDead(playerFrontUnit!)
            
            // remove it from the game
            playerUnits.pop()
        }
        
        // check enemy's front unit for death
        if enemyUnits.count() > 0 && enemyFrontUnit!.status == .Dead {
            
            // play death animation
            setUnitDead(enemyFrontUnit!)
            
            // remove it from the game
            enemyUnits.pop()
        }
    }

    func recentDeath() -> Bool {
        
        // local variables
        let playerFrontUnit = playerUnits.front()
        let enemyFrontUnit = enemyUnits.front()
        
        if ( playerFrontUnit!.status == .Dead || enemyFrontUnit!.status == .Dead ) {
            return true
        }
        else {
            return false
        }
    }
    
    func checkCollision() {
        
        // local variables
        let playerFrontUnit = playerUnits.front()
        let enemyFrontUnit = enemyUnits.front()
        
        if playerUnits.count() == 0 || enemyUnits.count() == 0 {
            return
        }
        
        // check collision between opposing units
        if !unitsFighting() && !recentDeath() {
            
            // use a rectangle smaller than sprite's frame size since there is extra space
            if CGRectIntersectsRect(
                CGRectInset(playerFrontUnit!.sprite.frame, 30, 30),
                CGRectInset(enemyFrontUnit!.sprite.frame, 30, 30)) {
                beginFight(playerFrontUnit!, enemyUnit:  enemyFrontUnit!)
            }
        }
        
        // check collision between player's units
        if(playerUnits.count() >= 2) {

            // check every unit behind the front unit for collision
            for(var i = 1; i < playerUnits.count(); i++) {
                
                // check collision between current unit and unit in front
                if CGRectIntersectsRect(playerUnits.items[i - 1].sprite.frame, playerUnits.items[i].sprite.frame) {
                    
                    // set sprite to be idle if not already idle
                    if playerUnits.items[i].status != .Idle {
                        setUnitIdle(playerUnits.items[i])
                    }
                }
            }
        }
        
        // check collision between enemy's units
        if(enemyUnits.count() >= 2) {

            // check every unit behind the front unit for collision
            for(var i = 1; i < enemyUnits.count(); i++) {
                
                // check collision between current unit and unit in front
                if CGRectIntersectsRect(enemyUnits.items[i - 1].sprite.frame, enemyUnits.items[i].sprite.frame) {
                    
                    // set sprite to be idle if not already idle
                    if enemyUnits.items[i].status != .Idle {
                        setUnitIdle(enemyUnits.items[i])
                    }
                }
            }
        }
    }
    
    // checks if the any unit should end it's idling
    func checkEndUnitIdle() {
        
        // local variables
        
        // check all player units
        // if there is at least 1 unit...
        if playerUnits.count() >= 1 && playerUnits.front()!.status == .Idle{
            
            // should not be idling
            setUnitRunning(playerUnits.front()!)
        }
        
        // at least 2 units
        if playerUnits.count() >= 2 {
            
            // for every unit behind the front unit
            for ( var i = 1; i < playerUnits.count(); i++ ) {
                
                // if unit is not already running
                if playerUnits.items[i].status != .Running {
                
                    // check if unit in front is no longer idle
                    if playerUnits.items[i - 1].status != .Idle && playerUnits.items[i - 1].status != .Attacking
                    {
                    
                        // set unit to running again
                        setUnitRunning(playerUnits.items[i])
                    }
                }
            }
        }
        
        // check all enemy units
        // if there is at least 1 unit...
        if enemyUnits.count() >= 1 && enemyUnits.front()!.status == .Idle{
            
            // should not be idling
            setUnitRunning(enemyUnits.front()!)
        }
        
        // at least 2 units
        if enemyUnits.count() >= 2 {
            
            // for every unit behind the front unit
            for ( var i = 1; i < enemyUnits.count(); i++ ) {
                
                // if unit is not already running
                if enemyUnits.items[i].status != .Running {
                    
                    // check if unit in front is no longer idle
                    if enemyUnits.items[i - 1].status != .Idle && enemyUnits.items[i - 1].status != .Attacking
                    {
                        
                        // set unit to running again
                        setUnitRunning(enemyUnits.items[i])
                    }
                }
            }
        }
    }
    
    // plays a unit's death animation
    func setUnitDead(unit: Unit) {
        
        // local variables
        let spriteType = unit.sprite.name
        var deathTexture: [SKTexture]
        
        // stop sprite's current animation
        unit.sprite.removeAllActions()
        
        // get death texture
        if spriteType == "hero1" {
            deathTexture = Hero1_Sheet.dead()
        }
        else if spriteType == "hero2" {
            deathTexture = Hero2_Sheet.dead()
        }
        else if spriteType == "enemy1" {
            deathTexture = Enemy1_Sheet.dead()
        }
            
        // before extending, change this to //else if spriteType == "enemy2"
        else {
            deathTexture = Enemy2_Sheet.dead()
        }
        
        // play death animation
        let animation = SKAction.animateWithTextures(deathTexture, timePerFrame: 0.1)
        let deathAnimation = SKAction.sequence([animation, SKAction.removeFromParent()])
        unit.sprite.runAction(deathAnimation)

        
    }
    
    // makes a unit start running again
    func setUnitRunning(unit: Unit) {
        
        // local variables
        let spriteType = unit.sprite.name
        var runningTexture: [SKTexture]
        var direction: String

        // stop sprite's current animation if it was doing something else
        if unit.status != .Running {
            unit.sprite.removeAllActions()
        }
        
        //set the status to running
        unit.status = .Running
        
        
        
        // get new running textures
        if spriteType == "hero1" {
            
            // hero 1
            runningTexture = Hero1_Sheet.run()
            direction = "right"

        }
        else if spriteType == "hero2" {
            
            // hero 2
            runningTexture = Hero2_Sheet.run()
            direction = "right"
        }
        else if spriteType == "enemy1" {
            
            // enemy 1
            runningTexture = Enemy1_Sheet.walk()
            direction = "left"
        }
            
        // to extend change this to //else if spriteType == "enemy2"
        else {
            
            // enemy 2
            runningTexture = Enemy2_Sheet.walk()
            direction = "left"
        }
        
        // start running animation
        unit.sprite.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(runningTexture, timePerFrame: 0.1)))
        
        // move sprite in appropriate direction
        switch (direction) {
        case "left": moveLeft(unit.sprite)
        case "right": moveRight(unit.sprite)
        default: print("Error in GameScene.setUnitRunning")
        }
        
    }
    
    func setUnitIdle(unit: Unit) {
        
        // local variables
        let spriteType = unit.sprite.name
        var idleAnimation: SKAction
        
        
        // set sprite to be idle
        unit.status = .Idle
        
        // stop sprite's current animation
        unit.sprite.removeAllActions()
        
        if spriteType == "hero1" {
            idleAnimation = SKAction.animateWithTextures(Hero1_Sheet.idle(), timePerFrame: 0.3)
        }
        
        else if spriteType == "hero2" {
            idleAnimation = SKAction.animateWithTextures(Hero2_Sheet.idle(), timePerFrame: 0.3)
        }
        
        else if spriteType == "enemy1" {
            idleAnimation = SKAction.animateWithTextures(Enemy1_Sheet.defend(), timePerFrame: 0.3)
        }
        
        else if spriteType == "enemy2" {
            idleAnimation = SKAction.animateWithTextures(Enemy2_Sheet.idle(), timePerFrame: 0.1)
        }
        
        // Extend to more sprite types here
        else {
            idleAnimation = SKAction.animateWithTextures(Hero1_Sheet.defend(), timePerFrame: 0.1)
        }
        
        // animate
        unit.sprite.runAction(SKAction.repeatActionForever(idleAnimation))
    }
    
    func beginFight(playerUnit: Unit, enemyUnit: Unit) {
        
        // local variables
        let playerSpriteType = playerUnit.sprite.name
        let enemySpriteType = enemyUnit.sprite.name
        var playerFightingAnimation: SKAction
        var enemyFightingAnimation: SKAction
        
        // units have begun fighting
        playerUnit.status = .Attacking
        enemyUnit.status = .Attacking
        
        //------------------- player sprite -----------------------//
        
        // stop all other actions first
        playerUnit.sprite.removeAllActions()
        
        // begin fighting animation based on sprite type
        if playerSpriteType == "hero1" {
            playerFightingAnimation = SKAction.animateWithTextures(Hero1_Sheet.attack(), timePerFrame: 0.1)
        }
        
        // extend here
        //else if playerSpriteType == "hero2" {
        else {
            playerFightingAnimation = SKAction.animateWithTextures(Hero2_Sheet.attack(), timePerFrame: 0.1)
        }
        
        // start the animation for the player's sprite
        playerUnit.sprite.runAction(SKAction.repeatActionForever(playerFightingAnimation))
        
        //------------------- enemy sprite ----------------------//
        
        // stop all other actions first
        enemyUnit.sprite.removeAllActions()
        
        // begin fighting animation based on sprite type
        if enemySpriteType == "enemy1" {
            enemyFightingAnimation = SKAction.animateWithTextures(Enemy1_Sheet.attack(), timePerFrame: 0.1)
        }
        
        // extend here
        //else if playerSpriteType == "enemy2" {
        else {
            enemyFightingAnimation = SKAction.animateWithTextures(Enemy2_Sheet.attack(), timePerFrame: 0.1)
        }
        
        // start the animation for the player's sprite
        enemyUnit.sprite.runAction(SKAction.repeatActionForever(enemyFightingAnimation))
        
    }
    
    // checks if either player or enemy's units have reached the opposite castle
    func checkReachedCastle() {
        
        // check for player units
        if ( playerUnits.count() > 0 ) {
            
            // check if player's unit reached the enemy castle
            if ( CGRectIntersectsRect(playerUnits.front()!.sprite.frame, rightBorder) ) {
                
                // damage enemy castle... TODO
                
                // remove player from game
                playerUnits.front()!.sprite.removeFromParent()
                playerUnits.pop()
            }
        }
        
        // check for enemy units
        if ( enemyUnits.count() > 0 ) {
            
            // check if enemy's units reached the castle
            if ( CGRectIntersectsRect(enemyUnits.front()!.sprite.frame, leftBorder) ) {
                
                // damage player castle... TODO
                
                // remove enemy from game
                enemyUnits.front()!.sprite.removeFromParent()
                enemyUnits.pop()
            }
        }
    }

}

//TODO: Captain does not spawn when view is to the right
// this is because of how we pan the screen, we are moving the background node instead of actually
// moving our camera to the right

//TODO: Gold increments even when returning to menu
//TODO: Finish options menu
//TODO: Finish upgrade menu
