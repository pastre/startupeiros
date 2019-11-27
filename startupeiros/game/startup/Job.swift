//
//  Job.swift
//  startupeiros
//
//  Created by Bruno Pastre on 26/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

class Job: Profiter {
    var currentValue: [Coin]!
    var skills: [Skill] = []
    
    init() {
        self.skills = [Skill].init(repeating: Skill(), count: 2)
        
        print("SKILLS", skills)
    }
    
    func receive(_ amount: Coin, from producer: Producer) {
        self.currentValue.append(amount)
    }
    
    func getCurrentAmount() -> Double {
        return self.currentValue.map { (coin) -> Double in
            return coin.getRawAmount()
        }.reduce(0, +)
    }
    
    func debugJob() {
        for skill in self.skills {
            skill.debugSkill()
        }
    }
    
}
