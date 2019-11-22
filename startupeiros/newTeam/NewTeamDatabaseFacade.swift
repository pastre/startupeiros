//
//  NewTeamDatabaseFacade.swift
//  startupeiros
//
//  Created by Bruno Pastre on 22/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import FirebaseDatabase

public enum FirebaseKeys: String  {
    case newRooms = "newRooms"
    case playersInRoom = "players"
}
class NewTeamDatabaseFacade {
    
    static let rootRef = Database.database().reference().root
    static let auth = Authenticator.instance
    static var newRoomId: String?
    
    
    static func createRoom(named name: String, completion:  @escaping (Error?) -> ()) {
        guard let userId = auth.getUserId() else { return }
        let payload: [String: Any] = [
//            "players": [
//                userId : "false"
//            ],
            "name": name
        ]
        
        self.rootRef.child(FirebaseKeys.newRooms.rawValue).childByAutoId().setValue(payload) { (error, ref) in
            completion(error)
            newRoomId = ref.key
        }
        
    }
    
    static func joinRoom(_ roomId: String, completion: @escaping (Error?) -> ()) {
        guard let userId =  Authenticator.instance.getUserId() else { return }
        guard let playerName = Authenticator.instance.getUsername() else { return }
        
        self.rootRef.child(FirebaseKeys.newRooms.rawValue).child(FirebaseKeys.playersInRoom.rawValue).child(userId).setValue([
            "isReady": false,
            "username": playerName,
        ]) { (error, ref) in
            completion(error)
        }
    }
}
