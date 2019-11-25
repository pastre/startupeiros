//
//  Model.swift
//  startupeiros
//
//  Created by Bruno Pastre on 22/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import FirebaseDatabase

class NewPlayer: NSObject {
    
    var id: String
    var name: String
    
    
    init(_ id: String, from dict: NSDictionary ) {
        self.id = id
        self.name = dict["username"] as! String
        
    }
}

class PickingClassPlayer: JoiningPlayer {
    var currentClass: String!
    
    override init(_ id: String, from dict: NSDictionary ) {
        super.init(id, from: dict)
        self.currentClass = (dict["currentClass"] as! String)
    }
}

class JoiningPlayer: NewPlayer {
    
    var isReady: Bool!
    
    
    override init(_ id: String, from dict: NSDictionary ) {
        super.init(id, from: dict)
        self.isReady = (dict["isReady"] as! Bool)
    }
}

class Room: NSObject {
    var id: String!
    var name: String!
    var players: [JoiningPlayer]! = []
    
    init(_ id: String, from dict: NSDictionary ) {
        self.id = id
        self.name = dict["name"] as! String
//        self.players =  JSONDecoder().decode([Player].self, from: d)
    }
    
}
