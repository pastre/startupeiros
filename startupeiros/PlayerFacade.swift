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
    }
    
    static func setPlayerRoomId(_ roomId: String){
        UserDefaults.standard.set(roomId, forKey: PlayerKeys.roomId.rawValue)
    }
    
    static func setPlayerClass(_ playerClass: String) {
        UserDefaults.standard.set(playerClass, forKey: PlayerKeys.playerClass.rawValue)
    }
    
    static func createPlayer(classed className: String, in room: String) {
        self.setPlayerClass(className)
        self.setPlayerRoomId(room)
        
        print("Created player!", className, room)
    }
}
