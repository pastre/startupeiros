//
//  HustlerProgressCircle.swift
//  startupeiros
//
//  Created by Bruno Pastre on 03/12/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class HustlerProgressCircle: CircularProgressBar {
    
    override func commonInit() {
        EventBinder.bind(self, to: .hustlerProgress)
        
        super.commonInit()
    }
    
    
    
    override func getProgress() -> CGFloat {
        return CGFloat(GameDatabaseFacade.instance.hustlerProgress)
    }
}
