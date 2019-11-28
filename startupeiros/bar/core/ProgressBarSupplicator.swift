//
//  ProgressBarSupplicator.swift
//  startupeiros
//
//  Created by Bruno Pastre on 28/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

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
