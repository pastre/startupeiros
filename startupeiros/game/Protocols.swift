//
//  Protocols.swift
//  startupeiros
//
//  Created by Bruno Pastre on 25/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

protocol TimerDelegate {
    func onTrigger()
    func onComplete()
    func onInvalidated()
}

protocol Timeable {
    var duration: TimeInterval { get set }
    var _isRunning: Bool { get set }
    var currentTime: TimeInterval { get set }
    
    func getDuration() -> TimeInterval
    func getCurrentTime() -> TimeInterval
    func getRemainingTime() -> TimeInterval
    func isDone() -> Bool
    func isRunning() -> Bool
    func run()
    func stop()
}


protocol Lockable {
    func isLocked() -> Bool
    func lock()
    func unlock()
}

protocol Completable {
    func isCompleted() -> Bool
}

protocol Coastable {
    func getCoastPerRun() -> Double
    func getMultiplier() -> Double
}

protocol Upgradeable {
    func getUpgradeCoast() -> Double
}

protocol Levelable {
    func getAbsoluteLevelPoints() -> Int
    func getLevel() -> Int
    func getLevelProgress() -> Int
    func getNextLevelRequirement() -> Int
}



class TaskTimer: Timeable {
    internal var duration: TimeInterval
    internal var _isRunning: Bool
    internal var currentTime: TimeInterval
    internal var canRun: Bool
    
    private var triggerCount: Int = 0
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
        
        if self.triggerCount == Int(self.duration) {
            self.delegate?.onComplete()
            self.timer?.invalidate()
            self.timer = nil
        }
        
        self.onTrigger()
        self.triggerCount += 1
    }
    
}
