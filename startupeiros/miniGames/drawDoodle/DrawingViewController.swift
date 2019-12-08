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
    private let classifier = DrawingClassifierModel()
    // END dd_new_vars

     
}
