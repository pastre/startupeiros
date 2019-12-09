//
//  LobbyCollectionViewCell.swift
//  startupeiros
//
//  Created by Maykon Meneghel on 07/12/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class LobbyCollectionViewCell: UICollectionViewCell {
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let headView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 235/255, green: 155/255, blue: 4/255, alpha: 1.0)
        return view
    }()
    
    let bodyView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let playerOneImage: UIImageView = {
        let image = UIImage()
        return UIImageView(image: image)
    }()
    
    let playerTwoImage: UIImageView = {
        let image = UIImage()
        return UIImageView(image: image)
    }()
    
    let playerThreeImage: UIImageView = {
        let image = UIImage()
        return UIImageView(image: image)
    }()
    
    let  startupNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    let  ownerNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        label.textColor = .gray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let playerOne: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0)
        return view
    }()
    
    let playerTwo: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0)
        return view
    }()
    
    let playerThree: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0)
        return view
    }()
    
    let joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("Entrar", for: .normal)
        button.titleLabel?.textColor = UIColor(red: 4/255, green: 119/255, blue: 235/255, alpha: 1.0)
        button.backgroundColor = UIColor(red: 4/255, green: 119/255, blue: 235/255, alpha: 1.0)
        button.titleLabel?.textColor = UIColor.white
        return button
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    
    func setup(_ players: [JoiningPlayer]) {
//        self.contentView.translatesAutoresizingMaskIntoConstraints = false
//        self.contentView.heightAnchor.constraint(equalToConstant: 250).isActive = true
//        self.contentView.widthAnchor.constraint(equalToConstant: 145).isActive = true
//
        self.contentView.addSubview(self.cardView)
        self.cardView.layer.cornerRadius = 20.0
        self.cardView.translatesAutoresizingMaskIntoConstraints = false
        self.cardView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.cardView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.cardView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor).isActive = true
        self.cardView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
