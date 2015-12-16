//
//  hud.swift
//  RuinaDefense_2
//
//  Created by Student on 12/15/15.
//  Copyright © 2015 Ricardo Guntur. All rights reserved.
//

import Foundation
import SpriteKit

    //Global Gold Counter
    var gold = 0

    var spawnHero1Button: SKSpriteNode!
    var spawnHero2Button: SKSpriteNode!
    var spawnEnemy1Button: SKSpriteNode!
    var spawnEnemy2Button: SKSpriteNode!
    var menuButton: SKSpriteNode!
    var optionButton: SKSpriteNode!
    var upgradeButton: SKSpriteNode!



class hud {
    
    // HUD SpriteNode names
    let hudBackgroundName = "hudBar"
    let verticalBarName = "bar"
    let horizontalBarName = "horizontalBar"
    let VSImageName = "VSImage"
    let spawnButton = "SpawnButton"
    let menuButtonName = "menuButton"
    let optionButtonName = "optionButton"
    let upgradeButtonName = "upgradeButton"
    let gameFont = "Papyrus"
    
    // HUD SpriteKitNode
    var hudBackground: SKSpriteNode
    var leftBorder: SKSpriteNode
    var rightBorder: SKSpriteNode
    var middleBorder: SKSpriteNode
    var bottomBorder: SKSpriteNode
    var VSImage: SKSpriteNode
    var UsernameLabel: SKLabelNode
    var EnemynameLabel: SKLabelNode
    var GoldLabel: SKLabelNode
    var GoldLabelText: SKLabelNode

    // HUD Variables
    
