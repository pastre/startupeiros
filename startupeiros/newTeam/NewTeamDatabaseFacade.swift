//
//  NewTeamDatabaseFacade.swift
//  startupeiros
//
//  Created by Bruno Pastre on 22/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import FirebaseDatabase

class NewTeamDatabaseFacade {
    
    static let rootRef = Database.database().reference().root
    static let auth = Authenticator.instance
    static var newRoomId: String?
    
    enum FirebaseKeys: String  {
        case newRooms = "newRooms"
    }
    
    static func createRoom(named name: String, completion:  @escaping (Error?) -> ()) {
        guard let userId = auth.getUserId() else { return }
        let payload: [String: Any] = [
            "players": [
                userId : "false"
            ],
            "name": name
        ]
        
        self.rootRef.child(FirebaseKeys.newRooms.rawValue).childByAutoId().setValue(payload) { (error, ref) in
            completion(error)
            newRoomId = ref.key
        }
        
    }
}
