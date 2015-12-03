//
//  GameScene.swift
//  RuinaDefense_2
//
//  Created by Student on 12/2/15.
//  Copyright (c) 2015 Ricardo Guntur. All rights reserved.
//

import SpriteKit
import Foundation

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let frameW = self.frame.size.width
        let frameH = self.frame.size.height
        
        //Shows the hud
        showHud()
        
        //Create Hud
        myLabel.name = "label"
        myLabel.fontSize = 35
        myLabel.position = CGPoint(x: frameW / 2, y: frameH / 2)
        
        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
//        for touch: AnyObject in touches {
//            let location = touch.locationInNode(self)
//            
//            
//        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    //Creates Hud
    func showHud() {
        
        //Creates hud with starting coordinates 0,0 and size of ihpone 6 frame
        let myHud = hud(frame: CGRect(x: 0, y: 0, width: 1337, height: 750))
        
        self.view?.addSubview(myHud)
        
        
    }
}
