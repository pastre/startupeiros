//
//  Work.swift
//  startupeiros
//
//  Created by Bruno Pastre on 27/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation


class Work: PlayerProducer, Coaster {
    
    var giver: Giver!
    
    override func triggerUpdate() {
        EventBinder.trigger(event: .work)
    }
    
    override func onStart() {
        let payload = [
            "duration": self.taskTimer!.getDuration()
        ]
        EventBinder.trigger(event: .workStart, payload: payload)
    }
    
    override func onTrigger() {
        print("Work triggered")
    }
    
    func canRun() -> Bool {
        return ResourceFacade.instance.coffeeManager.accumulated >= 1
    }
    
    func getCoastPerRun() -> Coin {
        return WorkCoin()
    }
    
    func getCoastMultiplier() -> Double {
        return 0.7887
    }
    
    func getMultiplier() -> Double {
        return 1
    }
    
    func coast(from giver: Giver) {
        giver.take(self.getCoastPerRun())
    }
    
    
    required init(_ profiter: Profiter) {
        super.init(profiter)
        self.giver = ResourceFacade.instance.coffeeManager
    }
    
   override  func onComplete() {
        let amount = self.getProductionResult()
    
        self.deliver(amount, to: self.profiter)
        self.coast(from: self.giver)

        EventBinder.trigger(event: .energy)
    }
    
    
    
    // MARK: - Upgradeable
    
    override func isUpgradeable() -> Bool {
        
        // todo: - Implement this
        return true
    }
    
   override  func getBaseUpgradeCoast() -> Double {
        return 4
    }
    
    override func getUpgradeCoast() -> Double {
        
        return 4
    }
    
   override  func getGrowthRate() -> Double {
        return 1.07
    }
    
   override  func getOwnedCount() -> Double {
         return self.upgradeCount
    }
    
   override  func getUpgradeMultiplier() -> Double {
        return 1
    }
}
