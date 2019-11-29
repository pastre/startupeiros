//
//  StepperBar.swift
//  startupeiros
//
//  Created by Bruno Pastre on 29/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class StepperBar: ProgressBarView {
    
    override func update(_ notification: NSNotification) {
        self.runAnimation(0.5)
    }
    
    func getProgress() -> CGFloat {
        fatalError("\(self) not implementing getProgress")
    }
    
    override func runAnimation(_ duration: TimeInterval) {
        
        UIView.animate(withDuration: duration, animations: {
            self.progressViewWidthConstraint?.constant = self.frame.width * self.getProgress()
            
            self.layoutIfNeeded()
        }) { (_) in
            self.onComplete()
        }
        
    }
    
}
