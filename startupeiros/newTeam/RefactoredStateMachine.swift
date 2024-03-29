//
//  RefactoredStateMachine.swift
//  startupeiros
//
//  Created by Maykon Meneghel on 09/12/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation


enum ConfiguringState {
    case start
    case creating
    case naming
    case joining
    case inLobby
    case pickingClass
}

protocol StateMachineDelegate {
    func onStateChanged(to newState: ConfiguringState)
    func getPlayerName() -> String?
    func getRoomName() -> String?
    
}

class StateMachine {
    
    var states: [ConfiguringState]
    var delegate: StateMachineDelegate?
    var currentState = 0
    
    init(state: [ConfiguringState]) {
        self.states = state
    }
    
    func getCurrentState() -> ConfiguringState {
        return self.states[self.currentState]
    }
    
    func revertState() {
        self.currentState -= 1
        self.delegate?.onStateChanged(to: self.getCurrentState())
    }
    
    func passState() {
        switch self.getCurrentState() {
            
        case .creating:
            self.createRoom {
                error in
                if let error = error  {
                    // TODO
                }  else {
                    self._passState()
                }
            }
        case .naming:
            self.createPlayer { error in
                if let error = error {
                    
                } else {
                    self._passState()
                }
                
            }
        case .joining:
            self._passState()
        case .inLobby:
            self.pickClass { error in
                if let error = error {
                    print("Error picking class!", error)
                    return
                }
                self._passState()
            }
        default: break
        }
    }
    
    private func _passState() {
        self.currentState += self.getCurrentState() == .pickingClass ? 0 :  1
        self.delegate?.onStateChanged(to: self.getCurrentState())
        print("Passed state", self.getCurrentState())
    }
    
    func setup() {
        self.delegate?.onStateChanged(to: self.getCurrentState())
    }
    
    func pickClass(completion: @escaping (Error?) -> ()) {
        guard let roomId = NewTeamDatabaseFacade.newRoomId else { return }
        NewTeamDatabaseFacade.startPickingClass(roomId) { (error) in
            completion(error)
        }
    }
    
    func createPlayer(completion: @escaping (Error?) -> ()) {
        guard let playerName = self.delegate?.getPlayerName() else { return }
        Authenticator.instance.createPlayer(named: playerName) { (error) in
            completion(error)
        }
    }
    
    func createRoom(completion: @escaping (Error?) -> ()) {
        guard let playerName = self.delegate?.getPlayerName() else { return }
        guard let startupName = self.delegate?.getRoomName() else { return }
        Authenticator.instance.createPlayer(named: playerName) { (error) in
            NewTeamDatabaseFacade.createRoom(named: startupName) { (creationError) in
                guard let roomId = NewTeamDatabaseFacade.newRoomId else { return }
                NewTeamDatabaseFacade.joinRoom(roomId) { (joinError) in
                    
                    if error != nil {
                        completion(error)
                        return
                    }
                    
                    if creationError != nil {
                        completion(creationError)
                        return
                    }
                    
                    if joinError != nil {
                        completion(joinError)
                        return
                    }
                    
                    completion(nil)
                }
            }
        }
    }
    
}
