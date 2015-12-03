//--------------------------------------------------------------
//  Class: functions.swift
//  RuinaDefense

//  Created by Ricardo Guntur on 12/2/15.
//  Copyright © 2015 Ricardo Guntur. All rights reserved.
//--------------------------------------------------------------

import Foundation
import UIKit
import SpriteKit


//Contains all functions

//Changes text from Gold to Not Gold -- for testing (can be used to open menu, etc)
func menuPressed() {
    
    if Gold == true {
        
        myLabel.text = "Not Gold"
        Gold = false
        
    } else {
        
        myLabel.text = "Gold"
        Gold = true
        
    }
    
    func shopPressed() {
        
    }
    
    func upgradePressed() {
        
    }
    
    
 }