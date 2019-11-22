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

    var roomId: String!
    var players: [JoiningPlayer] = []
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupObservers()
        
        
        // Do any additional setup after loading the view.
    }
    
    func setupObservers(){
        

        let baseRef = Database.database().reference().root.child(FirebaseKeys.newRooms.rawValue).child(roomId).child(FirebaseKeys.playersInRoom.rawValue)
        
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
        label.textColor = .green
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
    
    // MARK: - Observer methods
    
    func onAdded(_ snap: DataSnapshot) {
        print("Snaps is", snap)
        let newPlayer = JoiningPlayer(snap.key, from: snap.value as! NSDictionary)
        
        self.players.append(newPlayer)
        
        self.tableView.reloadData()
    }
    
    func onChanged(_ snap: DataSnapshot) {
        print("Changed!", snap)
    }
    
    func onRemoved(_ snap: DataSnapshot) {
        print(snap)
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
