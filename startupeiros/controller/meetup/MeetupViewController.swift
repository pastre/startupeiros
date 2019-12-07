//
//  MeetupViewController.swift
//  startupeiros
//
//  Created by Bruno Pastre on 06/12/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Vote {
    
    internal init(name: String?, whoPicked: PlayerClass?) {
        self.name = name
        self.whoPicked = whoPicked
    }
    
    var name: String!
    var whoPicked: PlayerClass?
}

class MeetupViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var votes: [Vote]! = []
    var jobs: [Job]!
    var currentSelectedJob: String?

    let registerId = "register"
    
    override func viewDidLoad() {
        self.jobs = GameDatabaseFacade.instance.jobs
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.setupFirebase()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Firebase functions
    
    func setupFirebase(){
        guard let teamId = PlayerFacade.getPlayerTeamId() else { return }
        
        FirebaseReferenceFactory.meetup(teamId).observe(.value) {
            (snap) in
            self.onMeetupUpdated(to: snap)
        }
        
        self.createMeetupIfNeeded()
    }
    
    func createMeetupIfNeeded(){
//        guard let teamId = PlayerFacade.getPlayerTeamId() else { return }
//
//        FirebaseReferenceFactory.team(teamId).observeSingleEvent(of: .value) { (snap) in
//            guard let value = snap.value as? NSDictionary else { return }
//
//
//        }
    }
    
    func onMeetupUpdated(to snap: DataSnapshot) {
        guard let votes = snap.value as? NSDictionary else { return }
        guard let currentPClass = PlayerFacade.getPlayerClass() else { return }
        var newVotes: [Vote] = []
        self.currentSelectedJob = nil
        for (playerClass, vName) in votes {
            let pClass = PlayerClass(from: playerClass as! String)
            let voteName = vName as! String
            let vote = Vote(name: voteName, whoPicked: pClass)
            
            if pClass == currentPClass {
                self.currentSelectedJob = voteName
            }
            
            newVotes.append(vote)
        }
        
        self.votes = newVotes
        print("SNAP IS", snap)
        self.collectionView.reloadData()
    }
    
    func vote(on job: Job){
        guard let teamId = PlayerFacade.getPlayerTeamId() else { return }
        guard let playerClass = PlayerFacade.getPlayerClass() else { return }
    FirebaseReferenceFactory.meetup(teamId).child(playerClass.rawValue).setValue(job.getName())
    }
    
    func clearVote() {
        guard let teamId = PlayerFacade.getPlayerTeamId() else { return }
        guard let playerClass = PlayerFacade.getPlayerClass() else { return }
    FirebaseReferenceFactory.meetup(teamId).child(playerClass.rawValue).setValue(nil)

    }
    
    // MARK: - CollectionView Data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.jobs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.registerId, for: indexPath) as! MeetupCollectionViewCell
        
        let job = self.jobs[indexPath.item]
        
        let voteCount = self.votes.filter { (vote) -> Bool in
            vote.name == job.getName()
        }.count
        
        cell.setup(jobName: job.getName(), voteCount: voteCount)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let job = self.jobs[indexPath.item]
        
        if job.getName() == self.currentSelectedJob {
            self.clearVote()
            return
        }
        
        self.vote(on: job)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        
        let job = self.jobs[indexPath.item]
        
        if job.getName() == self.currentSelectedJob {
            return CGSize(width: size.width, height: size.height * 0.4)
            
        }
        return CGSize(width: size.width * 0.9, height: size.height * 0.3)
    }
    
}
