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
    override func onTrigger() {
        print("Work triggered")
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
    override init() {
        self.giver = Player.instance
    }
    
   override  func onComplete() {
        let amount = WorkCoin()
    
        self.deliver(amount, to: self.profiter)
        self.coast(from: self.giver)
    
    }
}