    //Initializer
    init(gameview:GameScene) {
        
        // Initialize SpriteKitNodes
        
        //Background
        hudBackground = SKSpriteNode(imageNamed: hudBackgroundName)
        leftBorder = SKSpriteNode(imageNamed: verticalBarName)
        rightBorder = SKSpriteNode(imageNamed: verticalBarName)
        middleBorder = SKSpriteNode(imageNamed: verticalBarName)
        bottomBorder = SKSpriteNode(imageNamed: horizontalBarName)
        VSImage = SKSpriteNode(imageNamed: VSImageName)
        
        //Buttons
        menuButton = SKSpriteNode(imageNamed: menuButtonName)
        optionButton = SKSpriteNode(imageNamed: optionButtonName)
        upgradeButton = SKSpriteNode(imageNamed: upgradeButtonName)
        spawnHero1Button = SKSpriteNode(imageNamed: spawnButton)
        spawnHero2Button = SKSpriteNode(imageNamed: spawnButton)
        spawnEnemy1Button = SKSpriteNode(imageNamed: spawnButton)
        spawnEnemy2Button = SKSpriteNode(imageNamed: spawnButton)
        UsernameLabel = SKLabelNode(fontNamed: gameFont)
        EnemynameLabel = SKLabelNode(fontNamed: gameFont)
        GoldLabel = SKLabelNode(fontNamed: gameFont)
        GoldLabelText = SKLabelNode(fontNamed: gameFont)
        
        // Set up SpriteKitNodes' properties
        startGoldCounter()
        setupHUD(gameview)
        
    }
    
    
    func setupHUD(gameview: SKScene) {
        
        //Add hud background
        hudBackground.position = CGPoint(x: CGRectGetMidY(gameview.frame)+293, y: 100)
        hudBackground.size.height = 170
        hudBackground.size.width = 1340

        //HUD left border
        leftBorder.position = CGPoint(x: CGRectGetMinX(hudBackground.frame)+9, y: 90)
        leftBorder.zPosition = 5
        leftBorder.setScale(0.5)
        leftBorder.size.height = 200
        
        //HUD right border
        rightBorder.position = CGPoint(x: CGRectGetMaxX(hudBackground.frame)-10, y: 90)
        rightBorder.zPosition = 5
        rightBorder.setScale(0.5)
        rightBorder.size.height = 200
        
        //HUD middle border
        middleBorder.position = CGPoint(x: CGRectGetMidX(hudBackground.frame), y: 90)
        middleBorder.zPosition = 4
        middleBorder.setScale(0.5)
        middleBorder.size.height = 195
        
        //HUD bottom border
        bottomBorder.position = CGPoint(x: CGRectGetMidX(hudBackground.frame), y: 5)
        bottomBorder.zPosition = 4
        bottomBorder.setScale(0.5)
        bottomBorder.size.width = 1334
        
        //Create spawn hero1 button
        spawnHero1Button.setScale(0.3)
        spawnHero1Button.position = CGPoint(x:770, y:90)
        spawnHero1Button.zPosition = 3
        
        //Create spawn hero2 button
        spawnHero2Button.setScale(0.3)
        spawnHero2Button.position = CGPoint(x:920, y:90)
        spawnHero2Button.zPosition = 3
        
        //Create spawn enemy 1 button
        spawnEnemy1Button.setScale(0.3)
        spawnEnemy1Button.position = CGPoint(x:1070, y:90)
        spawnEnemy1Button.zPosition = 3
        
        //Create spawn enemy 2 button
        spawnEnemy2Button.setScale(0.3)
        spawnEnemy2Button.position = CGPoint(x:1220, y:90)
        spawnEnemy2Button.zPosition = 3
        
        //Menu button
        menuButton.name = menuButtonName
        menuButton.position = CGPoint(x:100, y:85)
        menuButton.zPosition = 3
        menuButton.setScale(0.2)
        
        //Options Button
        optionButton.name = optionButtonName
        optionButton.position = CGPoint(x:230, y:85)
        optionButton.zPosition = 3
        optionButton.setScale(0.2)
        
        //Upgrade label
        upgradeButton.name = upgradeButtonName
        upgradeButton.position = CGPoint(x:360, y:85)
        upgradeButton.zPosition = 3
        upgradeButton.setScale(0.2)
        
        //Username label -- should get information when game starts
        UsernameLabel.fontColor = SKColor .blackColor()
        UsernameLabel.text = user
        UsernameLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        UsernameLabel.fontSize = 35
        UsernameLabel.position = CGPoint(x:30, y:700)
        UsernameLabel.zPosition = 3
        
        //Enemyname label
        EnemynameLabel.fontColor = SKColor .blackColor()
        EnemynameLabel.text = "Enemy"
        EnemynameLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        EnemynameLabel.fontSize = 35
        EnemynameLabel.position = CGPoint(x:CGRectGetMaxX(gameview.frame)-30, y:700)
        EnemynameLabel.zPosition = 3
        
        //VS label
        VSImage.position = CGPoint(x:CGRectGetMidX(gameview.frame), y: 670)
        VSImage.setScale(0.70)
        VSImage.zPosition = 3
        
        //Gold label -- should start incrementing when game scene starts
        GoldLabel.fontColor = SKColor .blackColor()
        GoldLabel.fontSize = 35
        GoldLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        GoldLabel.position = CGPoint(x:130, y:650)
        GoldLabel.zPosition = 3
        
        //Gold Text -- Just "Gold"
        GoldLabelText.text = "Gold"
        GoldLabelText.fontColor = SKColor.blackColor()
        GoldLabelText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        GoldLabelText.fontSize = 35
        GoldLabelText.position = CGPoint(x:30, y:650)
        GoldLabelText.zPosition = 3

        //Add all children to scene
        gameview.addChild(leftBorder)
        gameview.addChild(rightBorder)
        gameview.addChild(middleBorder)
        gameview.addChild(bottomBorder)
        gameview.addChild(spawnHero1Button)
        gameview.addChild(spawnHero2Button)
        gameview.addChild(spawnEnemy1Button)
        gameview.addChild(spawnEnemy2Button)
        gameview.addChild(menuButton)
        gameview.addChild(optionButton)
        gameview.addChild(upgradeButton)
        gameview.addChild(UsernameLabel)
        gameview.addChild(EnemynameLabel)
        gameview.addChild(VSImage)
        gameview.addChild(GoldLabel)
        gameview.addChild(GoldLabelText)
        
    }
    
    func removeHero1SpawnButton() {
        spawnHero1Button.position = CGPoint(x: -50 ,y: -50)
    }
    
    func removeHero2SpawnButton() {
        spawnHero2Button.position = CGPoint(x: -50 ,y: -50)
    }
    
    func startGoldCounter() {
        
        //initialize gold to 0
        gold = 0
        
        NSTimer.every(1.second) {
            
            if isRunning {
                
                gold = gold + 1
                //print("Gold: ", self.gold)
                self.GoldLabel.text = ("\(gold)")
                //Continues running when going back to menu scene -- bool will NOT fix. It will call another instance of the timer, doubling hte gold per second
                //Continues running when opening pop up menu -- can fix with isRunning bool
                
            }
        }
    }
    
    
    
}