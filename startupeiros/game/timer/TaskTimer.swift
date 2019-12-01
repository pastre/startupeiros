//
//  TaskTimer.swift
//  startupeiros
//
//  Created by Bruno Pastre on 26/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

class TaskTimer: Timeable {
    let updateFrequency: TimeInterval = 60 // Quantidade de vezes por segundo que a variavel eh atualizada
    internal var duration: TimeInterval
    internal var _isRunning: Bool
    internal var currentTime: TimeInterval
    internal var canRun: Bool
    internal var runCount = 0
    
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
        return self.getDuration() <= self.getCurrentTime()
    }
    
    func isRunning() -> Bool {
        return self.timer != nil
    }
    
    func run() {
        let interval = TimeInterval(1/self.updateFrequency)
        self.delegate?.onStart()
        self.timer  = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { (t) in
            
            self.currentTime += interval
            self.runCount += 1
        
            
             if TimeInterval(self.runCount).truncatingRemainder(dividingBy: self.updateFrequency) == 0 { self.onTrigger() }
            
            if self.isDone() {
                self.delegate?.onComplete()
                self.timer?.invalidate()
                self.timer = nil
            }
            
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
    }
    
}
