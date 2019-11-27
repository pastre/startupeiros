//
//  ProgressView.swift
//  startupeiros
//
//  Created by Bruno Pastre on 27/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit


protocol ProgressSupplicant {
    func updateProgress()
    func getProgress() -> CGFloat
}

class ProgressBarView: UIView, ProgressSupplicant {
    
    var progressViewWidthConstraint: NSLayoutConstraint?
    var completion: CGFloat = 0
    let progressView: UIView! = {
        let view  = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        self.setupProgressView()
    }
    
    func setupProgressView() {
        self.addSubview(self.progressView)
        
        self.progressView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.progressView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.progressView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.progressViewWidthConstraint = self.progressView.widthAnchor.constraint(equalTo: self.widthAnchor)
        self.progressViewWidthConstraint?.isActive = true
    }
    
    func updateProgress() {
        let completePercent = self.getProgress()
        
        self.completion = completePercent
        self.updateProgressView()
    }
    
    func updateProgressView(){
        let completed = self.completion * self.layer.frame.width
        self.progressViewWidthConstraint?.constant = completed
        
        self.layoutIfNeeded()
    }

    func getProgress() -> CGFloat {
        fatalError( "PROGRESS BAR SUBCLASS NOT IMPLEMENTING getProgress \(self)")
    }
}

class CoffeeBar: ProgressBarView{
    override func getProgress() -> CGFloat {
//        return Player.instance.cof
        return .zero
    }
}
