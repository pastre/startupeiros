//
//  SkillBar.swift
//  startupeiros
//
//  Created by Bruno Pastre on 29/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class SkillLevelBar: StepperBar {
    
    var skill: Skill!
    
    override func getProgress() -> CGFloat {
        return CGFloat(self.skill.getLevelProgress())
    }
    
    func setup() {
        for task in self.skill.tasks {
            EventBinder.bind(self, to: task)
        }
        let color = UIColor(displayP3Red: 232/255, green: 153/255, blue: 74/255, alpha: 1)
        
        self.backgroundColor = color.withAlphaComponent(0.1)
        self.progressView.backgroundColor = color
    }
    
    func invalidate() {
        EventBinder.unbind(clas: self)
        
    }
    
    override func onComplete() {
        
    }
}
