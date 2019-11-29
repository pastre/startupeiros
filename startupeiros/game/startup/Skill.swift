//
//  Skill.swift
//  startupeiros
//
//  Created by Bruno Pastre on 26/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

class Skill: Profiter, Producer , Identifier {
    func getName() -> String {
        return self.name
    }

    func getIconName() -> String {
        return self.iconName
    }

    private var name: String
    private var iconName: String
    
    var profiter: Profiter!
    
    var currentValue: [Coin]! = []
    var tasks: [Task] = []
    
    
    required init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        
    }
    
    func addTask(_ task: Task){
        task.profiter = self
        self.tasks.append(task)
    }
    
    // MARK: - Profiter
    func receive(_ amount: Coin, from producer: Producer) {
        
        self.currentValue.append(amount)
        print("RECVD", amount, producer)
    }
    
    func getCurrentAmount() -> Double {
        return self.currentValue.map { (coin) -> Double in
            return coin.getRawAmount()
        }.reduce(0, +)
    }

    
    // MARK: - Producer
    func deliver(_ amount: Coin, to profiter: Profiter) {
        self.profiter.receive(amount, from: self)
    }
    
    
    
}
