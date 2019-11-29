//
//  File.swift
//  startupeiros
//
//  Created by Bruno Pastre on 28/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class EnergyBar: ProgressBarView {
    
    func setup() {
        EventBinder.bind(self, to: .energy)
    }
    
    
    
}
