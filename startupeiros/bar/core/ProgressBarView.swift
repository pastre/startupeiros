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
        
        self.progressView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        self.progressView.transform = self.progressView.transform.scaledBy(x: 0, y: 1)
       
    }
    
    func update(_ notification: NSNotification) {
        
        guard let duration = notification.userInfo?["duration"] as? TimeInterval else { return }
        self.runAnimation(duration)
    }
    
    func runAnimation(_ duration: TimeInterval) {
        
        UIView.animate(withDuration: duration, animations: {
            self.progressView.transform = .identity
        }) { (_) in
            self.onComplete()
        }
    }
    
    
     func onComplete() {
        
        EventBinder.unbind(clas: self)
        self.progressView.transform = self.progressView.transform.scaledBy(x: 0, y: 1)
    }
}

