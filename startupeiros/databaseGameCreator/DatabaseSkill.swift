//
//  DatabaseSkill.swift
//  startupeiros
//
//  Created by Maykon Meneghel on 27/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

class DatabaseSkill: Codable{
    init(name: String, icon:String, tasks: [DatabaseTask]){
        self.name = name
        self.icon = icon
        self.tasks = tasks
    }
    var name: String
    var icon: String
    var tasks: [DatabaseTask]
}
