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
    
    func getIconName() -> String {
        fatalError("\(self) did not provide an icon")
    }
    
    func getIcon() -> UIImageView {
        let image = UIImageView(image: UIImage(named: self.getIconName()))
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        
        return image
    }
    
    override func setupProgressView() {
        let imageView = self.getIcon()

        self.addSubview(self.progressView)
        self.addSubview(imageView)
        
        self.progressView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.progressView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.progressView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.progressViewConstraint = self.progressView.heightAnchor.constraint(equalToConstant: 0)
        self.progressViewConstraint?.isActive = true
        
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
        
        self.layoutIfNeeded()
    }
}
