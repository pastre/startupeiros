//
//  JoinTeamViewController.swift
//  startupeiros
//
//  Created by Bruno Pastre on 22/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit
import FirebaseDatabase

class JoiningPlayer: NSObject, Encodable, Decodable {
    
    var id: String
    var isReady: Bool!
    
    enum CodingKeys: String, CodingKey{
        case id = "id"
        case isReady = "isReady"
    }

    required init(decoder aDecoder: Decoder) throws {
        let container = try aDecoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.isReady = try container.decode(Bool.self, forKey: .isReady)
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
    
        try container.encode(id, forKey: .id)
        try container.encode(isReady, forKey: .isReady)
        
    }
    

    
    init(_ id: String, from dict: NSDictionary ) {
        self.id = id
        self.isReady = dict[id] as! Bool
    }
    
    convenience init(from snap: DataSnapshot) {
        self.init(snap.key, from: snap.value as! NSDictionary)
    }
}

class Room: NSObject, Encodable, Decodable {
    var id: String!
    var name: String!
    var players: [JoiningPlayer]!
    
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

class PickTeamViewController: UIViewController {

    var navParent: UIViewController!
    
    let ref = Database.database().reference().root
    
    var rooms: [Room]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let child = self.ref.child(FirebaseKeys.newRooms.rawValue)
        child.observe(.childAdded) { (snap) in
            self.onChildAdded(snap)
        }
        
        child.observe(.childChanged) { (snap) in
            self.onChildChanged(to: snap)
        }
        // Do any additional setup after loading the view.
    }
    
    func onChildAdded(_ snap: DataSnapshot) {
        let newRoom = Room(from: snap)
        
        self.rooms.append(newRoom)
    }
    
    func onChildChanged(to snap: DataSnapshot) {
        for (i, room) in self.rooms.enumerated() {
            if room.id == snap.key {
                rooms[i] = Room(from: snap)
                return
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
