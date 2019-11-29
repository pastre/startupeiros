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
        let amount = CoffeeCoin()
        self.deliver(amount, to: self.profiter)
        
        EventBinder.trigger(event: .energy)
    }
}
