//--------------------------------------------------------------
//  Class: hudSetup.swift
//  RuinaDefense
//
//  Created by Ricardo Guntur on 12/2/15.
//  Copyright © 2015 Ricardo Guntur. All rights reserved.
//--------------------------------------------------------------

import UIKit
import SpriteKit


//---------------------------------------------------------------------
//  Description: Scene that appears when app starts. Menu will contains
//  buttons: start, option, credits, etc.
//
//---------------------------------------------------------------------
class MenuScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        
        print("moved to menu view")
        
        //-------------------------------Background-------------------------------
        let menuBackground = SKSpriteNode(imageNamed: "menuBackground.png")
        menuBackground.name = "menuBackground"
        menuBackground.anchorPoint = CGPointZero
        menuBackground.size.width = 1334
        menuBackground.size.height = 750
        menuBackground.zPosition = 0
        self.addChild(menuBackground)
        
        //Add Logo
        let logo = SKSpriteNode(imageNamed: "RuinaDefenseLogo")
        logo.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)-250)
        logo.setScale(0.5)
        logo.zPosition = 1
        self.addChild(logo)
        
        //Add clouds
        addClouds()
        NSTimer.every(15.0 .seconds) {
        self.addClouds()
        }
        
        //-------------------------------Background Music-------------------------------
        let backgroundMusic = SKAudioNode(fileNamed: "Dystopia_Background_Music.wav")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        //Add all the buttons
        addButtons()
    }
    
    
    //----------------------Creates All the buttons on the menu scene------------------------
    private func addButtons() {

        //Start button
        let start_button = SKSpriteNode(imageNamed: "Start.png")
        start_button.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-170)
        start_button.setScale(0.5)
        start_button.zPosition = 1;
        start_button.name = "startButton"
        
        print("add start button")
        self.addChild(start_button)
        
        //Option button
        let menu_optionsButton = SKSpriteNode(imageNamed: "options.png")
        menu_optionsButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-240)
        menu_optionsButton.setScale(0.5)
        menu_optionsButton.zPosition = 1;
        menu_optionsButton.name = "optionButton"
        
        print("add option button")
        self.addChild(menu_optionsButton)
        
        //Stats button
        let statistics_button = SKSpriteNode(imageNamed: "statistics.png")
        statistics_button.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-310)
        statistics_button.setScale(0.5)
        statistics_button.zPosition = 1;
        statistics_button.name = "statisticsButton"
        
        print("add statistics button")
        self.addChild(statistics_button)
    }
    
    //----------------------------------Add moving cloud--------------------------------------
    private func addClouds() {
        
        //Create cloud
        let Cloud1 = SKSpriteNode(imageNamed: "Cloud1.png")
        Cloud1.name = "Cloud1"
        Cloud1.anchorPoint = CGPointZero
        
        //Set cloud position between y coordinates 200 and 275
        let randomHeight = CGFloat(arc4random_uniform(200) + 100)
        Cloud1.position = CGPointMake(-300, CGRectGetMidY(self.frame) + randomHeight)
        
        Cloud1.zPosition = 2
        Cloud1.setScale(2.0)
        
        //Add Cloud to scene
        self.addChild(Cloud1)
        
        //Movement
        let floatRight = SKAction.moveByX(1600, y: 0, duration: 30)
        let finishedMoving = SKAction.removeFromParent()
        let moveCloud = SKAction.sequence([floatRight, finishedMoving])
        Cloud1.runAction(moveCloud)
        
    }

    
    
    //----------------------------------Handle button touches----------------------------------
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches
        let location = touch.first!.locationInNode(self)
        let node = self.nodeAtPoint(location)
        
        // If start button is touched, start transition to game scene
        if (node.name == "startButton") {
            startGame()
        }
        
        // If option button is touched go to options scene
        if (node.name == "optionButton") {
            
            print("Menu Options button pressed")
        }
        
        // If stastistics button is touched go to statistics scene
        if (node.name == "statisticsButton") {
            print("statistics button pressed")
        }
        
        
    }
    
    
    //----------------------------Handle transition to gamescene-------------------------
    private func startGame() {
        let Game_Scene = GameScene(size: self.size)
        let transition = SKTransition.fadeWithDuration(1.0)
        
        Game_Scene.scaleMode = SKSceneScaleMode.AspectFill
        
        
        self.scene!.view?.presentScene(Game_Scene, transition: transition)
    }
}

