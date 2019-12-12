//
//  DatabaseTask.swift
//  startupeiros
//
//  Created by Maykon Meneghel on 27/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

class DatabaseTask: Codable{
    init(name:String,icon:String){
        self.name = name
        self.icon = icon
    }
    var name: String
    var icon: String
}
