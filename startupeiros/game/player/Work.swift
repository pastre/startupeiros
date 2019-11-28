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
    
    override func onTrigger() {
        print("Work triggered")
    }
    
    func canRun() -> Bool {
        return ResourceFacade.instance.coffeeManager.accumulated >= 1
    }
    
    func getCoastPerRun() -> Coin {
        return WorkCoin()
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
        let amount = WorkCoin()
    
        self.deliver(amount, to: self.profiter)
        self.coast(from: self.giver)
    
    }
    
}
