//
//  Model.swift
//  startupeiros
//
//  Created by Bruno Pastre on 22/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import FirebaseDatabase

class JoiningPlayer: NSObject, Encodable, Decodable {
    
    var id: String
    var isReady: Bool!
    var name: String
    
    enum CodingKeys: String, CodingKey{
        case id = "id"
        case isReady = "isReady"
        case name = "name"
    }

    required init(decoder aDecoder: Decoder) throws {
        let container = try aDecoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.isReady = try container.decode(Bool.self, forKey: .isReady)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
    
        try container.encode(id, forKey: .id)
        try container.encode(isReady, forKey: .isReady)
        try container.encode(name, forKey: .name)
        
    }

    init(_ id: String, from dict: NSDictionary ) {
        self.id = id
        self.isReady = dict["isReady"] as! Bool
        self.name = dict["username"] as! String
    }
    
    convenience init(from snap: DataSnapshot) {
        self.init(snap.key, from: snap.value as! NSDictionary)
    }
}

class Room: NSObject, Encodable, Decodable {
    var id: String!
    var name: String!
    var players: [JoiningPlayer]! = []
    
    enum CodingKeys: String, CodingKey{
        case id = "id"
        case name = "name"
        case players = "players"
    }

    required init(decoder aDecoder: Decoder) throws {
        let container = try aDecoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.players = try container.decode([JoiningPlayer].self, forKey: .players)
    }

    
    init(_ id: String, from dict: NSDictionary ) {
        self.id = id
        self.name = dict["name"] as! String
//        self.players =  JSONDecoder().decode([Player].self, from: d)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(players, forKey: .players)
        
    }
    
    convenience init(from snap: DataSnapshot) {
        self.init(snap.key, from: snap.value as! NSDictionary)
    }
}
