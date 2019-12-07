//
//  MeetupViewController.swift
//  startupeiros
//
//  Created by Bruno Pastre on 06/12/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

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

    let registerId = "register"
    
    override func viewDidLoad() {
        self.jobs = GameDatabaseFacade.instance.jobs
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // Do any additional setup after loading the view.
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
        
        cell.setup(jobName: job.getName(), voteCount: 0)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        
        return CGSize(width: size.width * 0.9, height: size.height * 0.3)
    }
    
}
