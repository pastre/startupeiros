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
//        lines.append(CGMutablePath)
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
        
//        var xBuff: [CGPath] = []
//        var yBuff: [CGPath] = []
//        var tBuff: [Float] = []
//        lines[0].path.
//        xVector.forEach { (x) in
//            print(x/255)
            
//            xBuff.append(x/255 as! CGPath)
//        }
//        yVector.forEach { (y) in
//            yBuff.append(CGPath(y/255))
//        }
        
        let matrixStroke: [Any] = [xVector, yVector, tVector]
//        print("stroke \(touches.count)")
        matrixDraw.append(matrixStroke)
        
//        let image: UIImage = self.makeImage(from: matrixDraw)!
//        matrixDraw.append(matrixStroke)
//        print(matrixDraw as! CGMutablePath)
        
        
//        let model = quick_doodle()
//
//        let prediction = try! model.prediction(drawing: self.matrixDraw as! CVPixelBuffer)
//        print(prediction)
        
        
    }
    
//    private var imageViewSize: CGSize { return UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 600)).frame.size }
//
//    func makeImage(from strokes: [[Any]]) -> UIImage? {
//        let image = CGContext.create(size: imageViewSize) { context in
//            context.setStrokeColor(UIColor.black.cgColor)
//            context.setLineWidth(8.0)
//            context.setLineJoin(.round)
//            context.setLineCap(.round)
//
//
//            for stroke in strokes {
//                context.beginPath()
//                context.addPath(stroke as! CGPath)
//                context.strokePath()
//            }
//
////            for stroke in strokes {
////                context.beginPath()
////                context.addPath(stroke.points)
////                context.strokePath()
////            }
//        }
//
//        return image
//    }
    
}

extension TimeInterval {
    var milliseconds: Int {
        return Int((truncatingRemainder(dividingBy: 1)) * 1000)
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
