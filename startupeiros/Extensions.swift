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

extension CALayer {
  func applySketchShadow(
    color: UIColor = .black,
    alpha: Float = 0.5,
    x: CGFloat = 0,
    y: CGFloat = -2,
    blur: CGFloat = 22.0,
    spread: CGFloat = 0)
  {
    shadowColor = color.cgColor
    shadowOpacity = alpha
    shadowOffset = CGSize(width: x, height: y)
    shadowRadius = blur / 2.0
    if spread == 0 {
      shadowPath = nil
    } else {
      let dx = -spread
      let rect = bounds.insetBy(dx: dx, dy: dx)
      shadowPath = UIBezierPath(rect: rect).cgPath
    }
  }
}
