//--------------------------------------------------------------
//  Class: global.swift
//  RuinaDefense

//  Created by Ricardo Guntur on 12/2/15.
//  Copyright © 2015 Ricardo Guntur. All rights reserved.
//--------------------------------------------------------------

import Foundation
import SpriteKit

//Contains all global parameters


//Captain Variables
var captain : SKSpriteNode!
var captainRunningFrames : [SKTexture]!

//Scene Variables
let scene = GameScene(fileNamed: "GameScene")


var selectedNode = SKSpriteNode()

let foreground = SKSpriteNode(imageNamed: "foreground") //Front of background
let skyline = SKSpriteNode(imageNamed: "skyline")       //Back of background

//HUD labels/buttons

var spawnButton: SKNode!

var MenuLabel = SKLabelNode(text: "Menu")

var UsernameLabel = SKLabelNode(text: "Username")

var EnemynameLabel = SKLabelNode(text: "Enemy")

var OptionLabel = SKLabelNode(text: "Option")

var UpgradeLabel = SKLabelNode(text: "Upgrade")

var VSLabel = SKLabelNode(text: "VS")

var gold = 0
let GoldLabel = SKLabelNode()

var goldCount = 0


//OPTIONS MENU NODES
var optionsBG = SKShapeNode(rectOfSize: CGSize(width: 800, height: 400))
var optionsClose = SKLabelNode(text: "Close")

//UPGRADE MENU NODES
var upgradeBG = SKShapeNode(rectOfSize: CGSize(width: 800, height: 400))
var upgradeClose = SKLabelNode(text: "Close")
