//
//  Task.swift
//  startupeiros
//
//  Created by Bruno Pastre on 26/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

class Task: Producer, TimerDelegate, Identifier, Coaster, Bindable, Upgradeable {
    
    var giver: Giver!

    var upgradeCount: Double! = 0
    var name: String!
    var iconName: String!
    
    var timer: TaskTimer?
    var profiter: Profiter!
    
    required init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        self.giver = ResourceFacade.instance.workManager
        self.upgradeCount = 0
    }
    
    // MARK: - Coaster
    func onStart() {
        self.coast(from: self.giver)
        
        let payload: [String : Any] = [
            "duration": self.timer?.getDuration()
        ]
        EventBinder.trigger(event: self, payload: payload)
    }
    
    func canRun() -> Bool {
        if let timer = self.timer {
            if timer.isRunning() {
                return false
            }
        }
        
        return self.getCoastPerRun().getRawAmount() <= ResourceFacade.instance.workManager.accumulated
    }
    
    func getCoastPerRun() -> Coin {
        return 1 * getCoastMultiplier()
    }
    
    func getCoastMultiplier() -> Double {
        return 2 - (1/self.upgradeCount)
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
        return self.giver.canTake(self.getUpgradeCoast()) 
    }
    
    func getBaseUpgradeCoast() -> Double {
        return 4
    }
    
    func getUpgradeCoast() -> Double {
        return self.getBaseUpgradeCoast() *  pow(self.getGrowthRate(), self.getOwnedCount())
    }
    
    func getGrowthRate() -> Double {
        return 1.07
    }
    
    func getOwnedCount() -> Double {
        return self.upgradeCount
    }
    
    func getUpgradeMultiplier() -> Double {
        return 1
    }
    
    // MARK: - Producer
    
    func deliver(_ amount: Coin, to profiter: Profiter) {
        profiter.receive(amount, from: self)
    }
    
    
    func getProductionBase() -> Double {
        return 1.67
    }
    func getProductionMultiplier() -> Double {
        return 1
    }
    
    func getProductionOwned() -> Double {
        return self.upgradeCount
    }
    
    func getProductionResult() -> Double {
        return self.getProductionBase() * self.getProductionMultiplier() * self.getProductionMultiplier()
    }
    
    // MARK: - Instance methods
    func runTask(configure: @escaping () -> () ) {
        self.timer =  TimerFactory.timer(delegate: self)
        configure()
        self.timer?.run()
    }
    
    // MARK: - Timer  Delegate
    func onTrigger() {
        
    }
    
    func onComplete() {
        self.deliver(self.getProductionResult(), to: self.profiter)
    }
    
    func onInvalidated() {
        print("INVALIDOU")
    }
    
    
    
    func getQueueName() -> String {
        return self.getName()
    }
}

