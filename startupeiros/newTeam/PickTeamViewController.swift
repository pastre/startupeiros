//
//  JoinTeamViewController.swift
//  startupeiros
//
//  Created by Bruno Pastre on 22/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PickTeamViewController: UIViewController {

    var navParent: UIViewController!
    
    let ref = Database.database().reference().root
    
    var rooms: [Room]! = []
    
    var joinFirstButton: UIButton = {
       let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Join first", for: .normal)
        button.backgroundColor = .red
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let child = self.ref.child(FirebaseKeys.newRooms.rawValue)
        
        child.observe(.childAdded) { (snap) in
            self.onChildAdded(snap)
        }
        
        child.observe(.childChanged) { (snap) in
            self.onChildChanged(to: snap)
        }
        
        self.view.backgroundColor = .green
        
        self.joinFirstButton.addTarget(self, action: #selector(self.onJoin), for: .touchDown)
        
        self.view.addSubview(self.joinFirstButton)
        
        self.joinFirstButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.joinFirstButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        self.joinFirstButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        self.joinFirstButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2).isActive = true
        
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

    @objc func onJoin() {
        self.dismiss(animated: true)  {
            guard let room = self.rooms.first else { return }
            guard let navParent = self.navParent as? NewTeamViewController else { return }
            navParent.joinRoom(room.id)
        }
    }
}
