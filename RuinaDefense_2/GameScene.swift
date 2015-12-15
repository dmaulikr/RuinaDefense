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

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //-------------------------Class Variables----------------------//
    
    struct PhysicsCategory {
        static let None : UInt32 = 0
        static let All : UInt32 = UInt32.max
        static let leftUnit : UInt32 = 0x1 << 0
        static let leftCastle : UInt32 = 0x1 << 1
        static let rightUnit : UInt32 = 0x1 << 2
        static let rightCastle : UInt32 = 01 << 3
    }
    
    //Scene
    //let scene = GameScene(fileNamed: "GameScene")
    
    //Back Ground
    let background = SKSpriteNode(imageNamed: "background")
    var randomNum = 0 //For random cloud variant spawning
    
    //Music
    var musicPlaying = true
    
    //HUD
    let hudBar = SKSpriteNode(imageNamed: "hudBar")
    let leftBorder = SKSpriteNode(imageNamed: "bar")
    let rightBorder = SKSpriteNode(imageNamed: "bar")
    let middleBorder = SKSpriteNode(imageNamed: "bar")
    let bottomBorder = SKSpriteNode(imageNamed: "horizontalBar")
    let VSImage = SKSpriteNode(imageNamed: "VSImage")
    
    //HUD Buttons
    let spawnHero1Button = SKSpriteNode(imageNamed: "SpawnButton")
    let spawnHero2Button = SKSpriteNode(imageNamed: "SpawnButton")
    let spawnHero3Button = SKSpriteNode(imageNamed: "SpawnButton")
    let spawnEnemy1Button = SKSpriteNode(imageNamed: "SpawnButton")
    let spawnEnemy2Button = SKSpriteNode(imageNamed: "SpawnButton")

    let menuButton = SKSpriteNode(imageNamed: "menuButton")
    
    //HUD Labels
    var UsernameLabel = SKLabelNode(fontNamed: "Papyrus")
    var EnemynameLabel = SKLabelNode(fontNamed: "Papyrus")
    var gold = 0    //Gold counter
    let GoldLabel = SKLabelNode(fontNamed: "Papyrus")
    let GoldLabelText = SKLabelNode(fontNamed: "Papyrus")
    
    //Options Menu Nodes
    let optionsBG = SKSpriteNode(imageNamed: "popupWindow")
    let optionsMenuLabel = SKLabelNode(fontNamed: "Papyrus")
    let optionsClose = SKLabelNode(fontNamed: "Papyrus")
    let playMusicButton = SKSpriteNode(imageNamed: "playMusicButton")
    let pauseMusicButton = SKSpriteNode(imageNamed: "pauseMusicButton")

    //Upgrade Menu Nodes
    let upgradeBG = SKSpriteNode(imageNamed: "popupWindow")
    let upgradeMenuLabel = SKLabelNode(fontNamed: "Papyrus")
    let upgradeClose = SKLabelNode(fontNamed: "Papyrus")
    
    //Pop up menu buttons
    let optionButton = SKSpriteNode(imageNamed: "optionButton")
    let upgradeButton = SKSpriteNode(imageNamed: "upgradeButton")
    
    //Handle Touches
    var selectedNode = SKSpriteNode()
    
    //Other
    var isRunning = false
    var clickable = true
    
    //FOR CHARACTERS
    let Hero1_Sheet = Hero1Sheet() //Animations for Hero1
    let Hero2_Sheet = Hero2Sheet() //Animations for Hero2
    let Enemy1_Sheet = Skeleton1Sheet() //Animations for Skeleton1
    let Enemy2_Sheet = Skeleton2Sheet() //Animations for Skeleton1
    
    //-----------------------Class Variables End--------------------//
    
    override func didMoveToView(view: SKView) {
        
        //Set isRunning to true
        isRunning = true
  
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
        
        //ADD SNOOOOOW
        let path = NSBundle.mainBundle().pathForResource("heavySnowParticle", ofType: "sks")
        let snow = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
        snow.position = CGPoint(x: CGRectGetMidX(background.frame), y: CGRectGetMaxY(background.frame))
        snow.zPosition = 6
        background.addChild(snow)
        
        //Add fire to the castles
        let firePath = NSBundle.mainBundle().pathForResource("flameParticle", ofType: "sks")
        let flame = NSKeyedUnarchiver.unarchiveObjectWithFile(firePath!) as! SKEmitterNode
        flame.position = CGPoint(x: 84,y: 530)
        flame.zPosition = 6
        background.addChild(flame)
        
        let flame2 = NSKeyedUnarchiver.unarchiveObjectWithFile(firePath!) as! SKEmitterNode
        flame2.position = CGPoint(x: 354,y: 530)
        flame2.zPosition = 6
        background.addChild(flame2)
        
        let flame3 = NSKeyedUnarchiver.unarchiveObjectWithFile(firePath!) as! SKEmitterNode
        flame3.position = CGPoint(x: 2320,y: 530)
        flame3.zPosition = 6
        background.addChild(flame3)
        
        let flame4 = NSKeyedUnarchiver.unarchiveObjectWithFile(firePath!) as! SKEmitterNode
        flame4.position = CGPoint(x: 2588,y: 530)
        flame4.zPosition = 6
        background.addChild(flame4)
        
        
        //HANDLE PHYSICS FOR SCENE------------------------------------------------
        
        //Physics body that borders the screen. Set slightly above so there is space for hud
        physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectInset(background.frame, 0, 240))
        
        
        //Set friction of the physics body to 0
        physicsBody?.friction = 0
        
        // Set contact delegate
        physicsWorld.contactDelegate = self
        
        //Add gravity
        physicsWorld.gravity = CGVectorMake(0, -20);
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
                //print("Gold: ", self.gold)
                self.GoldLabel.text = ("\(self.gold)")
                //Continues running when going back to menu scene -- bool will NOT fix. It will call another instance of the timer, doubling hte gold per second
                //Continues running when opening pop up menu -- can fix with isRunning bool
            }
        }
        
        
        //-------------------------------Background Music-------------------------------
        print("Play music")
        //Path of music
    
            let musicPath = NSBundle.mainBundle().URLForResource("GameSceneMusic", withExtension: "wav")
        
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
    
    //-------------------------------HEADS UP DISPLAY-------------------------------
    func addHud() {
        
        //Add hud background
        hudBar.position = CGPoint(x: CGRectGetMidY(self.frame)+293, y: 100)
        hudBar.size.height = 170
        hudBar.size.width = 1340
        hudBar.zPosition = 2
        //self.addChild(hudBar)
        
        
        //HUD left border
        leftBorder.position = CGPoint(x: CGRectGetMinX(hudBar.frame)+9, y: 90)
        leftBorder.zPosition = 5
        leftBorder.setScale(0.5)
        leftBorder.size.height = 200
        self.addChild(leftBorder)
        
        //HUD right border
        rightBorder.position = CGPoint(x: CGRectGetMaxX(hudBar.frame)-10, y: 90)
        rightBorder.zPosition = 5
        rightBorder.setScale(0.5)
        rightBorder.size.height = 200
        self.addChild(rightBorder)
        
        middleBorder.position = CGPoint(x: CGRectGetMidX(hudBar.frame), y: 90)
        middleBorder.zPosition = 4
        middleBorder.setScale(0.5)
        middleBorder.size.height = 195
        self.addChild(middleBorder)
        
        //HUD bottom border
        bottomBorder.position = CGPoint(x: CGRectGetMidX(hudBar.frame), y: 5)
        bottomBorder.zPosition = 4
        bottomBorder.setScale(0.5)
        bottomBorder.size.width = 1334
        self.addChild(bottomBorder)
    
        //Create spawn hero1 button
        spawnHero1Button.setScale(0.3)
        spawnHero1Button.position = CGPoint(x:770, y:90)
        spawnHero1Button.zPosition = 3
        self.addChild(spawnHero1Button)
        
        //Create spawn hero2 button
        spawnHero2Button.setScale(0.3)
        spawnHero2Button.position = CGPoint(x:920, y:90)
        spawnHero2Button.zPosition = 3
        self.addChild(spawnHero2Button)
        
        //Create spawn hero3 button
        spawnHero3Button.setScale(0.3)
        spawnHero3Button.position = CGPoint(x:1070, y:90)
        spawnHero3Button.zPosition = 3
        //self.addChild(spawnHero3Button)
        
        //Create spawn enemy 1 button
        spawnEnemy1Button.setScale(0.3)
        spawnEnemy1Button.position = CGPoint(x:1070, y:90)
        spawnEnemy1Button.zPosition = 3
        self.addChild(spawnEnemy1Button)
        
        //Create spawn enemy 2 button
        spawnEnemy2Button.setScale(0.3)
        spawnEnemy2Button.position = CGPoint(x:1220, y:90)
        spawnEnemy2Button.zPosition = 3
        self.addChild(spawnEnemy2Button)
        
        //ON THE BOTTOM
        //Menu button
        menuButton.name = "menu"
        menuButton.position = CGPoint(x:100, y:85)
        menuButton.zPosition = 3
        menuButton.setScale(0.2)
        self.addChild(menuButton)
        
        //Options Button
        optionButton.name = "option"
        optionButton.position = CGPoint(x:230, y:85)
        optionButton.zPosition = 3
        optionButton.setScale(0.2)
        self.addChild(optionButton)
        
        //Upgrade label
        upgradeButton.name = "upgrade"
        upgradeButton.position = CGPoint(x:360, y:85)
        upgradeButton.zPosition = 3
        upgradeButton.setScale(0.2)
        self.addChild(upgradeButton)
        
        //ON THE TOP
        //Username label -- should get information when game starts
        UsernameLabel.fontColor = SKColor .blackColor()
        UsernameLabel.text = user
        UsernameLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        UsernameLabel.fontSize = 35
        UsernameLabel.position = CGPoint(x:30, y:700)
        UsernameLabel.zPosition = 3
        self.addChild(UsernameLabel)
        
        //Enemyname label
        EnemynameLabel.fontColor = SKColor .blackColor()
        EnemynameLabel.text = "Enemy"
        EnemynameLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        EnemynameLabel.fontSize = 35
        EnemynameLabel.position = CGPoint(x:CGRectGetMaxX(self.frame)-30, y:700)
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
        GoldLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        GoldLabel.position = CGPoint(x:130, y:650)
        GoldLabel.zPosition = 3
        self.addChild(GoldLabel)
        
        //Gold Text -- Just "Gold"
        GoldLabelText.text = "Gold"
        GoldLabelText.fontColor = SKColor.blackColor()
        GoldLabelText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        GoldLabelText.fontSize = 35
        GoldLabelText.position = CGPoint(x:30, y:650)
        GoldLabelText.zPosition = 3
        self.addChild(GoldLabelText)
        
    }
    
    
    ////----------------------ADD GAME CLOUDS----------------------
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
    
    //========================================UNIT SPAWNING========================================
    
    //----------------------HERO SPAWNING----------------------
    func spawnHero1() {
        
        let hero1 = SKSpriteNode(texture: Hero1_Sheet.run_1_())
        
        //Set position and physics body stuff
        hero1.position = CGPoint(x: 160, y: 241)
        print("Width = %f", self.view!.frame.width)
        print("Height = %f", self.view!.frame.height)
        hero1.zPosition = 3
        hero1.physicsBody = SKPhysicsBody(circleOfRadius: hero1.frame.width * 0.3)
        hero1.setScale(0.5)
        //hero1.physicsBody?.mass = 500
        hero1.physicsBody?.friction = 0
        hero1.physicsBody?.restitution = 0
        hero1.physicsBody?.linearDamping = 0
        hero1.physicsBody?.angularDamping = 0
        hero1.physicsBody?.allowsRotation = false
        hero1.physicsBody?.categoryBitMask = PhysicsCategory.leftUnit
        hero1.physicsBody?.contactTestBitMask = PhysicsCategory.All
        
        
        //Add to scene
        background.addChild(hero1)
        
        //Animates the hero
        //let run = SKAction.animateWithTextures(Hero1_Sheet.run(), timePerFrame: 0.033)
        let run = SKAction.animateWithTextures(randomHero1Animation(), timePerFrame: 0.1)
        let action = SKAction.repeatActionForever(run)
        hero1.runAction(action)
        
        //Moves hero rightward forever
        moveRight(hero1)
        
    }
    
    func spawnHero2() {
        
        let hero2 = SKSpriteNode(texture: Hero2_Sheet.run_1_())
        
        //Set position and physics body stuff
        hero2.position = CGPoint(x: 160, y: 241)
        print("Width = %f", self.view!.frame.width)
        print("Height = %f", self.view!.frame.height)
        hero2.zPosition = 3
        hero2.physicsBody = SKPhysicsBody(circleOfRadius: hero2.frame.width * 0.3)
        hero2.setScale(0.5)
        //hero1.physicsBody?.mass = 500
        hero2.physicsBody?.friction = 0
        hero2.physicsBody?.restitution = 0
        hero2.physicsBody?.linearDamping = 0
        hero2.physicsBody?.angularDamping = 0
        hero2.physicsBody?.allowsRotation = false
        hero2.physicsBody?.categoryBitMask = PhysicsCategory.leftUnit
        hero2.physicsBody?.contactTestBitMask = PhysicsCategory.All
        
        
        //Add to scene
        background.addChild(hero2)
        
        //Animates the hero
        //let run = SKAction.animateWithTextures(Hero2_Sheet.run(), timePerFrame: 0.033)
        let run = SKAction.animateWithTextures(randomHero2Animation(), timePerFrame: 0.1)
        let action = SKAction.repeatActionForever(run)
        hero2.runAction(action)
        
        //Moves hero rightward forever
        moveRight(hero2)
        
    }
    
    func spawnHero3() {
  
    }
    
    //----------------------ENEMY SPAWNING----------------------
    func spawnEnemy1() {
    let enemy1 = SKSpriteNode(texture: Enemy1_Sheet.walk_1_())
        
        //Set position and physics body stuff
        enemy1.position = CGPoint(x: 2500, y: 241)
        enemy1.zPosition = 3
        enemy1.physicsBody = SKPhysicsBody(circleOfRadius: enemy1.frame.width * 0.3)
        enemy1.setScale(0.5)
        //enemy1.physicsBody?.mass = 500
        enemy1.physicsBody?.friction = 0
        enemy1.physicsBody?.restitution = 0
        enemy1.physicsBody?.linearDamping = 0
        enemy1.physicsBody?.angularDamping = 0
        enemy1.physicsBody?.allowsRotation = false
        enemy1.xScale = enemy1.xScale * -1
        enemy1.physicsBody?.categoryBitMask = PhysicsCategory.rightUnit
        enemy1.physicsBody?.contactTestBitMask = PhysicsCategory.All
        
        //Add to scene
        background.addChild(enemy1)
        
        //Animates the hero
        //let run = SKAction.animateWithTextures(Enemy1_Sheet.run(), timePerFrame: 0.033)
        let run = SKAction.animateWithTextures(randomEnemy1Animation(), timePerFrame: 0.1)
        let action = SKAction.repeatActionForever(run)
        enemy1.runAction(action)
        
        //Move enemy leftward
        moveLeft(enemy1)
    }
    
    func spawnEnemy2() {
        let enemy2 = SKSpriteNode(texture: Enemy2_Sheet.walk_1_())
        
        //Set position and physics body stuff
        enemy2.position = CGPoint(x: 2500, y: 241)
        enemy2.zPosition = 3
        enemy2.physicsBody = SKPhysicsBody(circleOfRadius: enemy2.frame.width * 0.3)
        enemy2.setScale(0.5)
        //enemy1.physicsBody?.mass = 500
        enemy2.physicsBody?.friction = 0
        enemy2.physicsBody?.restitution = 0
        enemy2.physicsBody?.linearDamping = 0
        enemy2.physicsBody?.angularDamping = 0
        enemy2.physicsBody?.allowsRotation = false
        enemy2.xScale = enemy2.xScale * -1
        enemy2.physicsBody?.categoryBitMask = PhysicsCategory.rightUnit
        enemy2.physicsBody?.contactTestBitMask = PhysicsCategory.All
        
        //Add to scene
        background.addChild(enemy2)
        
        //Animates the hero
        //let run = SKAction.animateWithTextures(Enemy2_Sheet.run(), timePerFrame: 0.033)
        let run = SKAction.animateWithTextures(randomEnemy2Animation(), timePerFrame: 0.1)
        let action = SKAction.repeatActionForever(run)
        enemy2.runAction(action)
        
        //Move enemy leftward
        moveLeft(enemy2)
    }

    
    //========================================UNIT SPAWNING END========================================
    
    //========================================UNIT ANIMATION===========================================
    //Move sprite right -- NO ANIMATION
    func moveRight(sprite: SKSpriteNode) {
        
        //Moves node rightward
        let moveRight = SKAction.moveByX(2674, y:0, duration:7.0)
        
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
        let moveLeft = SKAction.moveByX(-2674, y:0, duration:7.0)
        
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
            
            //MENU BUTTON PRESSED
            if menuButton.containsPoint(location) {
                
                //Stop Music
                audioPlayer.stop()
                
                
                //Remove some nodes
                background.removeFromParent()
                leftBorder.removeFromParent()
                rightBorder.removeFromParent()
                hudBar.removeFromParent()
                spawnHero1Button.removeFromParent()
                spawnEnemy1Button.removeFromParent()
                spawnEnemy2Button.removeFromParent()
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
            
            //---------------------------OPEN MENUS---------------------------
            //OPTIONS BUTTON PRESSED
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
            
            
            //UPGRADE BUTTON PRESSED
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
            
            
            //---------------------------CLOSE MENUS---------------------------
            
            //Close Menu buttons
            if optionsClose.containsPoint(location) {
                print("options close button pressed")
                

                
                //Animation: moves sprite up
                let moveUp = SKAction.moveByX(0, y: 530, duration: 1.5)
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
                let moveUp = SKAction.moveByX(0, y: 530, duration: 1.5)
                let finishedMoving = SKAction.removeFromParent()
                let sequence = SKAction.sequence([moveUp, finishedMoving])
                
                //Move all menu stuff up
                upgradeClose.runAction(sequence)
                upgradeBG.runAction(sequence)
                upgradeMenuLabel.runAction(sequence)
                
                //Set button to clickable
                self.clickable = true
                
                //resume scene
                isRunning = true
                self.paused = false
            }
            
            //---------------------------MENU BUTTONS---------------------------
            
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
        upgradeBG.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)+150)
        upgradeBG.zPosition = 10
        upgradeBG.setScale(0.7)
        
        //Upgrade Menu Label
        upgradeMenuLabel.text = "Upgrades"
        upgradeMenuLabel.fontSize = 50
        upgradeMenuLabel.position = CGPoint(x: CGRectGetMidX(upgradeBG.frame), y: CGRectGetMidY(upgradeBG.frame)+150)
        upgradeMenuLabel.zPosition = 13
        upgradeMenuLabel.fontColor = SKColor.blackColor()
        
        
        //Close Button
        upgradeClose.fontColor = SKColor.blackColor()
        upgradeClose.fontSize = 50
        upgradeClose.text = "Resume"
        upgradeClose.position = CGPoint(x: CGRectGetMidX(upgradeBG.frame), y: CGRectGetMidY(upgradeBG.frame)-190)
        upgradeClose.zPosition = 100

        
        //Add to view
        self.addChild(upgradeBG)
        self.addChild(upgradeClose)
        self.addChild(upgradeMenuLabel)
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
        
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if touchedNode is SKSpriteNode {
            
            if !selectedNode.isEqual(touchedNode) {
                //selectedNode.removeAllActions()
                
                //Set selected node to the node you touched
                selectedNode = touchedNode as! SKSpriteNode
                //print(selectedNode)
                
            }
        }
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
            
            //print("Touches background")
            let position = selectedNode.position
            let aNewPosition = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
            background.position = self.boundLayerPos(aNewPosition)
        }
        
        else {
            //print("touched something else ;)")
        }
        physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectInset(background.frame, 0, 240))
    }
    
    // Handles collisions
    func didBeginContact(contact: SKPhysicsContact) {
        
        // physics bodies
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        // set the first body to be the left unit and the second to be the right
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // handle collision between opposing factions
        if firstBody.categoryBitMask == PhysicsCategory.leftUnit && secondBody.categoryBitMask == PhysicsCategory.rightUnit {
            
            firstBody.velocity = CGVectorMake(-1000, 1000)
            secondBody.velocity = CGVectorMake(1000,1000)
            
            print("Fight began")
            print(contact.bodyA.velocity)
        }
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

}

//TODO: Captain does not spawn when view is to the right
// this is because of how we pan the screen, we are moving the background node instead of actually
// moving our camera to the right

//TODO: Gold increments even when returning to menu
//TODO: Finish options menu
//TODO: Finish upgrade menu
//Health bar