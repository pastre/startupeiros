//
//  DrawingViewController.swift
//  startupeiros
//
//  Created by Maykon Meneghel on 30/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class Canvas: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else
        {return}
        
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x: 100.0, y: 100.0)
        
        context.move(to: startPoint)
        context.addLine(to: endPoint)
        
        context.strokePath()
        //
    }
}

class DrawingViewController: UIViewController {

    var canvas = Canvas()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(canvas)
        canvas.frame = view.frame
    }

}
