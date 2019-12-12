//
//  Skill.swift
//  startupeiros
//
//  Created by Bruno Pastre on 26/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

class Skill: Profiter, Producer , Identifier, Upgradeable {
    
    private var name: String
    private var iconName: String
    
    var currentLevel: Double! = 1
    var levelProgress: Double! = 0
    
    var profiter: Profiter!
    var tasks: [Task] = []
    
    required init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        
    }
    
    func addTask(_ task: Task){
        task.profiter = self
        self.tasks.append(task)
    }
    
    // MARK: - Profiter
    func receive(_ amount: Coin, from producer: Producer) {
        
//        self.currentValue.append(amount)
        self.upgrade()
        
        if let task = producer as? Bindable {
            EventBinder.trigger(event: task)
        }
    }
    
    // MARK: - Producer
    func deliver(_ amount: Coin, to profiter: Profiter) {
        self.profiter.receive(amount, from: self)
    }
    
    func getProductionMultiplier() -> Double {
        
        return 1
    }
    
    func getProductionBase() -> Double {
        return 1.67
    }
    
    func getProductionOwned() -> Double {
        return self.getLevel()
    }
    
    func getProductionResult() -> Double {
        return self.getProductionBase() * self.getProductionMultiplier() * self.getProductionMultiplier()
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
        self.levelProgress > 1
    }
    
    func getBaseUpgradeCoast() -> Double {
        return self.currentLevel
    }
    
    func getUpgradeCoast() -> Double {
        return self.currentLevel
    }
    
    func getGrowthRate() -> Double {
        return 0
    }
    
    func getOwnedCount() -> Double {
        return self.currentLevel
    }
    
    func getUpgradeMultiplier() -> Double {
        return 2
    }
    
    func upgrade() {
        self.levelProgress += 0.1
        
        if self.isUpgradeable() {
            self.levelProgress = 0
            self.currentLevel += 1

            self.deliver(0, to: self.profiter)
        }
    }
    
    func getLevel() -> Double {
        return self.currentLevel
    }
    
    func getLevelProgress() -> Double {
        return self.levelProgress
    }
}
