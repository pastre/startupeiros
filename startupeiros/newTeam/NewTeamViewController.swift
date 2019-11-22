//
//  JoinGameViewController.swift
//  startupeiros
//
//  Created by Bruno Pastre on 21/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class NewTeamViewController: UIViewController {

    func getButton(named name: String, selector: Selector)  ->  UIButton {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(name, for: .normal)
        button.addTarget(self, action: selector, for: .touchDown)
        
        button.backgroundColor = UIColor.blue
        
        return button
    }
    
    func setDefaultButtonSize(_ view: UIView)  {
        view.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        view.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2).isActive = true
    }
    
    var createButton: UIButton!
    var joinButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createButton = self.getButton(named: "Create team", selector: #selector(self.onCreate))
        self.joinButton = self.getButton(named: "Join team", selector: #selector(self.onJoin))
        
        self.view.addSubview(self.createButton)
        self.view.addSubview(self.joinButton)
        
        self.setDefaultButtonSize(self.createButton)
        self.setDefaultButtonSize(self.joinButton)
        
        self.createButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.createButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        self.joinButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.joinButton.topAnchor.constraint(equalTo: self.createButton.bottomAnchor).isActive = true
    }
    
    func joinRoom(_ roomId: String) {
        let vc = RoomViewController()

        vc.view.backgroundColor = .brown
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func onCreate() {
        print("Creating")
        let vc = CreateTeamViewController()
        vc.navParent = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func onJoin() {
        let vc = PickTeamViewController()
        vc.navParent = self
        self.present(vc, animated: true, completion: nil)
    }
}
