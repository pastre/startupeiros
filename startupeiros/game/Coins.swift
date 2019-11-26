//
//  Coins.swift
//  startupeiros
//
//  Created by Bruno Pastre on 26/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

class SkillCompletionCoin: Coin {
    var count: Double
    
    init(count: Double){
        self.count = count
    }
    
    func getRawAmount() -> Double {
        return self.count
    }
    
}
