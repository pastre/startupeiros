//
//  Challenge.swift
//  startupeiros
//
//  Created by Maykon Meneghel on 05/12/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

struct Challenge {
    
    var drawList = [
        "key":"🗝",
        "rabbit":"🐇",
        "shoe":"👞",
        "penguin":"🐧",
        "camel":"🐫",
        "bridge":"🌉",
        "monkey":"🐒",
        "pig":"🐖",
        "shark":"🦈",
        "microphone":"🎤",
        "lantern":"🔦",
        "book":"📖",
        "pizza":"🍕",
        "bicycle":"🚲",
        "mouse":"🐁"
    ]
    
    var drawCurrent: (key: String, value: String)! = (key: "" , value: "" )
    
    init(){
        self.chooseChallenge()
    }
    
    mutating func chooseChallenge() {
        drawCurrent = drawList.randomElement()
    }
}
