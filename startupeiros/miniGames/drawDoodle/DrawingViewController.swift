//
//  DrawingViewController.swift
//  startupeiros
//
//  Created by Maykon Meneghel on 30/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class DrawingViewController: UIViewController {

    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var classLabel: UILabel!
    
    
    var classification: String? = nil
    private var strokes: [CGMutablePath] = []
    private var currentStroke: CGMutablePath? { return strokes.last }
    private var imageViewSize: CGSize { return imageView.frame.size }
    private let classifier = Doodle_1()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        undoButton.disable()
    }
 
    // MARK: - Touches overrides
    override func touchesBegan(_ touches: Set<UITouch>,
           with event: UIEvent?) {

           guard let touch = touches.first else { return }
           
           let newStroke = CGMutablePath()
           newStroke.move(to: touch.location(in: imageView))
           strokes.append(newStroke)
           refresh()
       }
    
       override func touchesMoved(_ touches: Set<UITouch>,
           with event: UIEvent?) {

           guard let touch = touches.first,
               let currentStroke = self.currentStroke else {
                   return
           }
           
           currentStroke.addLine(to: touch.location(in: imageView))
           refresh()
       }
    
       override func touchesEnded(_ touches: Set<UITouch>,
           with event: UIEvent?) {

           guard let touch = touches.first,
               let currentStroke = self.currentStroke else {
                   return
           }
           
           currentStroke.addLine(to: touch.location(in: imageView))
           refresh()
       }
    
    // MARK: - Canvas related functions
    
    func undo() {
        let _ = strokes.removeLast()
        refresh()
    }
    
    func clear() {
        strokes = []
        classification = nil
        refresh()
    }
    
    func refresh() {
        if self.strokes.isEmpty { self.imageView.image = nil }
        
        let drawing = makeImage(from: self.strokes)
        self.imageView.image = drawing
        
        if classification != nil {
            undoButton.disable()
            clearButton.enable()
        } else if !strokes.isEmpty {
            undoButton.enable()
            clearButton.enable()
        } else {
            undoButton.disable()
            clearButton.disable()
        }
        
        classLabel.text = classification ?? ""
    }
    
    
    func makeImage(from strokes: [CGMutablePath]) -> UIImage? {
        let image = CGContext.create(size: imageViewSize) { context in
            context.setStrokeColor(UIColor.black.cgColor)
            context.setLineWidth(8.0)
            context.setLineJoin(.round)
            context.setLineCap(.round)
            
            for stroke in strokes {
                context.beginPath()
                context.addPath(stroke)
                context.strokePath()
            }
        }

        return image
    }

    func classify() {
        
    }

}
