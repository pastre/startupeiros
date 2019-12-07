//
//  MeetupCollectionViewCell.swift
//  startupeiros
//
//  Created by Bruno Pastre on 07/12/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit


class MeetupCollectionViewCell: UICollectionViewCell {
    
    var hasSetup: Bool = false
    var jobName: String!
    var voteCount: Int!
    
    let nameLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let votesLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .right
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 11)
        
        return label
    }()
    
    let backgroundImage: UIImageView = {
        let image = UIImageView()
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        
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
        
        votesLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        votesLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        votesLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5).isActive = true
        votesLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.3).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor).isActive = true
        
    }
    
}

