//
//  CircularProgressBar.swift
//  startupeiros
//
//  Created by Bruno Pastre on 03/12/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class CircularProgressBar: StepperBar {
    
    override func commonInit() {
        
        super.commonInit()
        
    }
    
    func setup() {

        self.progressView.clipsToBounds = true
        self.clipsToBounds = true
        self.layoutIfNeeded()
    }
    
    override func setupProgressView() {
        self.addSubview(self.progressView)
        
        self.progressView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        self.progressView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.progressView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.progressViewConstraint = self.progressView.heightAnchor.constraint(equalToConstant: 0)
        self.progressViewConstraint?.isActive = true
        
        self.layoutIfNeeded()
    }
}
