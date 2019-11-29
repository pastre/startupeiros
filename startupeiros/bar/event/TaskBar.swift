//
//  TaskBar.swift
//  startupeiros
//
//  Created by Bruno Pastre on 28/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class TaskBar: TimedProgressBar  {
    
    var supplicator: ProgressBarSupplicator?
    var task: Task?

    override func startProgress() {
//        print("Configuring supplicator")
//        self.supplicator = ProgressBarSupplicator(supplicant: self)
//        self.supplicator?.supplicate()
    }
    
    override func onComplete() {
        self.progressViewWidthConstraint?.constant = 0
        self.supplicator?.complete()
        self.supplicator = nil
    }
    
    override func getProgress() -> CGFloat {
        
        guard let task = self.task else { return 0 }
        guard let timer = task.timer else { return  0 }
        
        let completion: TimeInterval = (timer.getCurrentTime()) / timer.getDuration()

        return CGFloat(completion)
    }
    
    override func isDone() -> Bool {
        
        guard let task = self.task else { return false }
        guard let timer = task.timer else { return  false }
        
        return timer.isDone()
    }
}
