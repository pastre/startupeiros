//
//  DatabaseJob.swift
//  startupeiros
//
//  Created by Maykon Meneghel on 27/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import Firebase

class DatabaseJob: Codable{
    init(name: String, icon:String, hackerSkills: [DatabaseSkill], hustlerSkills: [DatabaseSkill], hipsterSkills: [DatabaseSkill]){
        self.name = name
        self.icon = icon
        self.hackerSkills = hackerSkills
        self.hustlerSkills = hustlerSkills
        self.hipsterSkills = hipsterSkills
    }
    var name: String
    var icon: String
    var hackerSkills: [DatabaseSkill]
    var hustlerSkills: [DatabaseSkill]
    var hipsterSkills: [DatabaseSkill]
}

