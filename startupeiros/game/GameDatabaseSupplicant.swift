//
//  GameDatabaseSupplicant.swift
//  startupeiros
//
//  Created by Bruno Pastre on 03/12/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import FirebaseDatabase

class JobProgressUpdate {
    var newValue: String!
    var onClass: PlayerClass!
}

protocol GameDatabaseSupplicantDelegate {
    func onCurrentJobUpdated(to newJob: JobProgressUpdate?)
}

class GameDatabaseSupplicant {
    
    var delegate: GameDatabaseSupplicantDelegate?
    init() {
        self.setup()
    }
    
    
    func setup() {
        guard let teamId = PlayerFacade.getPlayerTeamId() else { return }
        Database.database().reference().root.child(FirebaseKeys.teams.rawValue).child(teamId).child(FirebaseKeys.teamJobs.rawValue).child(FirebaseKeys.currentTeamJob.rawValue).observe(.value) { (snap) in
            self.onCurrent(snap: snap)
            
        }
    }
    
    func onCurrent(snap: DataSnapshot) {
       guard let rawDict = snap as? NSDictionary else {
            self.delegate?.onCurrentJobUpdated(to: nil)
            return
        }
        
        print("value changed to", rawDict)
        
    }
//    
//    func onCompleted() -> [Job] {
//        
//    }
}
