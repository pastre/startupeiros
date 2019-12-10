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
        self.setTitleColor(UIColor.white, for: .normal)
    }
    
    func disable() {
        self.isEnabled = false
        self.setTitleColor(UIColor.lightGray, for: .normal)
    }
}
// END dd_new_extensions_uibutton

// BEGIN dd_new_extensions_uibarbuttonitem
extension UIBarButtonItem {
    func enable() { self.isEnabled = true }
    func disable() { self.isEnabled = false }
}
// END dd_new_extensions_uibarbuttonitem

extension UIImage {

    func resize(to newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newSize.width, height: newSize.height), true, 1.0)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIColor.white.setFill()
        UIRectFill(rect)
        self.draw(in: rect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return resizedImage
    }
    
    func applying(filter: CIFilter) -> UIImage? {
        filter.setValue(CIImage(image: self), forKey: kCIInputImageKey)

        let context = CIContext(options: nil)
        guard let output = filter.outputImage,
            let cgImage = context.createCGImage(
                    output, from: output.extent
                ) else {
                    return nil
        }

        return UIImage(
            cgImage: cgImage,
            scale: scale,
            orientation: imageOrientation)
    }

}

extension CIFilter {
    static let mono = CIFilter(name: "CIPhotoEffectMono")!
    static let noir = CIFilter(name: "CIPhotoEffectNoir")!
    static let tonal = CIFilter(name: "CIPhotoEffectTonal")!
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIImage {

    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!

        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)

        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }

}
