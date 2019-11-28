//
//  File.swift
//  startupeiros
//
//  Created by Bruno Pastre on 28/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class EnergyBar: ProgressBarView, BindedSupplicant {
    
    func setup() {
        EventBinder.bind(self, to: .energy)
    }
    
    func update() {
        self.updateProgressView()
    }
    
    override func getProgress() -> CGFloat {
        return CGFloat(ResourceFacade.instance.coffeeManager.accumulated) / 10
    }
    
}
