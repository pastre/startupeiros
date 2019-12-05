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
    
    var timeStart: Int = 0
    var timeEnd: TimeInterval?
    var matrixDraw: [[Any]] = []
    var tVector: [Int] = []
    var xVector: [CGFloat] = []
    var yVector: [CGFloat] = []
    
    var lines = [Line]()
    var strokeWidth: Float = 5.0
    
    public func setStrokeWidth(width: Float){
        self.strokeWidth = width
    }
    
    public func undo(){
        _ = lines.popLast()
        _ = matrixDraw.popLast()
        _ = tVector.popLast()
        _ = xVector.popLast()
        _ = yVector.popLast()
        setNeedsDisplay()
    }
    
    public func clear(){
        lines.removeAll()
        matrixDraw.removeAll()
        tVector.removeAll()
        xVector.removeAll()
        yVector.removeAll()
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
        timeStart = ((event?.timestamp.milliseconds)!)
        lines.append(Line.init(stroke: strokeWidth, points: []))
        tVector = []
        xVector = []
        yVector = []
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let point = touches.first?.location(in: nil) else {return}
        
        tVector.append(abs((event?.timestamp.milliseconds)! - timeStart))
        xVector.append(point.x)
        yVector.append(point.y)
        
        
        guard var lastLine = lines.popLast() else {return}
        lastLine.points.append(point)
        lines.append(lastLine)
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        _ = self.screenshot
        timeStart = 0
        let matrixStroke: [Any] = [xVector, yVector, tVector]
        print("stroke \(touches.count)")
        matrixDraw.append(matrixStroke)
        print(matrixDraw)
        print("jogar na MobileNet")
    }
    
}

extension TimeInterval {
    var milliseconds: Int {
        return Int((truncatingRemainder(dividingBy: 1)) * 1000)
    }
}
