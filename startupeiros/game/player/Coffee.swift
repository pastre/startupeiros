//
//  Coffee.swift
//  startupeiros
//
//  Created by Bruno Pastre on 26/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

class Coffee: PlayerProducer {
    override func onTrigger() {
        print("Coffee triggered")
    }
    
    override func onComplete() {
        let amount = CoffeeCoin()
        self.deliver(amount, to: self.profiter)
        print("-------Coffee completed!!!")
    }
}
