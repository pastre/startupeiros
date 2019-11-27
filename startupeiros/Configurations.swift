//
//  Player.swift
//  startupeiros
//
//  Created by Maykon Meneghel on 23/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import Firebase

class Hustler: Player {
    var skills: [String] = []
    func readSkills(completion: ((Bool) -> Void)? = nil){
        Database.database().reference().child("Game").child("Configurations").observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            for skill in postDict["HustlerSkills"] as! NSArray{
                self.skills.append(skill as! String)
            }
            if let completion = completion {
                completion(true)
            }
        })
    }
    func save(){
        Database.database().reference().child("Game").child("Configurations").child("Skills").child("HustlerSkills").setValue(skills)
    }
}

class Hacker: Player {
    var skills: [String] = []
    func readSkills(completion: ((Bool) -> Void)? = nil){
        Database.database().reference().child("Game").child("Configurations").observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            for skill in postDict["HackerSkills"] as! NSArray{
                self.skills.append(skill as! String)
            }
            if let completion = completion {
                completion(true)
            }
        })
    }
}

class Hipster: Player {
    var skills: [String] = []
    func readSkills(completion: ((Bool) -> Void)? = nil){
        Database.database().reference().child("Game").child("Configurations").observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            for skill in postDict["HipsterSkills"] as! NSArray{
                self.skills.append(skill as! String)
            }
            if let completion = completion {
                completion(true)
            }
        })
    }
}
