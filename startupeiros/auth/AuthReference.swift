//
//  AuthReference.swift
//  startupeiros
//
//  Created by Bruno Pastre on 21/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class Player {
    
    enum FirebaseKeys: String {
        case name = "name"
    }
    
    private let firebaseRef = Database.database().reference()

    internal init(user: User?, name: String) {
        self.user = user
        self.name = name
    }
    
    init(user: User) {
        self.user = user
    }
    
    
    func sync() {
        
        self.firebaseRef.child("users").child(self.user.uid).observe(.childChanged) { (snap) in
            guard let playerDict = snap as? NSDictionary else { return }
            self.name = playerDict[FirebaseKeys.name.rawValue] as? String
        }
    }
    
    func create() {
        self.firebaseRef.child("users").child(self.user.uid).setValue([FirebaseKeys.name.rawValue : self.name!])
        Authenticator.instance.setCreated()
    }
    
    var name: String?
    var user: User!
}

class Authenticator {
    
    static var instance = Authenticator()

    private var player: Player?
    
    private init() { }
    
    func getUsername() -> String? {
        return self.player?.name
    }
    
    func getUserId() -> String? {
        return self.player?.user.uid
    }
    
    func isLoggedIn() ->  Bool {
        return (self.player != nil)
    }
    
    func login(completion: @escaping (_ error:  Error?) -> ()) {
        Auth.auth().signInAnonymously { (authResult, error) in
            guard let auth = authResult  else {
                // TODO: - Avisar o erro para o  usuario
                print("Erro ao autenticar!", error!)
                completion(error)
                return
            }
            self.player = Player(user: auth.user)
            self.player?.sync()
        }
    }
    
    func createPlayer(named name: String, completion: @escaping (_ error:  Error?) -> ()) {
        Auth.auth().signInAnonymously { (authResult, error) in
            guard let auth = authResult  else {
                // TODO: - Avisar o erro para o  usuario
                print("Erro ao autenticar!", error!)
                completion(error)
                return
            }
            
            self.player = Player(user: auth.user, name: name)
            self.player?.create()
            self.player?.sync()
            completion(nil)
        }
    }
    
    func hasCreated() -> Bool {
        return UserDefaults.standard.bool(forKey: "created")
    }
    
    func setCreated() {
        UserDefaults.standard.set(true, forKey: "created")
    }
    
}
