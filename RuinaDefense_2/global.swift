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
var randomNum = 0


var selectedNode = SKSpriteNode()

let foreground = SKSpriteNode(imageNamed: "foreground") //Front of background
let skyline = SKSpriteNode(imageNamed: "skyline")       //Back of background

//HUD labels/buttons

var hudBar = SKSpriteNode(imageNamed: "hudBar")

var hudSeparator = SKSpriteNode(imageNamed: "bar")

var spawnButton = SKSpriteNode(imageNamed: "Spawnbutton")

var menuButton = SKSpriteNode(imageNamed: "menuButton")

var UsernameLabel = SKLabelNode(text: "Username")

var EnemynameLabel = SKLabelNode(text: "Enemy")

var optionButton = SKSpriteNode(imageNamed: "optionButton")

var upgradeButton = SKSpriteNode(imageNamed: "upgradeButton")

var VSImage = SKSpriteNode(imageNamed: "VSImage")

var gold = 0
let GoldLabel = SKLabelNode()

var goldCount = 0


//OPTIONS MENU NODES
var optionsBG = SKSpriteNode(imageNamed: "popupWindow")
var optionsClose = SKLabelNode(text: "Close")

//UPGRADE MENU NODES
var upgradeBG = SKSpriteNode(imageNamed: "popupWindow")
var upgradeClose = SKLabelNode(text: "Close")
