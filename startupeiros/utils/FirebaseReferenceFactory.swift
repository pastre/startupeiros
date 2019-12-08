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
    
    static func getPlayerJobs(_ teamId: String, _ playerClass: PlayerClass) -> DatabaseReference {
        return self.currentTeamJob(teamId).child(playerClass.rawValue)
    }
    
    static func currentJobName(_ teamId: String) -> DatabaseReference {
        return self.currentTeamJob(teamId).child(FirebaseKeys.jobName.rawValue)
    }
    
    static func currentTeamJob(_ teamId: String) -> DatabaseReference {
        return self.teamJobs(teamId).child(FirebaseKeys.currentTeamJob.rawValue)
    }
    
    static func teamJobs(_ teamId: String) -> DatabaseReference {
        return Database.database().reference().root.child(FirebaseKeys.teams.rawValue).child(teamId).child(FirebaseKeys.teamJobs.rawValue)
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
