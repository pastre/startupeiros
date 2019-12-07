//
//  FirebaseReferenceFactory.swift
//  startupeiros
//
//  Created by Bruno Pastre on 07/12/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseReferenceFactory {
    static func meetup(_ teamId: String) -> DatabaseReference {
        return self.team(teamId).child(FirebaseKeys.meetup.rawValue)
    }
    
    static func team(_ teamId: String) -> DatabaseReference {
        return self.teams().child(teamId)
    }
    
    static func teams() -> DatabaseReference {
        return self.root().child(FirebaseKeys.teams.rawValue)
    }
    static func root() -> DatabaseReference {
        return Database.database().reference().root
    }
}
