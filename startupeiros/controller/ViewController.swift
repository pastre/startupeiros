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
    @IBOutlet weak var skillLevelBarSpace: UIView!
    @IBOutlet weak var skillLevelLabel: SkillLevelLabel!
    @IBOutlet weak var energyView: UIView!
    @IBOutlet weak var coffeeView: UIView!
   
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

    let skillLevelProgressBar: SkillLevelBar = {
        let bar = SkillLevelBar()
        
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
        self.setupSkillLevelBar()
        
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
    
    func setupSkillLevelBar() {
        self.spaceFiller(self.skillLevelBarSpace, self.skillLevelProgressBar)
    }
    
    func setupWorkBar() {
        spaceFiller(workBarSpace, workProgressBar)
    }

    func setupEnergyBar() {
        self.spaceFiller(energyBarSpace, energyProgressBar)
    }
    
    func setupCoffeeProgressBar() {
        self.spaceFiller(coffeeProgressBarSpace, coffeeProgressBar)
    }
    
    fileprivate func spaceFiller(_ space: UIView, _ view: UIView) {
        space.addSubview(view)
        
        view.topAnchor.constraint(equalTo: space.topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: space.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: space.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: space.bottomAnchor).isActive = true
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
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = self.getCurrentSkill().tasks[indexPath.item]
        
        if task.canRun() {
            let cell = tableView.cellForRow(at: indexPath) as! TaskTableViewCell
            task.profiter = self.getCurrentSkill()
            task.runTask {
                cell.runProgressBar(with: task)
            }
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
            cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        } else {
            cell.backgroundColor = .clear
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
        self.updateSkillLevelBar()
        self.updateSkillLevelLabel()
    }
    
    func updateSkillLevelLabel() {
        self.skillLevelLabel.invalidate()
        
        self.skillLevelLabel.skill = self.getCurrentSkill()
        self.skillLevelLabel.setup()
        self.skillLevelLabel.update()
    }
    
    func updateSkillLevelBar() {
        self.skillLevelProgressBar.invalidate()
        
        self.skillLevelProgressBar.skill = self.getCurrentSkill()
        self.skillLevelProgressBar.setup()
        self.skillLevelProgressBar.update()
    }
    
    // MARK: - Button callbacks
    
    @IBAction func onCoffee(_ sender: Any) {
        ResourceFacade.instance.coffeeManager.runTask {
            self.coffeeProgressBar.startProgress()
        }
    }
    
    @IBAction func onWork(_ sender: Any) {
        ResourceFacade.instance.workManager.runTask {
             self.workProgressBar.startProgress()
        }
    }
    
    
    func getCurrentSkill() -> Skill {
        return self.skills[self.currentSelected]
    }
}

