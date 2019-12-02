//
//  PlayerProducer.swift
//  startupeiros
//
//  Created by Bruno Pastre on 27/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

class PlayerProducer: Producer, TimerDelegate, BindedSupplicator, Upgradeable {

    var manager: Balanceable!
    var profiter: Profiter!
    var taskTimer: TaskTimer?
    
    required init(_  profiter: Profiter, manager: Balanceable) {
        self.profiter = profiter
        self.manager = manager
    }

    func onStart() {
        // METODO EM BRANCO, IMPLEMENTADO PELAS SUBCLASSES
    }
    
    func triggerUpdate() {
        
        // METODO EM BRANCO, IMPLEMENTADO PELAS SUBCLASSES
    }
    
    func onTrigger() {
        // METODO EM BRANCO, IMPLEMENTADO PELAS SUBCLASSES
    }
    
    func onComplete() {
        // METODO EM BRANCO, IMPLEMENTADO PELAS SUBCLASSES
    }
    
    func onInvalidated() {
        // METODO EM BRANCO, IMPLEMENTADO PELAS SUBCLASSES
    }
    
        
    func deliver(_ amount: Coin, to profiter: Profiter) {
        profiter.receive(amount, from: self)
    }
    
    func run() {
        self.taskTimer = TimerFactory.timer(delegate: self, for: self.manager)
        
        self.taskTimer?.run()
    }
    
    
    // MARK: - Upgradeable
    
    func isUpgradeable() -> Bool {
        
        // todo: - Implement this
        fatalError("\(self) did not implement this method!")
    }
    
    func getBaseUpgradeCoast() -> Double {
        fatalError("\(self) did not implement this method!")
    }
    
    func getUpgradeCoast() -> Double {
        
        fatalError("\(self) did not implement this method!")
    }
    
    func getGrowthRate() -> Double {
        fatalError("\(self) did not implement this method!")
    }
    
    func getOwnedCount() -> Double {
         fatalError("\(self) did not implement this method!")
    }
    
    func getUpgradeMultiplier() -> Double {
        fatalError("\(self) did not implement this method!")
    }
    
    func upgrade() {
        fatalError("\(self) did not implement this method!")
    }
    
    // MARK: - Producer

    func getProductionMultiplier() -> Double {
        return 1
    }
    
    func getProductionBase() -> Double {
        return 1.67
    }
    
    func getProductionOwned() -> Double {
        return self.getUpgradeCount()
    }
    
    func getProductionResult() -> Double {
        
        return self.getProductionBase() * self.getProductionMultiplier() * self.getProductionOwned()
    }
    
    func getUpgradeCount() -> Double {
        return self.manager.getUpgradeCount()
    }
}
