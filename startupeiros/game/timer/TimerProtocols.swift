//
//  TimerProtocols.swift
//  startupeiros
//
//  Created by Bruno Pastre on 26/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

protocol TimerDelegate {
    func onStart()
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

protocol Balanceable {
    
    func getDurationMultiplier() -> TimeInterval
    func getBaseDuration() -> TimeInterval
    
    func getDuration() -> TimeInterval
    func getUpgradeCount() -> Double
    func upgrade()
}
