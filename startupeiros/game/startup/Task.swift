//
//  Task.swift
//  startupeiros
//
//  Created by Bruno Pastre on 26/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation



class Task: Producer, Upgradeable, TimerDelegate, Identifier, Coaster {
    var giver: Giver!

    var name: String
    var iconName: String
    
    var timer: TaskTimer?
    var profiter: Profiter!
    
    
    required init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        self.giver = ResourceFacade.instance.workManager
    }
    
    // MARK: - Coaster
    func onStart() {
        self.coast(from: self.giver)
        EventBinder.trigger(event: .work)
    }
    
    func canRun() -> Bool {
        if self.timer?.isRunning() ?? false { return false }
        return self.getCoastPerRun().getRawAmount() <= ResourceFacade.instance.workManager.accumulated
    }
    
    func getCoastPerRun() -> Coin {
        return 1 * getMultiplier()
    }
    
    func getMultiplier() -> Double {
        return 1
    }
    
    func coast(from giver: Giver) {
        giver.take(self.getCoastPerRun())
    }
    // MARK: - Identifier
    func getName() -> String {
        return self.name
    }
    
    func getIconName() -> String {
        return self.iconName
    }
    
    
    // MARK: - Upgradeable

    func isUpgradeable() -> Bool {
        return false
    }
    
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
    
    
    
    // MARK: - Timer  Delegate
    func onTrigger() {
        print("Trigger  ")
    }
    
    func onComplete() {
//        self.deliver(10, to: self.profiter)
    }
    
    func onInvalidated() {
        print("INVALIDOU")
    }
    
}

