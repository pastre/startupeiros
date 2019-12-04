//
//  PlayerFacade.swift
//  startupeiros
//
//  Created by Bruno Pastre on 23/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

class PlayerFacade: NSObject {
    
    enum PlayerKeys: String {
        case roomId = "roomId"
        case playerClass = "playerClass"
        case created = "created"
    }
    
    static func setPlayerRoomId(_ roomId: String){
        UserDefaults.standard.set(roomId, forKey: PlayerKeys.roomId.rawValue)
    }
    
    static func setPlayerClass(_ playerClass: String) {
        UserDefaults.standard.set(playerClass, forKey: PlayerKeys.playerClass.rawValue)
    }
    
    static func setPlayerCreated() {
        UserDefaults.standard.set(true, forKey: PlayerKeys.created.rawValue)
    }
    
    static func createPlayer(classed className: String, in room: String) {
        self.setPlayerClass(className)
        self.setPlayerRoomId(room)
        
        self.setPlayerCreated()
        
        print("Created player!", className, room)
    }
    
    static func hasCreated() -> Bool? {
        return UserDefaults.standard.bool(forKey: PlayerKeys.created.rawValue)
    }
    
    static func getPlayerClass() -> PlayerClass? {
        guard let rawClass =  UserDefaults.standard.string(forKey: PlayerKeys.playerClass.rawValue) else { return nil }
        
        return PlayerClass(from: rawClass)
    }
    
    static func getPlayerTeamId() -> String?{
        return UserDefaults.standard.string(forKey: PlayerKeys.roomId.rawValue)
    }
    
    
}
