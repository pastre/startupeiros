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
    case pickingClass = "pickingClass"
    case playerClass = "class"
    case teams = "teams"
    case teamJobs = "teamJobs"
    case currentTeamJob = "current"
    case completedTeamJobs = "completed"
    case hackerJobProgress = "hacker"
    case hipsterJobProgress = "hipster"
    case hustlerJobProgress = "hustler"
    case none = "None"
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
        
        self.rootRef.child(FirebaseKeys.newRooms.rawValue).child(roomId).child(FirebaseKeys.playersInRoom.rawValue).child(userId).setValue([
            "isReady": false,
            "username": playerName,
        ]) { (error, ref) in
            completion(error)
        }
    }
    
    static func leaveRoom(_ roomId: String, completion: @escaping (Error?) -> ()) {
        guard let userId =  Authenticator.instance.getUserId() else { return }
        self.rootRef.child(FirebaseKeys.newRooms.rawValue).child(roomId).child(FirebaseKeys.playersInRoom.rawValue).child(userId).setValue(nil) {
            (error, ref) in
            completion(error)
        }
    }
    
    static func completeRoom(_ roomId: String, completion: @escaping(Error?) ->  () ) {
        self.rootRef.child(FirebaseKeys.newRooms.rawValue).child(roomId).setValue(nil) {
            (error, ref) in
            completion(error)
        }
    }
    
    static func startPickingClass(_ roomId: String, completion: @escaping(Error?) ->  () ) {
        guard let userId =  Authenticator.instance.getUserId() else { return }
        guard let playerName = Authenticator.instance.getUsername() else { return }
        self.rootRef.child(FirebaseKeys.pickingClass.rawValue).child(roomId).child("players").child(userId).setValue([
                "currentClass" : "none",
                "isReady": false,
                "username" : playerName,
            ]) {
            (error, _) in
            completion(error)
        }
    }
    
    static func pickClass(_ roomId: String, class pickedClass: String) {
        
        guard let userId =  Authenticator.instance.getUserId() else { return }
        self.rootRef.child(FirebaseKeys.pickingClass.rawValue).child(roomId).child("players").child(userId).child("currentClass").setValue(pickedClass)
    }
    
    static func joinTeam(_ roomId: String, classed className: String, completion: @escaping(Error?) ->  ()) {
        guard let userId =  Authenticator.instance.getUserId() else { return }
//    self.rootRef.child(FirebaseKeys.teams.rawValue).child(roomId).child(FirebaseKeys.playersInRoom.rawValue).child(userId).setValue(
    self.rootRef.child(FirebaseKeys.teams.rawValue).child(roomId).setValue(
            [
                FirebaseKeys.playersInRoom.rawValue : [userId : className],
                FirebaseKeys.teamJobs.rawValue : [
                FirebaseKeys.currentTeamJob.rawValue : "None",
                FirebaseKeys.completedTeamJobs.rawValue : "None",
                ]
            ]) {
            (error, ref) in
            
            completion(error)
            if let error =  error {
                print("Erro!!!!", error)
                return
            }
    self.rootRef.child(FirebaseKeys.pickingClass.rawValue).child(roomId).child(FirebaseKeys.playersInRoom.rawValue).setValue(nil)
                
        PlayerFacade.createPlayer(classed: className, in: roomId)
        }

    }
    
}
