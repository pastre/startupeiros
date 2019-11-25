//
//  RoomViewController.swift
//  startupeiros
//
//  Created by Bruno Pastre on 22/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit
import FirebaseDatabase


class RoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let playerThreshold = 3
    
    lazy var baseRef = Database.database().reference().root.child(FirebaseKeys.newRooms.rawValue).child(roomId).child(FirebaseKeys.playersInRoom.rawValue)

    var roomId: String!
    var players: [JoiningPlayer] = []
    var tableView: UITableView!
    var readyButton: UIButton = {
       let button = UIButton()
        
        button.backgroundColor = .cyan
        button.setTitle("Ready!", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var isReady: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupReadyButton()
        self.setupObservers()
        
        
        // Do any additional setup after loading the view.
    }
    
    func setupObservers(){
        
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
    
    func setupTableView()  {
        self.tableView = UITableView()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.view.addSubview(tableView)
        
        self.tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.tableView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        self.tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        self.tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.7).isActive = true
        
    }
    
    func setupReadyButton() {
        self.readyButton.addTarget(self, action: #selector(self.onReady), for: .touchDown)
        
        self.view.addSubview(readyButton)
        
        self.readyButton.trailingAnchor.constraint(equalTo: self.tableView.trailingAnchor).isActive = true
        self.readyButton.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 20).isActive = true
        self.readyButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2).isActive = true
        self.readyButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive =  true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NewTeamDatabaseFacade.joinRoom(self.roomId) { error in
            if let error = error {
                print("erro ao entrar na sala", error)
            }
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NewTeamDatabaseFacade.leaveRoom(self.roomId) { error in
            if let error = error {
                print("erro ao entrar na sala", error)
            }
        }
        
    }
    
    // MARK: - TableView methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default")!
        let player = self.players[indexPath.item]
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.backgroundColor = player.isReady ? UIColor.green : UIColor.red
        label.text = player.name
        
        for view in cell.contentView.subviews  {
            view.removeFromSuperview()
        }
        
        cell.contentView.addSubview(label)
        
        label.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor).isActive = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(self.players.count)
    }
    
    // MARK: - Callbacks
    
    @objc func onReady () {
        guard let username = Authenticator.instance.getUserId() else { return }
        
        self.isReady = !self.isReady
        
        if self.isReady {
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
    
    // MARK: - Helpers
    
    func createTeamIfAllReady() {
        for player in self.players {
            if !player.isReady { return }
        }
        
        let vc = PickClassViewController()
        vc.roomId = self.roomId
        self.present(vc, animated: true) {
            NewTeamDatabaseFacade.completeRoom(self.roomId) {
                error in
                if let error = error{
                    print("Erro ao remover a sala!", error)
                }
                
                self.baseRef.removeAllObservers()
            }
        }
    }
    
    // MARK: - Observer methods
    
    func onAdded(_ snap: DataSnapshot) {
        
        let newPlayer = JoiningPlayer(snap.key, from: snap.value as! NSDictionary)
        
        self.players.append(newPlayer)
        
        self.tableView.reloadData()
    }
    
    func onChanged(_ snap: DataSnapshot) {
        
        let newPlayer = JoiningPlayer(snap.key, from: snap.value as! NSDictionary)
        
        for (i, player) in self.players.enumerated()  {
            if player.id == newPlayer.id {
                self.players[i] = newPlayer
                break
            }
        }

        self.createTeamIfAllReady()
        self.tableView.reloadData()
    }
    
    func onRemoved(_ snap: DataSnapshot) {
        
        self.players.removeAll { (player) -> Bool in
            player.id == snap.key
        }
        self.tableView.reloadData()
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