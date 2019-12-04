//
//  HackerProgressCircle.swift
//  startupeiros
//
//  Created by Bruno Pastre on 03/12/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class HackerProgressCircle: CircularProgressBar {
    
    override func commonInit() {
        EventBinder.bind(self, to: .hackerProgress)
        
        super.commonInit()
    }
    
    
    
    override func getIconName() -> String {
        return "hacker"
    }
    
    
    override func getProgress() -> CGFloat {
        return CGFloat(GameDatabaseFacade.instance.hackerProgress)
    }
    
}

