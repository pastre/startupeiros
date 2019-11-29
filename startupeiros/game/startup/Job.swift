//
//  Job.swift
//  startupeiros
//
//  Created by Bruno Pastre on 26/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Job: Profiter, Identifier {
    
    func getName() -> String {
        return self.name
    }

    func getIconName() -> String {
        return self.iconName
    }
    
    private var name: String
    private var iconName: String
    
    var currentValue: [Coin]!
    
    private var skills: [Skill] = []
    
    func addSkill(_ newSkill: Skill){
        newSkill.profiter = self
        self.skills.append(newSkill)
    }
    
    required init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        
        
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
    
    
}
