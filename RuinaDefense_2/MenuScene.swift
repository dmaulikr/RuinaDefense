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

var user = "nil"

class MenuScene: SKScene {
    
    //----------Variables-----------
    var backgroundMusic: SKAudioNode!
    let window = SKSpriteNode(imageNamed: "popupWindow")
    let windowClose = SKLabelNode(fontNamed: "Papyrus")
    let userNameText = UITextField(frame: CGRectMake(190 , 80, 290, 50))
    
    override func didMoveToView(view: SKView) {
        
        print("moved to menu view")
        
        //To allow tap anywhere to remove keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        //Set Username if it hasn't been set already
        if (user == "nil") {
            
            //Brings up window
            popUpWindow()
            
            //Textfield where user can input username
            userNameTextInput()

            
        }
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
        logo.setScale(0.4)
        logo.zPosition = 2
        self.addChild(logo)
        
        //Add window
        let menuWindow = SKSpriteNode(imageNamed: "Window3")
        menuWindow.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        menuWindow.setScale(0.86)
        menuWindow.size.width = 510
        menuWindow.size.height = 700
        menuWindow.zPosition = 1
        self.addChild(menuWindow)
        
        //ADD SNOW BRAH
        let path = NSBundle.mainBundle().pathForResource("snowParticle", ofType: "sks")
        let snow = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
        snow.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMaxY(self.frame))
        snow.zPosition = 6
        self.addChild(snow)
        
        
        //Add clouds
        addClouds()
        NSTimer.every(15.0 .seconds) {
        self.addClouds()
        }
        
        
        //Add all the buttons
        addButtons()
        
        //Start music -- DOES NOT PLAY WHEN RETURNING TO MENU FROM GAME SCENE
        playMusic()
    }
    
    
    //----------------------Creates All the buttons on the menu scene------------------------
    private func addButtons() {

        //Start button
        let start_button = SKSpriteNode(imageNamed: "Start.png")
        start_button.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-140)
        start_button.setScale(0.5)
        start_button.zPosition = 2
        start_button.name = "startButton"
        
        print("add start button")
        self.addChild(start_button)
        
        //Option button
        let menu_optionsButton = SKSpriteNode(imageNamed: "options.png")
        menu_optionsButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-210)
        menu_optionsButton.setScale(0.5)
        menu_optionsButton.zPosition = 2
        menu_optionsButton.name = "optionButton"
        
        print("add option button")
        self.addChild(menu_optionsButton)
        
        //Stats button
        let statistics_button = SKSpriteNode(imageNamed: "statistics.png")
        statistics_button.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-280)
        statistics_button.setScale(0.5)
        statistics_button.zPosition = 2
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
        
        Cloud1.zPosition = 3
        Cloud1.setScale(2.0)
        
        //Add Cloud to scene
        self.addChild(Cloud1)
        
        //Movement
        let floatRight = SKAction.moveByX(1600, y: 0, duration: 30)
        let finishedMoving = SKAction.removeFromParent()
        let moveCloud = SKAction.sequence([floatRight, finishedMoving])
        Cloud1.runAction(moveCloud)
        
    }

    //----------------------------------Play Background Music----------------------------------
    private func playMusic() {
        print("start music")
        backgroundMusic = SKAudioNode(fileNamed: "Dystopia_Background_Music.wav")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
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
        
        // If select button is pressed then delete the kids and set new user
        if (node.name == "windowCloseButton") {
            print("close button pressed")
            
            //Set userName
            user = userNameText.text!
            print("Username Entered: ", user)
            
            //Close window and remove nodes/textfield
            userNameText.removeFromSuperview()
            
            //Animate menu offscreen
            let moveUp = SKAction.moveByX(0, y: 530, duration: 1.5)
            let finishedMoving = SKAction.removeFromParent()
            let sequence = SKAction.sequence([moveUp, finishedMoving])
            window.runAction(sequence)
            windowClose.runAction(sequence)

        }
    }
    
    //----------------------------Handle Username Input----------------------------------
    func userNameTextInput() {
        
        print("create text input")
        
        userNameText.placeholder = "Your Name, Sire"
        userNameText.font = UIFont(name: "Papyrus", size: 25)
        userNameText.textColor = UIColor.blackColor()
        userNameText.textAlignment = .Center
        userNameText.backgroundColor = UIColor.clearColor()
        userNameText.autocorrectionType = UITextAutocorrectionType.Yes
        userNameText.keyboardType = UIKeyboardType.Twitter
        userNameText.clearButtonMode = UITextFieldViewMode.WhileEditing
        self.view!.addSubview(userNameText)
        
    }
    
    //OPEN USER INPUT WINDOW
    func popUpWindow() {
        
        //Background
        window.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)+150)
        window.zPosition = 10
        window.setScale(0.7)
        
        //Select button
        windowClose.fontColor = SKColor.blackColor()
        windowClose.name = "windowCloseButton"
        windowClose.text = "Select"
        windowClose.fontSize = 50
        windowClose.position = CGPoint(x: CGRectGetMidX(window.frame), y: CGRectGetMidY(window.frame)-170)
        windowClose.zPosition = 100
        
        //Add to view
        self.addChild(windowClose)
        self.addChild(window)
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view!.endEditing(true)
    }
    
    //----------------------------Handle transition to gamescene-------------------------
    private func startGame() {
        let Game_Scene = GameScene(size: self.size)
        let transition = SKTransition.fadeWithDuration(1.0)
        
        Game_Scene.scaleMode = SKSceneScaleMode.AspectFill
        
        //Remove sound
        backgroundMusic.removeFromParent()
        
        self.scene!.view?.presentScene(Game_Scene, transition: transition)
    }
}

