//
//  ProgressView.swift
//  startupeiros
//
//  Created by Bruno Pastre on 27/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit


class TimedProgressBar: ProgressBarView, ProgressSupplicant {
    
    func startProgress() {
        fatalError( "PROGRESS BAR SUBCLASS NOT IMPLEMENTING startProgress \(self)")
    }
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



