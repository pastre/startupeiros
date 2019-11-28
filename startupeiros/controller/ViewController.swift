//
//  ViewController.swift
//  startupeiros
//
//  Created by Bruno Pastre on 20/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var workBarSpace: UIView!
    @IBOutlet weak var energyBarSpace: UIView!
    @IBOutlet weak var coffeeProgressBarSpace: UIView!
    @IBOutlet weak var skillNameLabel: UILabel!
    @IBOutlet weak var skillsCollectionView: UICollectionView!
    @IBOutlet weak var tasksTableView: UITableView!
    
    var skills: [Skill]!
    var currentSelected = 0
    
    let coffeeProgressBar: CoffeeBar = {
        let bar = CoffeeBar()
        
        bar.translatesAutoresizingMaskIntoConstraints = false
        
        return bar
    }()
    
    let energyProgressBar: EnergyBar =  {
        let bar = EnergyBar()
        
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.setup()
        
        return bar
    }()
    
    let workProgressBar: WorkBar = {
        let bar = WorkBar()
        
        bar.translatesAutoresizingMaskIntoConstraints = false
        
        return bar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCoffeeProgressBar()
        self.setupEnergyBar()
        self.setupWorkBar()
        
        self.setupSkillsCollectionView()
        self.setupTasksTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateCurrentSelectedSkill()
    }
    
    // MARK: - Setup methods
    
    func setupTasksTableView(){
        self.tasksTableView.delegate = self
        self.tasksTableView.dataSource = self
    }
    
    func setupSkillsCollectionView()  {
        self.skillsCollectionView.delegate = self
        self.skillsCollectionView.dataSource = self
    }
    
    func setupWorkBar() {
        
        self.workBarSpace.addSubview(self.workProgressBar)
        
        self.workProgressBar.topAnchor.constraint(equalTo: self.workBarSpace.topAnchor).isActive = true
         self.workProgressBar.leadingAnchor.constraint(equalTo: self.workBarSpace.leadingAnchor).isActive = true
         self.workProgressBar.trailingAnchor.constraint(equalTo: self.workBarSpace.trailingAnchor).isActive = true
         self.workProgressBar.bottomAnchor.constraint(equalTo: self.workBarSpace.bottomAnchor).isActive = true
    }

    func setupEnergyBar() {
        self.energyBarSpace.addSubview(self.energyProgressBar)
        
        self.energyProgressBar.topAnchor.constraint(equalTo: self.energyBarSpace.topAnchor).isActive = true
        self.energyProgressBar.leadingAnchor.constraint(equalTo: self.energyBarSpace.leadingAnchor).isActive = true
        self.energyProgressBar.bottomAnchor.constraint(equalTo: self.energyBarSpace.bottomAnchor).isActive = true
        self.energyProgressBar.trailingAnchor.constraint(equalTo: self.energyBarSpace.trailingAnchor).isActive = true
    }
    
    func setupCoffeeProgressBar() {
        self.coffeeProgressBarSpace.addSubview(self.coffeeProgressBar)
        
        self.coffeeProgressBar.topAnchor.constraint(equalTo: self.coffeeProgressBarSpace .topAnchor).isActive = true
         self.coffeeProgressBar.leadingAnchor.constraint(equalTo: self.coffeeProgressBarSpace.leadingAnchor).isActive = true
         self.coffeeProgressBar.trailingAnchor.constraint(equalTo: self.coffeeProgressBarSpace   .trailingAnchor).isActive = true
         self.coffeeProgressBar.bottomAnchor.constraint(equalTo: self.coffeeProgressBarSpace .bottomAnchor).isActive = true
    }
    
    // MARK: - Table view methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getCurrentSkill().tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskRow") as! TaskTableViewCell
        let task = self.getCurrentSkill().tasks[indexPath.item]
        
        cell.taskLabel.text = task.getName()
        cell.taskIcon.image = UIImage(named: "failedToLoadTexture")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = self.getCurrentSkill().tasks[indexPath.item]
        if task.canRun() {
            task.runTask()
        }
    }
    
    // MARK: -  Collection view methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.skills.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "skillCell", for: indexPath) as! SkillCollectionViewCell
        let skill = skills[indexPath.item]
        
        cell.skillNameLabel.text = skill.getName()
        cell.skillIcon.image = UIImage(named: "failedToLoadTexture")
        
        if indexPath.item == self.currentSelected {
            cell.backgroundColor = .lightGray
        } else {
            cell.backgroundColor = .white
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width * 0.25
        let heitgh = collectionView.frame.height * 0.9
        
        return CGSize(width: width, height: heitgh)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.currentSelected = indexPath.item
        self.updateCurrentSelectedSkill()
    }
    
    func updateCurrentSelectedSkill() {
        self.skillNameLabel.text = self.getCurrentSkill().getName()
        
        self.skillsCollectionView.reloadData()
        self.tasksTableView.reloadData()
    }
    
    // MARK: - Button callbacks
    
    @IBAction func onCoffee(_ sender: Any) {
        self.coffeeProgressBar.startProgress()
        ResourceFacade.instance.coffeeManager.runTask()
    }
    
    @IBAction func onWork(_ sender: Any) {
        self.workProgressBar.startProgress()
        ResourceFacade.instance.workManager.runTask()
    }
    
    
    func getCurrentSkill() -> Skill {
        return self.skills[self.currentSelected]
    }
}

