//
//  DatabaseAdmin.swift
//  startupeiros
//
//  Created by Maykon Meneghel on 27/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import Firebase

class DatabaseAdmin {
    static let shared: DatabaseAdmin = DatabaseAdmin()
    private init() {}
    
    func saveJob(job: DatabaseJob) {
        do {
            let db = Firestore.firestore()
            let encoder = JSONEncoder()
            var ref: DocumentReference? = nil
            let data = try encoder.encode(job)
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
    
    func loadJobs(completion: ((Bool, [DatabaseJob]) -> Void)? = nil){
        let db = Firestore.firestore()
        var jobList: [DatabaseJob] = []
        db.collection("Jobs").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                jobList.removeAll()
                
                for document in querySnapshot!.documents {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: document.data())
                        let job = try JSONDecoder().decode(DatabaseJob.self, from: data)
//                        job.jobID = document.documentID
                        jobList.append(job)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
                if let completion = completion {
                    completion(true, jobList)
                }
            }
        }
    }
}
