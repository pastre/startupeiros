//
//  TaskTimer.swift
//  startupeiros
//
//  Created by Bruno Pastre on 26/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

class TaskTimer: Timeable {
    internal var duration: TimeInterval
    internal var _isRunning: Bool
    internal var currentTime: TimeInterval
    internal var canRun: Bool
    
    var delegate: TimerDelegate?
    
    init(duration: TimeInterval) {
        self.duration = duration
        self._isRunning = false
        self.canRun = false
        self.currentTime = 0
    }
    
    var timer: Timer?
    
    func getDuration() -> TimeInterval {
        return self.duration
    }
    
    func getCurrentTime() -> TimeInterval {
        return self.currentTime
    }
    
    func getRemainingTime() -> TimeInterval {
        return self.getDuration() - self.getCurrentTime()
    }
    
    func isDone() -> Bool {
        return self.getDuration() == self.getCurrentTime()
    }
    
    func isRunning() -> Bool {
        return self._isRunning
    }
    
    func run() {
        self.timer  = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (t) in
            self.onTrigger()
        })
    }

    func stop() {
        self.delegate?.onInvalidated()
        self.timer?.invalidate()
        self.timer = nil
    }
    
    private func onTrigger() {
        if self.timer == nil { return }
        
        if self.isDone() {
            self.delegate?.onComplete()
            self.timer?.invalidate()
            self.timer = nil
            return
        }
        
        self.delegate?.onTrigger()
        self.currentTime += 1
    }
    
}

class TimerFactory {
    static func timer(delegate: TimerDelegate) -> TaskTimer {
        let timer = TaskTimer(duration: 2)
        timer.delegate = delegate
        return timer
    }
}
