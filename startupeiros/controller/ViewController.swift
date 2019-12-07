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
    @IBOutlet weak var hackerJobProgressSpace: UIView!
    @IBOutlet weak var hipsterJobProgressSpace: UIView!
    @IBOutlet weak var hustlerJobProgressSpace: UIView!
    
    var job: Job?
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
    
    let hackerProgressCircle: HackerProgressCircle = {
        let bar = HackerProgressCircle()
        
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.backgroundColor = .lightGray
        return bar
    }()
    
    let hipsterProgressCircle: HipsterProgressCircle = {
        let bar = HipsterProgressCircle()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.backgroundColor = .lightGray
        
        return bar
    }()
    
    
    
    let hustlerProgressCircle: HustlerProgressCircle = {
        let bar = HustlerProgressCircle()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.backgroundColor = .lightGray
        
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
        
        self.setupHackerProgressCircle()
        self.setupHipsterProgressCircle()
        self.setupHustlerProgressCircle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        self.job = GameDatabaseFacade.instance.getCurrentJob()
        
        self.updateCurrentSelectedSkill()
    }
    
    func setupProgressCircle(_ circle: CircularProgressBar) {
        
        circle.layer.cornerRadius = circle.layer.frame.width / 2
        circle.setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupProgressCircle(self.hackerProgressCircle)
        self.setupProgressCircle(self.hipsterProgressCircle)
        self.setupProgressCircle(self.hustlerProgressCircle)
    }
    
    // MARK: - Setup methods
    
    func setupHustlerProgressCircle() {
        self.spaceFiller(self.hustlerJobProgressSpace, self.hustlerProgressCircle)
        self.hustlerProgressCircle.layoutIfNeeded()
    }
    
    func setupHipsterProgressCircle() {
        self.spaceFiller(self.hipsterJobProgressSpace, self.hipsterProgressCircle)
        self.hipsterProgressCircle.layoutIfNeeded()
    }
    func setupHackerProgressCircle() {
        self.spaceFiller(self.hackerJobProgressSpace, self.hackerProgressCircle)
        self.hackerProgressCircle.layoutIfNeeded()
    }
    
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
        if let skill = self.getCurrentSkill() {
            return skill.tasks.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskRow") as! TaskTableViewCell
        guard let skill = self.getCurrentSkill() else { return cell }
        let task = skill.tasks[indexPath.item]
        
        cell.taskLabel.text = task.getName()
        cell.taskIcon.image = UIImage(named: "failedToLoadTexture")
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let skill = self.getCurrentSkill() else { return }
        let task = skill.tasks[indexPath.item]
        
        if task.canRun() {
            let cell = tableView.cellForRow(at: indexPath) as! TaskTableViewCell
            task.profiter = self.getCurrentSkill()
            task.runTask {
                cell.runProgressBar(with: task)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height * 0.3
    }
    
    // MARK: -  Collection view methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let skills = self.getSkills() {
            return skills.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "skillCell", for: indexPath) as! SkillCollectionViewCell
        guard let skills = self.getSkills() else { return cell}
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
        guard let skill = self.getCurrentSkill() else { return }
        self.skillNameLabel.text = skill.getName()
        
        self.skillsCollectionView.reloadData()
        self.updateSkillLevelBar()
        self.updateSkillLevelLabel()
        
        self.tasksTableView.reloadData()
        self.hackerProgressCircle.layoutIfNeeded()
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
    
    @IBAction func onMeetup(_ sender: Any) {
        self.performSegue(withIdentifier: "meetup", sender: nil)
    }
    
    @objc func onCoffeeCompleted() {
    }
    
    func getCurrentSkill() -> Skill? {
        guard let skills = self.getSkills() else { return nil }
        return skills[self.currentSelected]
    }
    
    func getSkills() -> [Skill]? {
        return self.job?.skills
    }
    
    // MARK: - Navigation
    
    func setCurrentJob(to job: Job) {
        self.job = job
    
        updateCurrentSelectedSkill()
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? MeetupViewController {
            dest.delegate = self
        }
    }
}

