//
//  ViewController.swift
//  startupeiros
//
//  Created by Bruno Pastre on 20/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseStorage

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var workBarSpace: UIView!
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
    @IBOutlet weak var jobNameLabel: UILabel!
    @IBOutlet weak var energyLabel: UILabel!
    
    @IBOutlet weak var handsImageView: UIImageView!
    
    @IBOutlet weak var toolImageView: UIImageView!
    
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
        
        self.setupBackgroundGradient()
        
        self.setupCoffeeProgressBar()
        self.setupEnergyBar()
        self.setupWorkBar()
        
        self.setupSkillsCollectionView()
        self.setupTasksTableView()
        self.setupSkillLevelBar()
        
        self.setupHackerProgressCircle()
        self.setupHipsterProgressCircle()
        self.setupHustlerProgressCircle()
        
        self.setupClassTheme()
        
        self.setupMinigameDice()

        self.becomeFirstResponder() // To get shake gesture
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        self.job = GameDatabaseFacade.instance.getCurrentJob()
        
        self.updateCurrentSelectedSkill()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupProgressCircle(self.hackerProgressCircle)
        self.setupProgressCircle(self.hipsterProgressCircle)
        self.setupProgressCircle(self.hustlerProgressCircle)
    }
    
    // MARK: - Setup methods
    
    func setupClassTheme() {
        guard let pClass = PlayerFacade.getPlayerClass() else { return }
      
        switch pClass {
        case .hipster:
            self.setupHipsterTheme()
        case .hustler:
            self.setupHustlerTheme()
        case .hacker:
            self.setupHackerTheme()
        }
    }
    
    func setupHipsterTheme() {
        self.handsImageView.image = UIImage(named: "maos_hipster")
        self.toolImageView.image = UIImage(named: "tablet")
    }
    
    func setupHackerTheme() {
        print("Configuring hacker!!")
        self.handsImageView.image = UIImage(named: "maos_hacker")
        self.toolImageView.image = UIImage(named: "pc")
    }
    
    func setupHustlerTheme() {
        self.handsImageView.image = UIImage(named: "maos_hustler")
        self.toolImageView.image = UIImage(named: "notebook")
    }
    
    func setupProgressCircle(_ circle: CircularProgressBar) {
        
        circle.layer.cornerRadius = circle.layer.frame.width / 2
        circle.setup()
    }
    
    func setupBackgroundGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()

        gradient.colors = [UIColor.white.cgColor, CGColor(srgbRed: 230/255, green: 249/255, blue: 224/255, alpha: 1)]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)

        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
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
//        self.spaceFiller(energyBarSpace, energyProgressBar)
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
    
    // MARK: - Minigame methods
    
    var isMinigameEnabled: Bool! = false
    
    func setupMinigameDice() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            let random = Int.random(in: 0..<99)
            
            if random == 1 || true {
                self.onMinigameAvaiable()
                timer.invalidate()
            }
        }
    }
    
    func onMinigameAvaiable() {
        self.isMinigameEnabled = true
        self.blinkTool()
    }
    
    func blinkTool() {
        guard let toolPlaying = self.getMinigameTool() else { return }
        guard let defaultTool = self.getDefaultTool() else { return }
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (timer) in
            self.toolImageView.image = defaultTool
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (_) in
                self.toolImageView.image = toolPlaying
            }
        }
    }
    

    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }

    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.startMinigame()
        }
    }
    
    func startMinigame() {
        if !self.isMinigameEnabled { return }
        guard let vc = self.getMinigameVc() else { return }
        
        vc.modalPresentationStyle = .overFullScreen
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func getDefaultTool() -> UIImage? {
          guard let pClass = PlayerFacade.getPlayerClass() else { return nil }
        
          switch pClass {
          case .hipster:
            return UIImage(named: "tablet")
          case .hustler:
            return UIImage(named: "notebook")
          case .hacker:
            return UIImage(named: "pc")
          }
    }
    
    func getMinigameTool() -> UIImage? {
          guard let pClass = PlayerFacade.getPlayerClass() else { return nil }
        
          switch pClass {
          case .hipster:
            return UIImage(named: "play_tablet")
          case .hustler:
            return UIImage(named: "play_note")
          case .hacker:
            return UIImage(named: "play_pc")
          }
    }
    
    
    func getMinigameVc() -> MiniGameViewController? {
          guard let pClass = PlayerFacade.getPlayerClass() else { return nil }
        
          switch pClass {
          case .hipster:
            return UIStoryboard(name: "DoodleGame", bundle: nil).instantiateInitialViewController() as? DrawingViewController
          case .hustler:
            return FlappyGameViewController()
          case .hacker:
            return HackerViewController()
          }
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
        cell.setup()
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
        guard let ref: StorageReference = Storage.storage().reference(withPath: "skill-icons/hacker/\(skill.getIconName())") else { return UICollectionViewCell() }
    
        cell.skillIcon.sd_setImage(with: ref, placeholderImage: UIImage(named: "failedToLoadTexture"))
            
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
    
    // MARK: - Model helper methos
    
    func updateCurrentSelectedSkill() {
        self.updateJobName()

        guard let skill = self.getCurrentSkill() else { return }
        self.skillNameLabel.text = skill.getName()
               
        self.skillsCollectionView.reloadData()
        self.updateSkillLevelBar()
        self.updateSkillLevelLabel()
        
        self.tasksTableView.reloadData()
        self.hackerProgressCircle.layoutIfNeeded()
    }
    
    
    func updateJobName() {
        if let job = self.job {
            self.jobNameLabel.text = job.getName()
        } else {
            self.jobNameLabel.text = "Click the phone to pick a job"
        }
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

