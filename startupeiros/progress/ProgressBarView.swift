//
//  ProgressBarView.swift
//  startupeiros
//
//  Created by Bruno Pastre on 28/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class ProgressBarView: UIView, BindedSupplicant {
    
    var progressViewConstraint: NSLayoutConstraint?
    var completion: CGFloat = 0
    var progressView: UIView! = {
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
        self.progressViewConstraint =  self.progressView.widthAnchor.constraint(equalToConstant: 0)
            
        self.progressViewConstraint?.isActive = true
    }
    
    func update(_ notification: NSNotification) {
        print("Notified by", notification.name)
        guard let duration = notification.userInfo?["duration"] as? TimeInterval else { return }
        
        self.runAnimation(duration)
    }
    
    func runAnimation(_ duration: TimeInterval) {
        print("Running task", duration)
        UIView.animate(withDuration: duration, animations: {
            self.progressViewConstraint?.constant = self.frame.width
            
            self.layoutIfNeeded()
        }) { (_) in
            self.onComplete()
        }
    }
    
    
     func onComplete() {
        
        EventBinder.unbind(clas: self)
        
        self.progressViewConstraint?.constant = 0
        self.layoutIfNeeded()
    }
}

