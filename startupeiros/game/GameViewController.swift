//
//  GameViewController.swift
//  startupeiros
//
//  Created by Bruno Pastre on 26/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var skill: Skill!
    
    var work: Work?
    var coffee: Coffee?
    
    let tableView: UITableView! = {
       let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    let coffeeButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("☕️", for: .normal)
        button.backgroundColor = .brown
        
        return button
    }()
    
    let workButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("👨‍💻", for: .normal)
        button.backgroundColor = .blue
        
        return button
    }()
    
    let coffeeProgressBar: CoffeeBar = {
        let bar = CoffeeBar()
        
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.backgroundColor = .green
        
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.skill = Skill(name: "skill", iconName: "debugSkillIcon")
        
        self.setupWorkButton()
        self.setupCoffeeButton()
        
        self.setupTableView()
        
        self.setupCofeeBar()
    }
    let workManager = ResourceFacade.instance.workManager
    @objc func onWork() {
        
        workManager.runTask()
    }
    
    @objc func onCoffee() {
    }

    
    // MARK: - Setup methods
    
    func setupCofeeBar() {
        self.view.addSubview(self.coffeeProgressBar)
        
        self.coffeeProgressBar.bottomAnchor.constraint(equalTo: self.tableView.topAnchor).isActive = true
        self.coffeeProgressBar.leadingAnchor.constraint(equalTo: self.tableView.leadingAnchor).isActive = true
        self.coffeeProgressBar.trailingAnchor.constraint(equalTo: self.tableView.trailingAnchor).isActive = true
        self.coffeeProgressBar.heightAnchor.constraint(equalTo: self.tableView.heightAnchor, multiplier: 0.1).isActive = true
        
        
    }
    
    func setupTableView() {
        
        self.view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        self.tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.tableView.bottomAnchor.constraint(equalTo: self.workButton.topAnchor).isActive = true
        
        self.tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        self.tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5).isActive = true
    }
    
    func setupWorkButton() {
        
        self.workButton.addTarget(self, action: #selector(self.onWork), for: .touchDown)
        
        self.view.addSubview(self.workButton)
        
        self.workButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.workButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.workButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        self.workButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3).isActive = true
    }
    
    func setupCoffeeButton() {
        
        self.coffeeButton.addTarget(self, action: #selector(self.onCoffee), for: .touchDown)
        
        self.view.addSubview(self.coffeeButton)
        
        self.coffeeButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.coffeeButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.coffeeButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        self.coffeeButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3).isActive = true
    }
    
    
    // MARK: - TableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.skill.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell")!
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
