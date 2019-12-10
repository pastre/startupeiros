//
//  RefactoredViewController.swift
//  startupeiros
//
//  Created by Maykon Meneghel on 09/12/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit
import FirebaseDatabase

// VC THAT HANDLES TEAM CREATION
class RefactoredViewController: UIViewController, StateMachineDelegate, UITextFieldDelegate, FirebaseObserverDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let classes = ["hacker", "hustler", "hipster"]
    
    @IBOutlet var cardView: UIView!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    let newGame: UIButton = {
        let button = UIButton()
        button.setTitle("Create a startup", for: .normal)
        button.titleLabel?.font  = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
        button.titleLabel?.textColor = .white
        button.titleLabel?.textAlignment = .left
        button.backgroundColor = UIColor(red: 4/255, green: 119/255, blue: 235/255, alpha: 1.0)
        button.addTarget(self, action: #selector(onCreate), for: .touchUpInside)
        return button
    }()
    
    let joinGame: UIButton = {
        let button = UIButton()
        button.setTitle("Join a startup", for: .normal)
        button.titleLabel?.font  = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
        button.titleLabel?.textColor = .white
        button.titleLabel?.textAlignment = .left
        button.backgroundColor = UIColor(red: 235/255, green: 4/255, blue: 4/255, alpha: 1.0)
        button.addTarget(self, action: #selector(onJoin), for: .touchUpInside)
        return button
    }()
    
    
    let labelTitle: UILabel = {
        let label = UILabel()
        label.text = "Creating a startup"
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
        label.textColor = UIColor(red: 4/255, green: 119/255, blue: 235/255, alpha: 1.0)
        return label
    }()
    
    let labelInsertName: UILabel = {
        let label = UILabel()
        label.text = "Insert your name"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor =  UIColor(red: 4/255, green: 119/255, blue: 235/255, alpha: 1.0)
        return label
    }()
    
    lazy var labelInsertStartupName: UILabel = {
        let label = UILabel()
        label.text = "Insert your startup name"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor =  UIColor(red: 4/255, green: 119/255, blue: 235/255, alpha: 1.0)
        return label
    }()
    
    lazy var textName: UITextField = {
        let text = UITextField()
        text.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        text.textColor = .black
        text.placeholder = ""
        
        let lineView = UIView()
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        text.addSubview(lineView)
        
        lineView.leadingAnchor.constraint(equalTo: text.leadingAnchor).isActive = true
        lineView.bottomAnchor.constraint(equalTo: text.bottomAnchor).isActive = true
        lineView.trailingAnchor.constraint(equalTo: text.trailingAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        lineView.backgroundColor = UIColor(red: 4/255, green: 119/255, blue: 235/255, alpha: 1.0)
        
        return text
    }()

    
    let textStartupName: UITextField = {
        let text = UITextField()
        text.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        text.textColor = .black
        text.placeholder = ""
        
        
        let lineView = UIView()
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        text.addSubview(lineView)
        
        lineView.leadingAnchor.constraint(equalTo: text.leadingAnchor).isActive = true
        lineView.bottomAnchor.constraint(equalTo: text.bottomAnchor).isActive = true
        lineView.trailingAnchor.constraint(equalTo: text.trailingAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        lineView.backgroundColor = UIColor(red: 4/255, green: 119/255, blue: 235/255, alpha: 1.0)
        
        
        return text
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font  = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
        button.titleLabel?.textColor = .white
        button.backgroundColor =  UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1.0)
//        button.backgroundColor =  UIColor(red: 4/255, green: 119/255, blue: 235/255, alpha: 1.0)
        button.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    let returnButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor(red: 235/255, green: 4/255, blue: 4/255, alpha: 1.0)
        button.addTarget(self, action: #selector(onReturn), for: .touchUpInside)
        return button
    }()
    
    var collectionView: UICollectionView!
    
    var stateMachine: StateMachine?
    
    var tap: UITapGestureRecognizer!
    var firebaseObserver: FirebaseObserver?
    
    var isReady = false
    var playersInLobby: [JoiningPlayer]! = []
    var playersPickingClass: [PickingClassPlayer] = []

    var rooms: [Room]! = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCard()
        
        self.textStartupName.addTarget(self, action: #selector(self.onTextFieldChanged(_:)), for: .editingChanged)
        self.textName.addTarget(self, action: #selector(self.onTextFieldChanged(_:)), for: .editingChanged)
        // Do any additional setup after loading the view
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        self.setupStartButtons()
        self.view.layoutIfNeeded()
    }
    
    // MARK: - Setup methods
    
    func setupCollectionView() {
        
        let layout =  UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        self.cardView.removeGestureRecognizer(self.tap)
        self.collectionView  = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView.showsHorizontalScrollIndicator = false
        
        self.collectionView.register(RolesCollectionViewCell.self, forCellWithReuseIdentifier: "default")
        self.collectionView.register(LobbyCollectionViewCell.self, forCellWithReuseIdentifier: "lobby")
        self.collectionView.backgroundColor = .clear
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.cardView.addSubview(collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.topAnchor.constraint(equalTo: self.labelTitle.bottomAnchor, constant: 50).isActive  = true
        self.collectionView.leadingAnchor.constraint(equalTo: self.labelTitle.leadingAnchor).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor).isActive = true
        self.collectionView.heightAnchor.constraint(equalToConstant: 250.0).isActive = true
        
        layout.invalidateLayout()
    }
    
    func setupCard(){
        cardView.layer.cornerRadius = 15.0
        cardView.layer.applySketchShadow()
    }
    
    func setupStartButtons()  {

        self.updateCardHeight(0)
        self.clearCard() {

            self.cardView.addSubview(self.newGame)
            self.cardView.addSubview(self.joinGame)

            self.newGame.translatesAutoresizingMaskIntoConstraints = false
            self.joinGame.translatesAutoresizingMaskIntoConstraints = false

            self.newGame.heightAnchor.constraint(equalToConstant: 45).isActive = true
            self.newGame.widthAnchor.constraint(equalToConstant: 240).isActive = true

            self.newGame.topAnchor.constraint(equalTo: self.cardView.topAnchor, constant: 60.0).isActive = true
            self.newGame.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 60.0).isActive = true
            
            self.joinGame.heightAnchor.constraint(equalToConstant: 45).isActive = true
            self.joinGame.widthAnchor.constraint(equalToConstant: 280).isActive = true

            self.joinGame.topAnchor.constraint(equalTo: self.newGame.bottomAnchor, constant: 8.0).isActive = true
            self.joinGame.leadingAnchor.constraint(equalTo: self.newGame.leadingAnchor).isActive = true

        }
        


    }
    
    func setupSessionTitle(_ title: String) {
        
        // Add a title "Begin a startup" in the top of the cardView
        self.cardView.addSubview(self.labelTitle)
        self.labelTitle.text = title
        self.labelTitle.translatesAutoresizingMaskIntoConstraints = false
        self.labelTitle.topAnchor.constraint(equalTo: self.cardView.topAnchor, constant: 40).isActive = true
        self.labelTitle.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 60).isActive = true
        self.labelTitle.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: 60).isActive = true
    }
    
    
    func setupCreatingForm(labelTop: AnyObject, constant: CGFloat, label: UILabel, textField: UITextField) {
        
        // Add a text field title
        self.cardView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: labelTop.bottomAnchor, constant: constant).isActive = true
        label.leadingAnchor.constraint(equalTo: labelTop.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: labelTop.trailingAnchor).isActive = true
        
        // Add a text field title
        self.cardView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8.0).isActive = true
        textField.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        textField.widthAnchor.constraint(equalTo: self.cardView.widthAnchor, multiplier: 0.6).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
    }
    
    
    func setupNavigationButton(_ title: String, _ key: Bool? = true) {
        self.cardView.addSubview(self.nextButton)
        self.nextButton.setTitle(title, for: .normal)
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextButton.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor, constant: -10.0).isActive = true
        self.nextButton.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -30.0).isActive = true
        self.nextButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        self.nextButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
       
        if key ?? true {
            self.cardView.addSubview(self.returnButton)
            self.returnButton.setTitle("Voltar", for: .normal)
            self.returnButton.translatesAutoresizingMaskIntoConstraints = false
            self.returnButton.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor, constant: -10.0).isActive = true
            self.returnButton.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 30).isActive = true
            self.returnButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
            self.returnButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        }
    }
    
    // MARK: - Card methods
    
    func updateCardHeight(_ multiplier: CGFloat) {
        self.heightConstraint.constant = self.view.frame.height * multiplier
        self.view.layoutIfNeeded()
    }
        
    func clearCard(completion: @escaping () -> ()){
        UIView.animate(withDuration: 0.28, animations: {
            for view in self.cardView.subviews {
                view.transform = view.transform.scaledBy(x: 0,y: 0)
            }
        }) { _ in
            for view in self.cardView.subviews {
                view.transform = .identity
                view.removeFromSuperview()
            }
            completion()
        }
    }
    
    // MARK: - State functions
    
    func createStateMachine(with states: [ConfiguringState]) {
        let newStateMachine = StateMachine(state: states)
        
        newStateMachine.delegate = self
        
        self.stateMachine = newStateMachine
        self.stateMachine?.setup()
    }
    
    func getPlayerName() -> String? {
        return self.textName.text
    }
    
    func getRoomName() -> String? {
        return self.textStartupName.text
    }
    
    
    
    func createTeamIfAllReady() {
        if self.playersInLobby.count != 3 { return }
        for player in self.playersInLobby {
            if !player.isReady { return }
        }

        self.stateMachine?.passState()
    }
    // MARK: - State Machine Delegate
    func onStateChanged(to newState: ConfiguringState) {

        print("State changed to", newState)
        self.clearCard() {
            switch newState {
            case .creating:
                self.onCreateState()
            case .inLobby:
                self.inLobbyState()
            case .naming:
                self.onNamingState()
            case .joining:
                self.joiningState()
            case .pickingClass:
                self.pickingClassState()
            default:
                break
            }
        }
    }
    
    func passState() {
        guard let state = self.stateMachine?.getCurrentState() else { return }
        
        switch state {
        case .creating:
            self.stateMachine?.passState()
        case .naming:
            self.stateMachine?.passState()
        default:
            break
        }
    }
    
    func validateCreating(){
        self.nextButton.isEnabled =  self.textName.text != "" && self.textStartupName.text != ""
        
        if self.nextButton.isEnabled{
            self.nextButton.backgroundColor =  UIColor(red: 4/255, green: 119/255, blue: 235/255, alpha: 1.0)
        }else {
            self.nextButton.backgroundColor =  UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1.0)
        }
        print("NEXT BUTTON IS", self.nextButton.isEnabled)
    }
    
    
    func validateNaming(){
        self.nextButton.isEnabled =  self.textName.text != ""
        
        if self.nextButton.isEnabled{
            self.nextButton.backgroundColor =  UIColor(red: 4/255, green: 119/255, blue: 235/255, alpha: 1.0)
        }else {
            self.nextButton.backgroundColor =  UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1.0)
        }
        print("NEXT BUTTON IS", self.nextButton.isEnabled)
    }
    
    func onNamingState() {
        self.updateCardHeight(0.28)
        self.setupKeyboardDismissGesture()
        self.setupSessionTitle("Whats your name?")
        self.setupCreatingForm(labelTop: self.labelTitle, constant: 80.0, label: self.labelInsertName, textField: self.textName)
        self.setupNavigationButton("Next")
    }
    
    func onCreateState()  {
        
        self.updateCardHeight(0.28)
        self.setupKeyboardDismissGesture()
        
        // Set title label
        self.setupSessionTitle("Creating a startup")
        
        // show field name
        self.setupCreatingForm(labelTop: self.labelTitle, constant: 80.0, label: self.labelInsertName, textField: self.textName)

        self.setupCreatingForm(labelTop: self.textName, constant: 30.0, label: self.labelInsertStartupName, textField: self.textStartupName)
        
        // show the next button
        self.setupNavigationButton("Next")
    }
    
    var  currentRoom: Room?
    func inLobbyState()  {
        
        guard let currentState = self.stateMachine?.getCurrentState() else { return }
        self.updateCardHeight(0.28)
        self.clearCard() {
            
            if let roomId = NewTeamDatabaseFacade.newRoomId {
                self.firebaseObserver = FirebaseObserver(delegate: self, reference: Database.database().reference().root.child(FirebaseKeys.newRooms.rawValue).child(roomId).child(FirebaseKeys.playersInRoom.rawValue))

            } else if let roomId = self.currentRoom?.id {
                self.firebaseObserver = FirebaseObserver(delegate: self, reference: Database.database().reference().root.child(FirebaseKeys.newRooms.rawValue).child(roomId).child(FirebaseKeys.playersInRoom.rawValue))
            }
            self.firebaseObserver?.setup()
            
            self.setupSessionTitle("Waiting...")
            self.setupCollectionView()
            self.collectionView.reloadData()
            self.setupNavigationButton("Ready")
            self.returnButton.isHidden = true
            self.nextButton.isHidden = false
            
        }

    }
    
    func joiningState(){
        self.updateCardHeight(0.28)
        self.clearCard() {
            self.firebaseObserver = FirebaseObserver(delegate: self, reference: Database.database().reference().root.child(FirebaseKeys.newRooms.rawValue))
            self.firebaseObserver?.setup()
            self.setupSessionTitle("Join a startup")
            self.setupCollectionView()
            
            self.collectionView.reloadData()
            self.setupNavigationButton("Ready")
            self.returnButton.isHidden = true
            self.nextButton.isHidden = true
            
            print("Configured joining state")
        }
    }
    
    func pickingClassState() {
        guard let roomId = NewTeamDatabaseFacade.newRoomId else { return }
        self.updateCardHeight(0.28)
        self.clearCard() {
            self.isReady = false
            self.firebaseObserver?.invalidate()
            self.firebaseObserver = FirebaseObserver(delegate: self, reference: Database.database().reference().root.child(FirebaseKeys.pickingClass.rawValue).child(roomId).child("players"))
            self.firebaseObserver?.setup()
            
            self.cardView.removeGestureRecognizer(self.tap)
            self.cardView.addSubview(self.labelTitle)
            self.setupSessionTitle("Choose your role")
            self.setupCollectionView()
            self.collectionView.reloadData()
            self.setupNavigationButton("Ready")
            self.returnButton.isHidden = true
            self.nextButton.isHidden = false
        }

    }
    
    func updateReadyState() {
        if self.isReady {
            self.nextButton.setTitle("Cancel", for: .normal)
        } else {
            self.nextButton.setTitle("Ready", for: .normal)
        }
    }
    
    
    //MARK: - Callback methods
    
    @objc func onCreate() {
        print("Creating")
        UIView.animate(withDuration: 0.5, animations: {
            self.updateCardHeight(0.28)
        }) { _  in
            self.createStateMachine(with: [.creating, .inLobby, .pickingClass])
        }
    }
    
    @objc func onJoin() {
        UIView.animate(withDuration: 0.5, animations: {
            self.updateCardHeight(0.28)
        }) { _  in
            self.createStateMachine(with: [.naming, .joining, .inLobby, .pickingClass])
        }
    }
    
    
    @objc func handleTap(){
        UIView.animate(withDuration: 0.5) {
            self.updateCardHeight(0.28)
            self.view.endEditing(true)
        }
    }
    
    @objc func onReturn()  {
        UIView.animate(withDuration: 0.5) {
        self.updateCardHeight(0)
            self.stateMachine = nil
            self.setupStartButtons()
        }
    }
    
    @objc func onNext() {
        if self.stateMachine?.getCurrentState() == .inLobby {
            guard let username = Authenticator.instance.getUserId() else { return }
            guard let roomId = NewTeamDatabaseFacade.newRoomId else { return }
                self.isReady = !self.isReady
            
                self.updateReadyState()
            Database.database().reference().root.child(FirebaseKeys.newRooms.rawValue).child(roomId).child(FirebaseKeys.playersInRoom.rawValue).child(username).child("isReady").setValue(self.isReady) {
                (error, ref ) in
                if let error = error {
                    print("Erro pra atualizar a ready!", error)
                    return
                }
                
                self.createTeamIfAllReady()
            }
            return
        }
        
        if self.stateMachine?.getCurrentState() == .pickingClass {
            
            guard let roomId = NewTeamDatabaseFacade.newRoomId else { return }
            guard let username = Authenticator.instance.getUserId() else { return }
            
            self.isReady = !self.isReady
            
            if self.isReady {
                self.nextButton.setTitle("Cancel", for: .normal)
            } else {
                self.nextButton.setTitle("Ready", for: .normal)
            }
            
            
            Database.database().reference().root.child(FirebaseKeys.pickingClass.rawValue).child(roomId).child("players")
                .child(username).child("isReady").setValue(self.isReady) {
                (error, ref ) in
                if let error = error {
                    print("Erro pra atualizar a ready!", error)
                    return
                }
                    
                self.xega()
                
            }
            return
        }
        self.passState()
    }
    
    func xega() {
        
        if self.playersPickingClass.count != 3 { return }
        guard let currentClass = self.currentSelectedClass else { return }
        guard let roomId = NewTeamDatabaseFacade.newRoomId else { return }
        for player in self.playersPickingClass {
            if !player.isReady { return }
        }
        NewTeamDatabaseFacade.joinTeam(roomId, classed: currentClass) { (erro) in
            if let error = erro {
                print("Erro ao entrar para o time", error)
            }
            
            for window in UIApplication.shared.windows {
                if let vc = window.rootViewController as? DecideStartViewController {
                    vc.currentChild?.dismiss(animated: true, completion: {
                        vc.presentGameView()
                    })
                }
            }
        }
    }
    
    
    @objc func onTextFieldChanged(_ view: UITextView) {
        guard let state = self.stateMachine?.getCurrentState() else { return }
        switch state {
        case .creating:
            self.validateCreating()
        case .naming:
            self.validateNaming()
        default:
            break
        }
    }

    
    @objc func keyboardWillShow(_ notification: Notification) {
       
        self.updateCardHeight(0.5)

    }
    
    // MARK: - Gesture methods
    
    func setupKeyboardDismissGesture() {
        self.tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.delegate = self as? UIGestureRecognizerDelegate
        self.cardView.addGestureRecognizer(tap)
    }
    
    func removeKeyboardDismissGesture() {
        //TODO
//        self.tap.
    }
    
    // MARK: - FirebaseObserverDelegate
    
    
    func onAdded(_ snap: DataSnapshot) {
        
        print("ONADDED")
        guard let state = self.stateMachine?.getCurrentState() else { return }
        if state == .inLobby {
            let newPlayer = JoiningPlayer(snap.key, from: snap.value as! NSDictionary)

            self.playersInLobby.append(newPlayer)
            
        } else if state  == .pickingClass {
            let newPlayer = PickingClassPlayer(snap.key, from: snap.value as! NSDictionary)
            
            self.playersPickingClass.append(newPlayer)
            self.updateSelectedClasses()
        } else {
            let room = Room(snap.key, from: snap.value as! NSDictionary)
            self.rooms.append(room)
        }
        
            
        self.collectionView.reloadData()
    }
    
    func onChanged(_ snap: DataSnapshot) {
        
        guard let state = self.stateMachine?.getCurrentState() else { return }
    
        if state == .pickingClass {
            let newPlayer = PickingClassPlayer(snap.key, from: snap.value as! NSDictionary)
            
            for (i, player) in self.playersPickingClass.enumerated()  {
                if player.id == newPlayer.id {
                    self.playersPickingClass[i] = newPlayer
                    break
                }
            }
            
            self.updateSelectedClasses()
            
            self.xega()
            return
        }
        
        print("ONCHANGED")
        var dict: NSDictionary!
        let rawDict =  snap.value as! [String: Any]
        
        if rawDict.keys.contains(where: { (val) -> Bool in
            return val == "players"
        }) {
            dict = rawDict["players"] as! NSDictionary
        } else{
            dict = rawDict as! NSDictionary
        }
        
        
        let newPlayer = JoiningPlayer(snap.key, from: dict)
        
        for (i, player) in self.playersInLobby.enumerated()  {
            if player.id == newPlayer.id {
                self.playersInLobby[i] = newPlayer
                break
            }
        }
        

        self.createTeamIfAllReady()
        self.collectionView.reloadData()
    }
    
    func onRemoved(_ snap: DataSnapshot) {
        
        guard let state = self.stateMachine?.getCurrentState() else { return }
        
        if state == .pickingClass {
            self.playersPickingClass.removeAll { (player) -> Bool in
                return player.id == snap.key
            }
            self.updateSelectedClasses()
            return
        }
        self.playersInLobby.removeAll { (player) -> Bool in
            player.id == snap.key
        }
        self.collectionView.reloadData()
    }
    
    var currentSelectedClass: String?
    
    func updateSelectedClasses() {
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
        
        for i in 0..<self.collectionView.numberOfItems(inSection: 0) {
            print("Clearing cell at", i)
            let indexPath = IndexPath(item: i, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? RolesCollectionViewCell{
            
                cell.cardView.alpha = 0.5
                
                print("Cleared cell at", i)
            }
        }
        
        for (i, player) in self.playersPickingClass.enumerated() {
            if player.currentClass == "none"  { continue }
            let playerClass = self.classes.firstIndex(of: player.currentClass)!
            let indexPath = IndexPath(item: playerClass, section: 0)
            let cell = collectionView.cellForItem(at: indexPath) as! RolesCollectionViewCell
            
            cell.cardView.alpha = 1
        }
    }

    // MARK: - CollectionView methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let currentState = self.stateMachine?.getCurrentState() else  { return 0 }
        
        if currentState == .inLobby {
            return 1
        }
        if currentState == .joining {
            return self.rooms.count
        }
        if currentState == .pickingClass {
            return 3
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let currentState = self.stateMachine?.getCurrentState() else  { return UICollectionViewCell() }
        guard let playerName = self.getPlayerName()   else { return UICollectionViewCell()}
        guard let startupName =  self.getRoomName() else { return UICollectionViewCell()}

        let colors = [
            UIColor(red: 88/255, green: 86/255, blue: 91/255, alpha: 1.0),
            UIColor(red: 71/255, green: 83/255, blue: 191/255, alpha: 1.0),
            UIColor(red: 190/255, green: 86/255, blue: 215/255, alpha: 1.0)
        ]
        
        if currentState == .pickingClass {
            
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath)  as! RolesCollectionViewCell
            let  currentRole = self.classes[indexPath.item]

            
            cell.imageView.image = UIImage(named: currentRole)
            cell.labelView.text = currentRole
            cell.labelView.backgroundColor = colors[indexPath.item]
            
            cell.setup()
            
            return cell
        }
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "lobby", for: indexPath)  as! LobbyCollectionViewCell
        
        
        cell.setup(self.playersInLobby)
        
        cell.ownerNameLabel.text = playerName
        cell.startupNameLabel.text = startupName
        
        if currentState != .joining {
            cell.joinButton.isHidden = true
        }
        
        if self.rooms.count > 0 {

            cell.startupNameLabel.text = rooms[indexPath.item].name
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let currentState = self.stateMachine?.getCurrentState() else  { return  }
        if currentState  == .joining {
            let currentRoom = self.rooms[indexPath.item]
            
            self.firebaseObserver?.invalidate()
            NewTeamDatabaseFacade.joinRoom(currentRoom.id) { (error) in
                if let error = error {
                    print("Error joining room", error)
                    return
                }
                self.currentRoom = currentRoom
                self.stateMachine?.passState()
            }
        } else if currentState == .pickingClass{
            
            guard let roomId = NewTeamDatabaseFacade.newRoomId else { return }
            let currentRole = self.classes[indexPath.item]
            
            for player in self.playersPickingClass {
                
                if player.currentClass == currentRole {
                    NewTeamDatabaseFacade.pickClass(roomId, class: "none")
                    self.currentSelectedClass = "none"
                    print("Configured to none")
                    return
                }
            }
            
            if let current = self.currentSelectedClass {
                if current == currentRole {
                    NewTeamDatabaseFacade.pickClass(roomId, class: "none")
                    self.currentSelectedClass = "none"
                    return
                }
            }
            
            
            
            self.currentSelectedClass = currentRole
            NewTeamDatabaseFacade.pickClass(roomId, class: currentRole)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let size = collectionView.frame.size
        
        guard let state = self.stateMachine?.getCurrentState() else { fatalError()}
        if state == .pickingClass {
            return CGSize(width: size.width * 0.4,  height: size.height)
        }
        return CGSize(width: size.width * 0.4,  height: size.height * 0.8)

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
