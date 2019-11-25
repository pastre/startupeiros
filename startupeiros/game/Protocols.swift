//
//  Protocols.swift
//  startupeiros
//
//  Created by Bruno Pastre on 25/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

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
    
    
    init(duration: TimeInterval) {
        self.duration = duration
        self._isRunning = false
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
    
    func setupTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTrigger), userInfo: nil, repeats: false)
    }
    
    func run() {
        self.runCycle(self.duration)
    }
    
    private func runCycle(_ remainingCyles: TimeInterval) {
        if let timer = self.timer {
            timer.
        } else { return }
    }
    
    func stop() {
        <#code#>
    }
    
    
    
    @objc func onTrigger() {
        
    }
    
}
