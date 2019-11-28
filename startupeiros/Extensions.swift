//
//  Extensions.swift
//  startupeiros
//
//  Created by Bruno Pastre on 27/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat  {
    static func * (lhr: Float, rhr: Self) -> CGFloat  {
        return CGFloat(lhr) * rhr
    }
    
    static func * (lhr: Double, rhr: Self) -> CGFloat  {
        return CGFloat(lhr) * rhr
    }
    
}


extension Int: Coin {
    func getRawAmount() -> Double {
        return Double(self)
    }
}



extension Double: Coin {
    func getRawAmount() -> Double {
        return self
    }
}
