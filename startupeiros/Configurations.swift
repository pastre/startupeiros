//
//  Player.swift
//  startupeiros
//
//  Created by Maykon Meneghel on 23/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import Firebase
import GameKit

class Hustler: AuthPlayer {
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

class Hacker: AuthPlayer {
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

class Hipster: AuthPlayer {
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

class Job1{
    internal init(title: String, description: String, level: Int) {
        self.title = title
        self.description = description
        self.level = level
    }
    
    private var description: String
    private var title: String
    private var level: Int
    
    private var tasks: [Task] = []
    
    func addTask(_ newTask: Task){
        self.tasks.append(newTask)
    }
    
    func getLevel() -> Int{
        return self.level
    }
    func setLevel(newLevel: Int){
        self.level = newLevel
    }
}

class Task1{
    internal init(name: String, duration: Float, costPerRun: Float, costPerUpdate: Float) {
        self.name = name
        self.duration = duration // in seconds
        self.costPerRun = costPerRun
        self.costPerUpdate = costPerUpdate
    }
    
    private var name: String
    private var duration: Float
    private var costPerRun: Float
    private var costPerUpdate: Float
    
//    private var reward: Rewardable
    private var level: Int = 0
    private var isActive: Bool = false
    private var completed: Bool = false
    private var canRun: Bool = false
    private var isLocked: Bool = true
    private var multiplier: Float = 1
    
    func getLevel() -> Int{
        return self.level
    }

}

class Skill1{
    
    internal init(name: String, icon: String, tasks: [Task1]){
        self.name = name
        self.icon = icon
        self.tasks = tasks
    }
    
    private var name: String
    private var icon: String
    private var tasks: [Task1]
    
    
    var isLocked: Bool = true
    var completitionRate: Float = 0
    var completed: Bool = false
    
    func getLevel(index: Int) -> Int{
        var soma = 0
        for task in tasks{
            soma += task.getLevel()
        }
        return soma/tasks.count
    }
    func getLevelProgress(){
        
    }
}

class Startup{
    internal init(name: String, nich: String, country: String) {
        self.name = name
        self.nich = nich
        self.country = country
    }
    
    private var name: String
    private var nich: String
    private var country: String
    
    var players: [AuthPlayer] = []
    private var jobs: [Job] = []
    private var level: Int = 0
    
    func changeName(newName: String){
        self.name = newName
    }
    
    func changeNich(newNich: String){
        self.nich = newNich
    }
    
    func addPlayer(_ player: AuthPlayer){
        self.players.append(player)
    }
    
    func removePlayer(_ player: AuthPlayer){
        self.players.removeAll { (player) -> Bool in
            true
        }
    }
    
    func addJob(_ job: Job){
        self.jobs.append(job)
    }
    
    func removeJob(_ job: Job){
        self.jobs.removeAll { (job) -> Bool in
            true
        }
    }
    
    func updateLevel(_ newLevel: Int){
        self.level = newLevel
    }
    
    func downloadJobs(classSkill: String, completion: ((Bool) -> Void)? = nil){
        Database.database().reference().child("Game").child("Jobs").observe(DataEventType.value, with: { (snapshot) in
          let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            for job in postDict["\(classSkill)"] as! NSArray{
                self.jobs.append(job as! Job)
            }
            if let completion = completion {
                completion(true)
            }
        })
    }

}



class Game: GKDecisionTree{
    var myDecisionThree: GKDecisionTree!
    
    func trainDT() {
        let attributes = [ "Type?", "HP?", "Special?" ]
        let examples = [
            // Each sub-array has a value for each attribute:
            [ "Electric", 10,  true ], // Note: enum value for the "Type?" attribute
            [ "Electric", 30, false ],
            [ "Electric", 40, true ],
            [ "Fire", 20 , false ],
            [ "Fire", 30 , false ],
            [ "Water", 50 , true ],
            [ "Water", 40 , false ],
//            [ "Fase 8", "Hustler" , 25 ],
//            [ "Fase 9", "Hipster" , 23 ],
        ]
        let actions = [ // One for each entry in the examples array
            ["Psychic Strike"],
            ["Pound"],
            ["Barrier"],
            ["Pound"],
            ["Tackle"],
            ["Pound"],
            ["Tackle"],
//            ["Business Model"],
//            ["UI"],
            ]
         
        // Multiple type casts required to convert to collections of NSObjectProtocol in Swift
        self.myDecisionThree = GKDecisionTree(examples: examples as NSArray as! [[NSObjectProtocol]],
                                            actions: actions as NSArray as! [NSObjectProtocol],
                                            attributes: attributes as NSArray as! [NSObjectProtocol])
    }
    func testDT(){
        let answers = [
            "Type?": "Electrical", // an enum value
            "HP?": 39,
            "Special?": false,
            ] as [String : Any]
        if let result = self.myDecisionThree.findAction(forAnswers: answers as! [AnyHashable : NSObjectProtocol]){
            print("DECISION TREE")
            print(myDecisionThree)
            print("RESULT =====>")
            print(result)
        }
        
    }
}



// EXAMPLE
//// Create a Player
//let jogador1 = Hipster(user: nil, name: "Pedro")
//jogador1.readSkills { (Bool) in
//    print(jogador1.skills[3])
//}
//
//// Create a Startup
//let startup = Startup(name: "King Size", nich: "app", country: "Brasil")
//// Add a player
//startup.addPlayer(jogador1)
//
//// Create a Job
//let job = Job(title: "Fazer MVP", description: "Nessa tarefa, você e a sua  equipe deverão ser capazes de construir um produto  mínimo viável...", level: 1)
//
//let task = Task(title: "Definir um core", history: "Para avançar no desenvolvimento de um MVP, vocÊ e a sua eqquipe precisam definir o coração do produto ou serviço que vocês querem entregar", scrumPoints: 20, time: 6)
//// Add a necessary Skills
//task.addNecessarySkills("Back-End")
//task.addNecessarySkills("Front-End")
//
//// Add a necessary Skills
//task.addUnecessarySkills("Paisagism")
//
//// Add a task in the Job
//job.addTask(task)
//
//// Add Job in the Startup
//startup.addJob(job)
