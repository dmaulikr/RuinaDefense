//--------------------------------------------------------------
//  Class: global.swift
//  RuinaDefense

//  Created by Ricardo Guntur on 12/2/15.
//  Copyright © 2015 Ricardo Guntur. All rights reserved.
//--------------------------------------------------------------

import Foundation
import SpriteKit

//Contains all global parameters

//For testing
var myLabel = SKLabelNode(text: "Just a random SKLabel -- NOT PART OF HUD")

//Captain Variables
var captain : SKSpriteNode!
var captainRunningFrames : [SKTexture]!

//Scene Variables
let scene = GameScene(fileNamed: "GameScene")

var spawnButton: SKNode!

var selectedNode = SKSpriteNode()

let foreground = SKSpriteNode(imageNamed: "foreground") //Front of background
let skyline = SKSpriteNode(imageNamed: "skyline")       //Back of background
