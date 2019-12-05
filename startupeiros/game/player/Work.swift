//
//  Work.swift
//  startupeiros
//
//  Created by Bruno Pastre on 27/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation


class Work: PlayerProducer, Coster {
    
    var giver: Giver!
    
    required init(_ profiter: Profiter, manager: Balanceable) {
        super.init(profiter, manager: manager)
        self.giver  = ResourceFacade.instance.coffeeManager
    }
    
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
    
    func getCostPerRun() -> Coin {
        return WorkCoin()
    }
    
    func getCostMultiplier() -> Double {
        return 0.7887
    }
    
    func getMultiplier() -> Double {
        return 1
    }
    
    func cost(from giver: Giver) {
        giver.take(self.getCostPerRun())
    }
    
    
//    required init(_ profiter: Profiter, manager: ResourceManager<PlayerProducer>) {
//        super.init(profiter, manager: manager)
//        self.giver = ResourceFacade.instance.coffeeManager
//    }
    
   override  func onComplete() {
        let amount = self.getProductionResult()
    
        self.deliver(amount, to: self.profiter)
        self.cost(from: self.giver)

        EventBinder.trigger(event: .energy)
    

        self.upgrade()
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
         return self.getUpgradeCount()
    }
    
   override  func getUpgradeMultiplier() -> Double {
        return 1
    }
    
    override func upgrade() {
        self.manager.upgrade()
    }
}
