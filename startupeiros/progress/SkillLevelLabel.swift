//
//  SkillLevelLabel.swift
//  startupeiros
//
//  Created by Bruno Pastre on 29/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class SkillLevelLabel: SupplicantLabel {
    
    var skill: Skill?
    
    override func setup() {
        guard let skill = self.skill else { return }
        
        for task in skill.tasks {
            EventBinder.bind(self, to: task)
        }
    }
    
    
    override func update() {
        guard let skill = self.skill else { return }
        
        self.text = "Level \(Int(skill.getLevel()))"
    }
    
    func invalidate() {
        EventBinder.unbind(clas: self)
    }
    
}