//        self.cardView.layer.applySketchShadow(color: UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1.0), alpha: 1.0, x: 7, y: 5, blur: 0, spread: 0)
        
        self.cardView.addSubview(self.headView)
        self.headView.layer.cornerRadius = 20.0
        self.headView.translatesAutoresizingMaskIntoConstraints = false
        self.headView.topAnchor.constraint(equalTo: self.cardView.topAnchor).isActive = true
        self.headView.centerXAnchor.constraint(equalTo: self.cardView.centerXAnchor).isActive = true
        self.headView.widthAnchor.constraint(equalTo: self.cardView.widthAnchor).isActive = true
        self.headView.heightAnchor.constraint(equalTo: self.cardView.heightAnchor, multiplier: 0.3).isActive = true
        
        self.headView.addSubview(self.startupNameLabel)
        self.startupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.startupNameLabel.bottomAnchor.constraint(equalTo: self.headView.bottomAnchor, constant: -10.0).isActive = true
        self.startupNameLabel.leadingAnchor.constraint(equalTo: self.headView.leadingAnchor, constant: 10.0).isActive = true
        self.startupNameLabel.heightAnchor.constraint(equalTo: self.headView.heightAnchor).isActive = true
        self.startupNameLabel.widthAnchor.constraint(equalTo: self.headView.widthAnchor).isActive = true
        
        self.cardView.addSubview(self.bodyView)
        self.bodyView.translatesAutoresizingMaskIntoConstraints = false
        self.bodyView.topAnchor.constraint(equalTo: self.headView.bottomAnchor, constant: -20).isActive = true
        self.bodyView.centerXAnchor.constraint(equalTo: self.cardView.centerXAnchor).isActive = true
        self.bodyView.widthAnchor.constraint(equalTo: self.cardView.widthAnchor).isActive = true
        self.bodyView.heightAnchor.constraint(equalTo: self.cardView.heightAnchor, multiplier: 0.7).isActive = true

        self.bodyView.addSubview(self.ownerNameLabel)
        self.ownerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.ownerNameLabel.topAnchor.constraint(equalTo: self.bodyView.topAnchor, constant: 5).isActive = true
        self.ownerNameLabel.leadingAnchor.constraint(equalTo: self.startupNameLabel.leadingAnchor).isActive = true
        self.ownerNameLabel.widthAnchor.constraint(equalTo: self.bodyView.widthAnchor, multiplier: 0.7).isActive = true

        self.bodyView.addSubview(self.numberLabel)
        self.numberLabel.translatesAutoresizingMaskIntoConstraints = false
        self.numberLabel.centerYAnchor.constraint(equalTo: self.ownerNameLabel.centerYAnchor).isActive = true
        self.numberLabel.trailingAnchor.constraint(equalTo: self.bodyView.trailingAnchor).isActive = true
        self.numberLabel.widthAnchor.constraint(equalTo: self.bodyView.widthAnchor, multiplier: 0.25).isActive = true
        
        self.bodyView.addSubview(self.joinButton)
        self.joinButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.joinButton.bottomAnchor.constraint(equalTo: self.bodyView.bottomAnchor).isActive = true
        self.joinButton.centerXAnchor.constraint(equalTo: self.bodyView.centerXAnchor).isActive = true
        self.joinButton.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        self.joinButton.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        self.bodyView.addSubview(self.playerTwo)
        self.playerTwo.translatesAutoresizingMaskIntoConstraints = false
        self.playerTwo.bottomAnchor.constraint(equalTo: self.joinButton.topAnchor, constant: -20.0).isActive = true
        self.playerTwo.centerXAnchor.constraint(equalTo: self.bodyView.centerXAnchor).isActive = true
        self.playerTwo.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        self.playerTwo.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
        
        self.playerTwo.addSubview(self.playerTwoImage)
        self.playerTwoImage.image = UIImage(named: "withoutPlayer")
        self.playerTwoImage.translatesAutoresizingMaskIntoConstraints = false
        self.playerTwoImage.centerYAnchor.constraint(equalTo: self.playerTwo.centerYAnchor).isActive = true
        self.playerTwoImage.centerXAnchor.constraint(equalTo: self.playerTwo.centerXAnchor).isActive = true
        self.playerTwoImage.heightAnchor.constraint(equalTo: self.playerTwo.heightAnchor).isActive = true
        self.playerTwoImage.widthAnchor.constraint(equalTo: self.playerTwo.widthAnchor).isActive = true
        
        self.bodyView.addSubview(self.playerOne)
        self.playerOne.translatesAutoresizingMaskIntoConstraints = false
        self.playerOne.centerYAnchor.constraint(equalTo: self.playerTwo.centerYAnchor).isActive = true
        self.playerOne.trailingAnchor.constraint(equalTo: self.playerTwo.leadingAnchor, constant: -10.0).isActive = true
        self.playerOne.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        self.playerOne.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
        
        self.playerOne.addSubview(self.playerOneImage)
        self.playerOneImage.image = UIImage(named: "withoutPlayer")
        self.playerOneImage.translatesAutoresizingMaskIntoConstraints = false
        self.playerOneImage.centerYAnchor.constraint(equalTo: self.playerOne.centerYAnchor).isActive = true
        self.playerOneImage.centerXAnchor.constraint(equalTo: self.playerOne.centerXAnchor).isActive = true
        self.playerOneImage.heightAnchor.constraint(equalTo: self.playerOne.heightAnchor).isActive = true
        self.playerOneImage.widthAnchor.constraint(equalTo: self.playerOne.widthAnchor).isActive = true
        
        self.bodyView.addSubview(self.playerThree)
        self.playerThree.translatesAutoresizingMaskIntoConstraints = false
        self.playerThree.centerYAnchor.constraint(equalTo: self.playerTwo.centerYAnchor).isActive = true
        self.playerThree.leadingAnchor.constraint(equalTo: self.playerTwo.trailingAnchor, constant: 10.0).isActive = true
        self.playerThree.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        self.playerThree.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
        
        self.playerThree.addSubview(self.playerThreeImage)
        self.playerThreeImage.image = UIImage(named: "withoutPlayer")
        self.playerThreeImage.translatesAutoresizingMaskIntoConstraints = false
        self.playerThreeImage.centerYAnchor.constraint(equalTo: self.playerThree.centerYAnchor).isActive = true
        self.playerThreeImage.centerXAnchor.constraint(equalTo: self.playerThree.centerXAnchor).isActive = true
        self.playerThreeImage.heightAnchor.constraint(equalTo: self.playerThree.heightAnchor).isActive = true
        self.playerThreeImage.widthAnchor.constraint(equalTo: self.playerThree.widthAnchor).isActive = true
         
        
        print("CONfIGURING CELL FOR PLAYERS", players.count)
        let images = [playerOneImage, playerTwoImage, playerThreeImage, ]
        
        for (i, player) in players.enumerated() {
            if player.isReady {
                images[i].image = UIImage(named: "withPlayer")
            } else {
                images[i].image = UIImage(named: "withoutPlayer")
            }
        }
        
        if players.count == 1 {
            playerOne.isHidden = false
            playerTwo.isHidden = true
            playerThree.isHidden = true
        }
        if players.count == 2 {
            playerOne.isHidden = false
            playerTwo.isHidden = false
            playerThree.isHidden = true
        }
        if players.count == 3 {
            playerOne.isHidden = false
            playerTwo.isHidden = false
            playerThree.isHidden = false
        }
    }
    
    
}
