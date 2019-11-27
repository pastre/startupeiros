//
//  DatabaseJob.swift
//  startupeiros
//
//  Created by Maykon Meneghel on 27/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import Firebase

class DatabaseJob: Codable{
    init(name: String, icon:String, hackerSkills: [DatabaseSkill], hustlerSkills: [DatabaseSkill], hipsterSkills: [DatabaseSkill]){
        self.name = name
        self.icon = icon
        self.hackerSkills = hackerSkills
        self.hustlerSkills = hustlerSkills
        self.hipsterSkills = hipsterSkills
    }
    var name: String
    var icon: String
    var hackerSkills: [DatabaseSkill]
    var hustlerSkills: [DatabaseSkill]
    var hipsterSkills: [DatabaseSkill]
    
    func saveGame() {
        do {
            let db = Firestore.firestore()
            let encoder = JSONEncoder()
            var ref: DocumentReference? = nil
            let data = try encoder.encode(self)
            let dict = try JSONSerialization.jsonObject(with: data) as! [String : Any]
            ref = db.collection("Jobs").addDocument(data: dict) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

