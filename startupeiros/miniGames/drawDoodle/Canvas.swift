//
//  Canvas.swift
//  startupeiros
//
//  Created by Maykon Meneghel on 30/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class Canvas: UIView {
    
    var lines = [[CGPoint]]()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {return}
        
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(10)
        context.setLineCap(.butt)
        
        lines.forEach { (line) in
            for (i, p) in line.enumerated(){
                if i == 0{
                    context.move(to: p)
                }else{
                    context.addLine(to: p)
                }
            }
        }
        context.strokePath()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchBegan")
        lines.append([CGPoint]())
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let point = touches.first?.location(in: nil) else {return}
//        print(point)
        guard var lastLine = lines.popLast() else {return}
        lastLine.append(point)
        lines.append(lastLine)
        
        setNeedsDisplay()
    }
    
}
