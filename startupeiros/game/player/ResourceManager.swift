//
//  CoffeeManager.swift
//  startupeiros
//
//  Created by Bruno Pastre on 27/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

class ResourceManager<T>: Profiter, Giver, Balanceable where T: PlayerProducer{

    var currentTask: T?
    var accumulated: Double = 0
    var upgradeCount: Double = 1

    func runTask(configure: @escaping() -> ()){
        let profiter = self
        if let task = self.currentTask  {
            if !(task.taskTimer?.isDone() ?? false)  { return }
        }
        
        if let task = self.currentTask as? Coster {
            if !task.canRun()  { return }
        }
        
        self.currentTask = T.init(profiter, manager: self)
        configure()
        self.currentTask?.run()
    }
    
    func getAccumulated() -> Double {
        return self.accumulated
    }
    
    // MARK: - PROFITER
    func receive(_ amount: Coin, from producer: Producer) {
        self.accumulated += amount.getRawAmount()
        self.triggerIfPossible()
    }
    
    // MARK: - Giver
    
    func take(_ amount: Coin) {
        self.accumulated -= amount.getRawAmount()
        print(self, accumulated)
        self.triggerIfPossible()
    }
    
    func canTake(_ amount: Coin) -> Bool {
        return amount.getRawAmount() <= self.accumulated
    }
    
    func triggerIfPossible() {
        guard let task = self.currentTask, let supplicator = task as? BindedSupplicator else { return }
        
        supplicator.triggerUpdate()
    }
    
    
    // MARK: - TimeBalanceable
    func getDuration() -> TimeInterval {
        return self.getBaseDuration() * self.getDurationMultiplier()
    }
    
    func getDurationMultiplier() -> TimeInterval {
        
        return 1/(2 * self.upgradeCount)
    }
    func getBaseDuration() -> TimeInterval {
        return 2
    }
    
    func getUpgradeCount() -> Double {
        return self.upgradeCount
    }
    
    func upgrade() {
        self.upgradeCount += 1
    }
    
}

class ResourceFacade {
    var coffeeManager = ResourceManager<Coffee>()
    var workManager = ResourceManager<Work>()
    
    static let instance = ResourceFacade()
    
    private init() {}

}
