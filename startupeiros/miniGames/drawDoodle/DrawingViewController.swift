//
//  DrawingViewController.swift
//  startupeiros
//
//  Created by Maykon Meneghel on 30/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class DrawingViewController: UIViewController {

    var canvas = Canvas()
    
    override func loadView() {
        self.view = canvas
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        canvas.backgroundColor = UIColor.white
    }

}
