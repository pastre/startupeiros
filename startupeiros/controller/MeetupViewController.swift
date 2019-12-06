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

class MeetupCollectionViewCell: UICollectionViewCell {
    
    var hasSetup: Bool = false
    var jobName: String!
    var voteCount: Int!
    
    let nameLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let votesLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        return label
    }()
    
    let backgroundImage: UIImageView = {
        let image = UIImageView()
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        
        return image
    }()
    
    func updateUI() {
        self.nameLabel.text = self.jobName
        self.votesLabel.text = "\(self.voteCount!) votes"
        
        if voteCount == 0 {
            self.backgroundImage.image = UIImage(named: "deselectedMeetupCellBg")
        } else {
            self.backgroundImage.image = UIImage(named: "meetupCellBg")
        }
    }
    
    func setup(jobName: String, voteCount: Int){
        self.jobName = jobName
        self.voteCount = voteCount
        
        self.updateUI()
        
        if self.hasSetup { return }
        
        self.contentView.addSubview(self.backgroundImage)
        self.contentView.addSubview(self.votesLabel)
        self.contentView.addSubview(self.nameLabel)
        
        backgroundImage.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        backgroundImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        votesLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        votesLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        votesLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5).isActive = true
        votesLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.3).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor).isActive = true
        
    }
    
}

class MeetupViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    var votes: [Vote]! = []
    var jobs: [Job]!

    let registerId = "register"
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(MeetupCollectionViewCell.self, forCellWithReuseIdentifier: self.registerId)
        
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    override func viewDidLoad() {
        self.jobs = GameDatabaseFacade.instance.jobs
        super.viewDidLoad()

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
    
}
