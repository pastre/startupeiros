//
//  PickClassViewController.swift
//  startupeiros
//
//  Created by Bruno Pastre on 22/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit
import FirebaseDatabase



class PickClassViewController: UIViewController {

    let classes = ["hacker", "hustler", "hipster"]
    
    let readyButton: UIButton = {
        let button = UIButton()
        
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Ready", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        
        return button
    }()
    
    var roomId: String!
    var buttonsStack:  UIStackView!
    var buttons: [UIButton]!
    var states: [String]!
    
    var isReady: Bool = false
    var currentClass: String? {
        didSet {
            self.readyButton.isEnabled = self.currentClass != nil
        }
    }
    var isConfigured: Bool = false
    
    var players: [PickingClassPlayer] = []
    
    lazy var baseRef = Database.database().reference().root.child(FirebaseKeys.pickingClass.rawValue).child(roomId).child("players")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
        self.setupButtons()
        self.setupReadyButton()
        self.setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NewTeamDatabaseFacade.startPickingClass(self.roomId) { (error) in
            if let error = error {
                print("Erro ao comecar a pegar as classes!", error)
            }
        }
    }
    
    func setupReadyButton() {
        
        self.readyButton.addTarget(self, action: #selector(self.onReady), for: .touchDown)
        
        self.view.addSubview(self.readyButton)
        
        self.readyButton.trailingAnchor.constraint(equalTo: self.buttonsStack.trailingAnchor).isActive = true
        self.readyButton.topAnchor.constraint(equalTo: self.buttonsStack.bottomAnchor).isActive = true
        
        self.readyButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3).isActive = true
        self.readyButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2).isActive = true
    }
    
    func setupObservers() {
        baseRef.observe(.childAdded) { (snap) in
            self.onAdded(snap)
        }
        
        baseRef.observe(.childChanged) { (snap) in
            self.onChanged(snap)
        }
        
        baseRef.observe(.childRemoved) { (snap) in
            self.onRemoved(snap)
        }
    }
    
    func setupButtons() {
        self.buttons = self.classes.map({ (string) -> UIButton in
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            
//            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(string, for: .normal)

            button.addTarget(self, action: #selector(self.onButton(_:)), for: .touchDown)
            button.backgroundColor = .blue
            
            return button
        })
        
        let stackView = UIStackView(arrangedSubviews: self.buttons)
        
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stackView)
    
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        stackView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2).isActive = true
        
        self.buttonsStack = stackView
    }
    
    // MARK: - Helpers methods
    
    func createTeamIfAllReady() {
        
        for player in self.players {
            if !player.isReady { return }
        }

        print("OPAOBA deu boa!!")
    }
    
    func updateButtonState() {
        var indexes: [Int] = []
        
        for player in self.players {
            if player.currentClass == "none" { continue }
            let index = self.classes.firstIndex(of: player.currentClass)!
            indexes.append(index)
        }

        for (i, button) in self.buttons.enumerated() {
            if indexes.contains(i) {
                button.setTitleColor(.red, for: .normal)
            } else {
                button.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    
    // MARK: - Observers
    
    func onAdded(_ snap: DataSnapshot) {
        print("Snaps is", snap)
        let newPlayer = PickingClassPlayer(snap.key, from: snap.value as! NSDictionary)
        
        self.players.append(newPlayer)
        self.updateButtonState()
    }
    
    func onChanged(_ snap: DataSnapshot) {
        print("Changed!", snap)
        let newPlayer = PickingClassPlayer(snap.key, from: snap.value as! NSDictionary)
        
        for (i, player) in self.players.enumerated()  {
            if player.id == newPlayer.id {
                self.players[i] = newPlayer
                break
            }
        }
        
        self.updateButtonState()
    }
    
    func onRemoved(_ snap: DataSnapshot) {
        print(snap)
        self.players.removeAll { (player) -> Bool in
            return player.id == snap.key
        }
    }
    
    @objc func onReady() {
        guard let username = Authenticator.instance.getUserId() else { return }
        guard let currentClass = self.currentClass else { return }
        
        self.isReady = !self.isReady
        
        if self.isReady{
            self.readyButton.setTitle("Cancel", for: .normal)
        } else {
            self.readyButton.setTitle("Ready", for: .normal)
        }
        
        
        self.baseRef.child(username).child("isReady").setValue(self.isReady) {
            (error, ref ) in
            if let error = error {
                print("Erro pra atualizar a ready!", error)
                return
            }
            self.createTeamIfAllReady()
            
        }
    }
    
    @objc func onButton(_ button: UIButton) {
        let index = self.buttons.firstIndex(of: button)!
        let picked = self.classes[index]
        print("kyfdsa")
        
        if self.isReady { return }
        
        let alreadyPicked = self.players.map { (player) -> String in
            return player.currentClass
        }
        
        if picked == self.currentClass {
            
            NewTeamDatabaseFacade.pickClass(self.roomId, class: "none")
            
            self.currentClass = nil
            
            return
        }
        
        if alreadyPicked.contains(picked) { return }
        
        NewTeamDatabaseFacade.pickClass(self.roomId, class: picked)
        self.currentClass = picked
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
