//
//  Coffee.swift
//  startupeiros
//
//  Created by Bruno Pastre on 26/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

class Coffee: PlayerProducer {

    override func triggerUpdate() {
        EventBinder.trigger(event: .energy)
    }
    
    override func onStart() {
        let payload = [
            "duration": self.taskTimer?.getDuration(),
//            "event": .coffeeStart
        ]
        EventBinder.trigger(event: .coffeeStart, payload: payload)
    }
    
    override func onTrigger() {
        print("Coffee triggered")
    }
    
    override func onComplete() {
        let amount = self.getProductionResult()
        self.deliver(amount, to: self.profiter)
        
        EventBinder.trigger(event: .energy)
    }
    
    override func getProductionMultiplier() -> Double {
        return 0.5
    }
    
    override func getProductionBase() -> Double {
        return 1.67
    }
    
    override func getProductionOwned() -> Double {
        return self.upgradeCount
    }
    
    override func getProductionResult() -> Double {
        return self.getProductionBase() * self.getProductionMultiplier() * self.getProductionMultiplier()
    }
    
    // MARK: - Upgradeable
    
    override func isUpgradeable() -> Bool {
        
        // todo: - Implement this
        return true
    }
    
    override func getBaseUpgradeCoast() -> Double {
        return 4
    }
    
    override func getUpgradeCoast() -> Double {
        
        return self.getBaseUpgradeCoast() * pow(self.getOwnedCount(), self.getUpgradeMultiplier())
    }
    
    override func getGrowthRate() -> Double {
        return 1.07
    }
    
    override func getOwnedCount() -> Double {
         return self.upgradeCount
    }
    
    override func getUpgradeMultiplier() -> Double {
        return 1
    }

}
