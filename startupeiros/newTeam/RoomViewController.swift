//
//  RoomViewController.swift
//  startupeiros
//
//  Created by Bruno Pastre on 22/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit
import FirebaseDatabase


class RoomViewController: UIViewController {

    var roomId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let baseRef = Database.database().reference().root.child(FirebaseKeys.newRooms.rawValue).child(roomId).child(FirebaseKeys.playersInRoom.rawValue)
        
        baseRef.observe(.childAdded) { (snap) in
            self.onAdded(snap)
        }
        
        baseRef.observe(.childChanged) { (snap) in
            self.onChanged(snap)
        }
        baseRef.observe(.childRemoved) { (snap) in
            self.onRemoved(snap)
        }
        
        // Do any additional setup after loading the view.
    }
    
    func onAdded(_ snap: DataSnapshot) {
        
    }
    
    func onChanged(_ snap: DataSnapshot) {
        print("Changed!", snap)
    }
    
    func onRemoved(_ snap: DataSnapshot) {
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NewTeamDatabaseFacade.joinRoom(self.roomId) { error in
            if let error = error {
                print("erro ao entrar na sala", error)
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
