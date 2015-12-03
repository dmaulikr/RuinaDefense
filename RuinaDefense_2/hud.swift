//
//  hud.swift
//  RuinaDefense_2
//
//  Created by Student on 12/2/15.
//  Copyright © 2015 Ricardo Guntur. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class hud: UIView {
    
    var view: UIView!
    let nibName = "hud"
    
    override init(frame: CGRect) { // programmer creates our custom View
        super.init(frame: frame)
        
        setupHud()
    }
    
    
    required init(coder aDecoder: NSCoder) {  // Storyboard or UI File
        super.init(coder: aDecoder)!
        
        setupHud()
    }
    
    func setupHud() { // setup XIB here
        
        view = loadHudFromNib()
        
        //Size of hud in game. Not sure difference between this and the one in gamescene
        //But this one changes the actual visible borders and where labels are
        view.frame = CGRect(x: 0, y: 0, width: 667, height: 100)
        //Also not sure why isn't the same as the frame 1337 x 750. If I do that it's too large. This is the cause of why middle label is not really middle.
        
        //  CHANGE COLOR OF VIEW BACKGROUND THING TO SEE ACTUAL SIZE OF VIEW
        
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(view)
    }
    
    
    func loadHudFromNib() ->UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
        
    }
    
}
