//
//  JoinTeamViewController.swift
//  startupeiros
//
//  Created by Bruno Pastre on 22/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Room {
    var id: String!
    var name: String!
    
    init(_ id: String, from dict: NSDictionary ) {
        self.id = id
        self.name = dict["name"] as! String
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
