//
//  Job.swift
//  startupeiros
//
//  Created by Bruno Pastre on 26/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Job: Profiter, Identifier, Completable {
    
    private var name: String
    private var iconName: String
    
    var currentValue: [Coin]!
    var skills: [Skill] = []
    
    func setSkills(to skills: [Skill]) {
        self.skills = skills
    }
    
    required init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
    }
    
    func receive(_ amount: Coin, from producer: Producer) {
        print("Job recvd", amount)
//        self.currentValue.append(amount)
        GameDatabaseFacade.instance.updateJobCompletion(to: self)
    }
    
    func getCurrentAmount() -> Double {
        return self.currentValue.map { (coin) -> Double in
            return coin.getRawAmount()
        }.reduce(0, +)
    }

    // MARK: - Identifier
    
    func getName() -> String {
        return self.name
    }

    func getIconName() -> String {
        return self.iconName
    }
    
    // MARK: - Completable
    
    func getCompletedSkillPercentage(_ skill: Skill) -> Double {
        return  1 - ((10 - skill.currentLevel) / 10)
    }
    
    func getCompletedPercentage() -> Double {
        let skillLevels = skills.filter({ (s) -> Bool in
            s.getLevel() != 1
        }).map { (skill) -> Double in
            return abs(self.getCompletedSkillPercentage(skill))
        }.reduce(0, +)  // Double(self.skills.count)
        
        let skillCompletion: Double = 1/Double(self.skills.count)
        print("skillLevels", skillLevels, skillCompletion)
        return skillLevels * skillCompletion
//        return (skillCompletion - skillLevels) / skillCompletion
    }
    
}
