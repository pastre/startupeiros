//
//  File.swift
//  startupeiros
//
//  Created by Bruno Pastre on 28/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class EnergyBar: StepperBar {
    
    override func getProgress() -> CGFloat {
        return CGFloat(ResourceFacade.instance.coffeeManager.accumulated / 10)
    }
    
    override func update(_ notification: NSNotification) {
        print("Energy bar is updated")
        super.update(notification)
    }
    
    func setup() {
        EventBinder.bind(self, to: .energy)
    }
    
    override func onComplete() {
        
    }
    
}
