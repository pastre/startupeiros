//
//  Coffee.swift
//  startupeiros
//
//  Created by Bruno Pastre on 26/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
class PlayerProducer: Producer, TimerDelegate {
    func onTrigger() {
        
    }
    
    func onComplete() {
        
    }
    
    func onInvalidated() {
        print("Coffee invalidated")
    }
    
    
    var profiter: Profiter!
    var taskTimer: TaskTimer?
    
    init() {
        self.profiter = Player.instance
    }
    
    func deliver(_ amount: Coin, to profiter: Profiter) {
        profiter.receive(amount, from: self)
    }
    
    func run() {
        self.taskTimer = TimerFactory.timer(delegate: self)
        self.taskTimer?.run()
    }
}

class Coffee: PlayerProducer {
    override func onTrigger() {
        print("Coffee triggered")
    }
    
    override func onComplete() {
        let amount = CoffeeCoin()
        
        self.deliver(amount, to: self.profiter)
    }
}

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
