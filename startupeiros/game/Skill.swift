//
//  Skill.swift
//  startupeiros
//
//  Created by Bruno Pastre on 26/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

class Skill: Profiter, Producer {
    
    var profiter: Profiter!
    
    var currentValue: [Coin] = []
    var tasks: [Task] = []
    
    init() {
        self.tasks = [Task].init(repeating: Task(profiter: self), count: 10)
    }
    
    func receive(_ amount: Coin, from producer: Producer) {
        self.currentValue.append(amount)
        print("RECVD", amount, producer)
    }
    
    
    // MARK: - Producer
    func deliver(_ amount: Coin, to profiter: Profiter) {
        self.profiter.receive(amount, from: self)
    }
    
    
}
