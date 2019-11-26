//
//  Task.swift
//  startupeiros
//
//  Created by Bruno Pastre on 26/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

extension Int: Coin {
    func getRawAmount() -> Double {
        return Double(self)
    }
}

class Task: Producer, Upgradeable, TimerDelegate {
    
    var timer: TaskTimer?
    var profiter: Profiter!
    
    init(profiter: Profiter) {
        self.profiter = profiter
    }
    
    // MARK: - Timer  Delegate
    func onTrigger() {
        print("Trigger  ")
    }
    
    func onComplete() {
        self.deliver(10, to: self.profiter)
    }
    
    func onInvalidated() {
        print("INVALIDOU")
    }
    
    // MARK: - Upgradeable
        
    func getUpgradeCoast() -> Double {
        return 0
    }
    
    func getUpgradeMultiplier() -> Double {
        return 1
    }
    
    // MARK: - Producer
    
    func deliver(_ amount: Coin, to profiter: Profiter) {
        
        profiter.receive(amount, from: self)
    }
    
    // MARK: - Instance methods
    func runTask() {
        self.timer =  TimerFactory.timer(delegate: self)
        self.timer?.run()
    }
    
}

