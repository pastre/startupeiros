//
//  CoffeeBar.swift
//  startupeiros
//
//  Created by Bruno Pastre on 28/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class CoffeeBar: ProgressBarView {
    
     func startProgress() {
        EventBinder.bind(self, to: .coffeeStart)
    }
    
}
