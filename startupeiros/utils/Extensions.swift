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

extension CGContext {
    static func create(size: CGSize,
        action: (inout CGContext) -> ()) -> UIImage? {

        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        
        guard var context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        action(&context)

        let result = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        
        return result
    }
}
// END dd_new_extensions_cgcontext

// BEGIN dd_new_extensions_uibutton
extension UIButton {
    func enable() {
        self.isEnabled = true
        self.backgroundColor = UIColor.systemBlue
    }
    
    func disable() {
        self.isEnabled = false
        self.backgroundColor = UIColor.lightGray
    }
}
// END dd_new_extensions_uibutton

// BEGIN dd_new_extensions_uibarbuttonitem
extension UIBarButtonItem {
    func enable() { self.isEnabled = true }
    func disable() { self.isEnabled = false }
}
// END dd_new_extensions_uibarbuttonitem
