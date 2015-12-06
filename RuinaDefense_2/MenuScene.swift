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
        //Background
        self.backgroundColor = SKColor(red: 0.15, green:0.15, blue:0.3, alpha: 1.0)
        
        //Add all the buttons
        addButtons()
    }
    
    
    //Creates All the buttons on the menu scene
    private func addButtons() {

        //Start button
        let start_button = SKSpriteNode(imageNamed: "Start.png")
        start_button.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        start_button.setScale(0.5)
        start_button.zPosition = 1;
        start_button.name = "startButton"
        
        print("add start button")
        self.addChild(start_button)
        
        //Option button
        let options_button = SKSpriteNode(imageNamed: "options.png")
        options_button.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-70)
        options_button.setScale(0.5)
        options_button.zPosition = 1;
        options_button.name = "optionButton"
        
        print("add option button")
        self.addChild(options_button)
        
        //Stats button
        let statistics_button = SKSpriteNode(imageNamed: "statistics.png")
        statistics_button.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-140)
        statistics_button.setScale(0.5)
        statistics_button.zPosition = 1;
        statistics_button.name = "statisticsButton"
        
        print("add statistics button")
        self.addChild(statistics_button)
    }
    
    //Handle button touches
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
            
            print("Options button pressed")
        }
        
        // If stastistics button is touched go to statistics scene
        if (node.name == "statisticsButton") {
            print("statistics button pressed")
        }
        
        
    }
    
    
    //Function to transition to gamescene
    private func startGame() {
        let Game_Scene = GameScene(size: self.size)
        let transition = SKTransition.fadeWithDuration(1.0)
        
        Game_Scene.scaleMode = SKSceneScaleMode.AspectFill
        
        
        self.scene!.view?.presentScene(Game_Scene, transition: transition)
    }
}

//TODO: Add musics, animated background