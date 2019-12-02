//
//  Canvas.swift
//  startupeiros
//
//  Created by Maykon Meneghel on 30/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit
struct Line {
    var color: UIColor  = .black
    var stroke: Float = 5.0
    var points: [CGPoint]
}
class Canvas: UIView {
    
    var lines = [Line]()
    var strokeWidth: Float = 5.0
    
    public func setStrokeWidth(width: Float){
        self.strokeWidth = width
    }
    
    public func undo(){
        _ = lines.popLast()
        setNeedsDisplay()
    }
    
    public func clear(){
        lines.removeAll()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {return}
        
        lines.forEach { (line) in
            context.setStrokeColor(line.color.cgColor)
            context.setLineWidth(CGFloat(line.stroke))
            context.setLineCap(.round)
            for (i, p) in line.points.enumerated(){
              if i == 0{
                    context.move(to: p)
                }else{
                    context.addLine(to: p)
                }
            }
            context.strokePath()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchBegan")
        lines.append(Line.init(stroke: strokeWidth, points: []))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let point = touches.first?.location(in: nil) else {return}
//        print(point)
        guard var lastLine = lines.popLast() else {return}
        lastLine.points.append(point)
        lines.append(lastLine)
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        _ = self.screenshot
        
        print("jogar na MobileNet")
    }
    
}
