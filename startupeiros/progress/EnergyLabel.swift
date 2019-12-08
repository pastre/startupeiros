//
//  EnergyLabel.swift
//  startupeiros
//
//  Created by Bruno Pastre on 07/12/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class EnergyLabel: SupplicantLabel {
    
    override func setup() {
        EventBinder.bind(self, to: .energy)
    }
    
    
    override func update() {
        let newLevel = ResourceFacade.instance.coffeeManager.getAccumulated()
        self.text = "\(Int(newLevel))"
    }
    
    func invalidate() {
        EventBinder.unbind(clas: self)
    }
    
}

