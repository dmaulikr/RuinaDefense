//--------------------------------------------------------------
//  Class: hudSetup.swift
//  RuinaDefense

//  Created by Ricardo Guntur on 12/2/15.
//  Copyright © 2015 Ricardo Guntur. All rights reserved.
//--------------------------------------------------------------

import UIKit
import SpriteKit



class hudSetup: UIView {
    
    //Gold Label
    @IBOutlet weak var goldLabel: UITextField!

    
    //Increment Gold and display on label
    func updateGold() {
        
        print("Start incrementing gold per second")
        NSTimer.every(1.0 .seconds) {
            goldCount = goldCount + 1
            print(goldCount)
            
            //self.goldLabel.text = "text" //ERROR HERE WTF
        }
    }
    
    //menu pressed action
    @IBAction func menuButtonPressed(sender: AnyObject) {
        
        print("Menu Button Pressed")
        menuPressed()
    
    }
    
    
    @IBAction func shopButtonPressed(sender: AnyObject) {
        
        print("Shop Button Pressed")
        shopPressed()
        
    }
    
    
    @IBAction func upgradeButtonPressed(sender: AnyObject) {
        
        print("Upgrade Button Pressed")
        upgradePressed()
    }
    
    @IBAction func capPressed(sender: AnyObject) {
        
        print("Captain pressed!")
        //scene!.spawnCaptain()
        
    }
    
    override func didAddSubview(subview: UIView) {
        
        
    }

    
    
    
    
    
}