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
    func isDone() -> Bool
    func onComplete()
}

class ProgressBarSupplicator {
    var supplicant: ProgressSupplicant!
    var timer: Timer?
    init(supplicant: ProgressSupplicant) {
        self.supplicant = supplicant
    }
    
    func supplicate() {
        if let timer = self.timer {
            timer.fire()
            return
        }
        self.timer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { (t) in
            self.supplicant.updateProgress()
        }
    }
    
    func complete() {
        self.timer?.invalidate()
    }
}

class ProgressBarView: UIView {
    
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
        
        self.progressViewWidthConstraint = self.progressView.widthAnchor.constraint(equalToConstant: 0)
        self.progressViewWidthConstraint?.isActive = true
    }
    
    func updateProgressView(){
        let completed = self.getProgress() * self.layer.frame.width
        
        self.progressViewWidthConstraint?.constant = completed
        
        self.layoutIfNeeded()
    }
    
    
    func getProgress() -> CGFloat {
        fatalError( "PROGRESS BAR SUBCLASS NOT IMPLEMENTING getProgress \(self)")
    }
}

class TimedProgressBar: ProgressBarView, ProgressSupplicant {
    
    
    func isDone() -> Bool {
        fatalError( "PROGRESS BAR SUBCLASS NOT IMPLEMENTING isDone \(self)")
    }
    
    func onComplete() {
        fatalError( "PROGRESS BAR SUBCLASS NOT IMPLEMENTING onComplete \(self)")
    }
    
    
    func updateProgress() {
        if self.isDone() {
            self.onComplete()
            return
        }
        let completePercent = self.getProgress()
        
        self.completion = completePercent
        self.updateProgressView()
    }

}

class CoffeeBar: TimedProgressBar{

    var supplicator: ProgressBarSupplicator?

    override func startProgress() {
        print("Configuring supplicator")
        self.supplicator = ProgressBarSupplicator(supplicant: self)
        self.supplicator?.supplicate()
    }
    
    
    override func onComplete() {
        self.progressViewWidthConstraint?.constant = 0
        self.supplicator?.complete()
        self.supplicator = nil
    }
    
    override func getProgress() -> CGFloat {
//        return Player.instance.cof
        guard let task = ResourceFacade.instance.coffeeManager.currentTask else { return 0 }
        guard let timer = task.taskTimer else { return  0 }
        
        let completion: TimeInterval = (timer.getCurrentTime()) / timer.getDuration()

        return CGFloat(completion)
    }
    
    override func isDone() -> Bool {
        
        guard let task = ResourceFacade.instance.coffeeManager.currentTask else { return false }
        guard let timer = task.taskTimer else { return  false }
        
        return timer.isDone()
    }
}

class WorkBar: ProgressBarView {
    
    override func getProgress() -> CGFloat {
        return CGFloat(ResourceFacade.instance.coffeeManager.accumulated) / 10
    }
    
    func isDone() -> Bool {
        fatalError( "PROGRESS BAR SUBCLASS NOT IMPLEMENTING isDone \(self)")
    }
    
    func onComplete() {
        fatalError( "PROGRESS BAR SUBCLASS NOT IMPLEMENTING onComplete \(self)")
    }
    
}
