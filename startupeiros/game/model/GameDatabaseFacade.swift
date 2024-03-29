//
//  GameDatabaseFacade.swift
//  startupeiros
//
//  Created by Bruno Pastre on 03/12/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import FirebaseDatabase

class GameDatabaseFacade: GameDatabaseSupplicantDelegate {
    
    func onCurrentJobUpdated(to newJob: JobProgressUpdate?) {
        guard let newJob = newJob else { return }
        var event: EventBinder.Event
        
        switch newJob.onClass {
        case .hacker:
                event = .hackerProgress
                self.hackerProgress = newJob.newValue
        case .hipster:
                event = .hipsterProgress
                self.hipsterProgress = newJob.newValue
        case .hustler:
                event = .hustlerProgress
                self.hustlerProgress = newJob.newValue
        case .none:
            fatalError("Failed to pick a job!!!")
        }
        
        EventBinder.trigger(event: event)
    }
    
    
    static let instance = GameDatabaseFacade()
    
    var supplicant:  GameDatabaseSupplicant!
    var jobs: [Job]?
    
    var hackerProgress: Double! = 0
    var hipsterProgress: Double! = 0
    var hustlerProgress: Double! = 0
    
    private init() {
        self.supplicant =  GameDatabaseSupplicant()
        self.supplicant.delegate = self
    }
    
    
    static func loadSkills(from databaseSkills: [DatabaseSkill], with profiter: Profiter) -> [Skill] {
        return databaseSkills.map({ (skill) -> Skill in
                let parsedSkill = Skill(name: skill.name, iconName: skill.icon)
                
                let tasks = skill.tasks.map { (dbTask) -> Task in
                    return Task(name: dbTask.name, iconName: dbTask.icon)
                }
            
                parsedSkill.profiter = profiter
                parsedSkill.tasks = tasks
                return parsedSkill
            })
        }
    
    
    func load(completion: @escaping ([Job], Job?) -> ()) {
        guard let playerClass = PlayerFacade.getPlayerClass() else { return }
        DatabaseAdmin.shared.loadJobs { (i, jobList) in
            
            let jobs = jobList.map { (databaseJob) -> Job in
                
                let job = Job(name: databaseJob.name, iconName: databaseJob.icon)
                var loadedSkills: [Skill]!
                
                switch playerClass {
                case .hacker:
                    loadedSkills = GameDatabaseFacade.loadSkills(from: databaseJob.hackerSkills, with: job)
                case .hipster:
                    loadedSkills = GameDatabaseFacade.loadSkills(from: databaseJob.hipsterSkills, with: job)
                case .hustler:
                    loadedSkills = GameDatabaseFacade.loadSkills(from: databaseJob.hustlerSkills, with: job)
                }

                
                job.setSkills(to: loadedSkills)
                
                return job
            }
            self.jobs = jobs

            self.getCurrentJob { (currentJob) in
                completion(jobs, currentJob)
            }
        }
    }
    
    
    func updateJobCompletion(to completable: Completable){
        guard let playerClass = PlayerFacade.getPlayerClass() else { return }
        guard let teamId = PlayerFacade.getPlayerTeamId() else { return }
        
        FirebaseReferenceFactory.getPlayerJobs(teamId, playerClass).setValue(completable.getCompletedPercentage())

    }
    
    func getCurrentJob(completion: @escaping (Job?) -> ()) {
         guard let teamId = PlayerFacade.getPlayerTeamId() else { return }
        FirebaseReferenceFactory.currentJobName(teamId).observeSingleEvent(of: .value) { (snap) in
            
            if let rawName = snap.value as? String {
                let pickedJob = self.jobs?.filter({ (job) -> Bool in
                    return job.getName() == rawName
                    }).first
                completion(pickedJob)
            }
            completion(nil)
        }
    }
    
    func startJob(_ job: Job) {
        guard let teamId = PlayerFacade.getPlayerTeamId() else { return }
        FirebaseReferenceFactory.currentJobName(teamId).setValue(job.getName())
        
        
        print("Configured job!")
    }
    
}
