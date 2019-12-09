//
//  RefactoredViewController.swift
//  startupeiros
//
//  Created by Maykon Meneghel on 09/12/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RefactoredViewController: UIViewController, StateMachineDelegate, UITextFieldDelegate, FirebaseObserverDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var cardView: UIView!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    let newGame: UIButton = {
        let button = UIButton()
        button.setTitle("Criar uma startup", for: .normal)
        button.titleLabel?.font  = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
        button.titleLabel?.textColor = .white
        button.titleLabel?.textAlignment = .left
        button.backgroundColor = UIColor(red: 4/255, green: 119/255, blue: 235/255, alpha: 1.0)
        button.addTarget(self, action: #selector(onCreate), for: .touchUpInside)
        return button
    }()
    
    let joinGame: UIButton = {
        let button = UIButton()
        button.setTitle("Entrar em uma startup", for: .normal)
        button.titleLabel?.font  = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
        button.titleLabel?.textColor = .white
        button.titleLabel?.textAlignment = .left
        button.backgroundColor = UIColor(red: 235/255, green: 4/255, blue: 4/255, alpha: 1.0)
        button.addTarget(self, action: #selector(onJoin), for: .touchUpInside)
        return button
    }()
    
    
    let labelTitle: UILabel = {
        let label = UILabel()
        label.text = "Criando uma startup"
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
        label.textColor = UIColor(red: 4/255, green: 119/255, blue: 235/255, alpha: 1.0)
        return label
    }()
    
    let labelInsertName: UILabel = {
        let label = UILabel()
        label.text = "Insira o seu nome"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor =  UIColor(red: 4/255, green: 119/255, blue: 235/255, alpha: 1.0)
        return label
    }()
    
    lazy var labelInsertStartupName: UILabel = {
        let label = UILabel()
        label.text = "Insira o nome da sua startup"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor =  UIColor(red: 4/255, green: 119/255, blue: 235/255, alpha: 1.0)
        return label
    }()
    
    lazy var textName: UITextField = {
        let text = UITextField()
        text.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        text.textColor = .black
        text.placeholder = ""
        text.text = "Debug name"
        text.borderStyle = .line
        return text
    }()

    
    let textStartupName: UITextField = {
        let text = UITextField()
        text.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        text.textColor = .black
        text.placeholder = ""
        text.text = "Debug startup"
        text.borderStyle = .line
        return text
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Próximo", for: .normal)
        button.titleLabel?.font  = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
        button.titleLabel?.textColor = .white
        button.backgroundColor =  UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1.0)
//        button.backgroundColor =  UIColor(red: 4/255, green: 119/255, blue: 235/255, alpha: 1.0)
        button.addTarget(self, action: #selector(onNext), for: .touchUpInside)
//        button.isEnabled = false
        return button
    }()
    
    let returnButton: UIButton = {
        let button = UIButton()
        button.setTitle("Voltar", for: .normal)
        button.titleLabel?.font  = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.textStartupName.addTarget(self, action: #selector(self.onTextFieldChanged(_:)), for: .editingChanged)
        self.textName.addTarget(self, action: #selector(self.onTextFieldChanged(_:)), for: .editingChanged)
        // Do any additional setup after loading the view
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        self.setupStartButtons()
        self.view.layoutIfNeeded()
    }
    
//    override func didLayoutSubviews() {
//        super.didLayoutSubviews()
//        self.setupCard()
//    }
    
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
    
    // MARK: - StateDelegate functions
    
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
    
    // MARK: - State Machine Delegate
    func onStateChanged(to newState: ConfiguringState) {

        print("State changed to", newState)
        self.clearCard() {
            switch newState {
            case .creating:
                self.onCreateState()
            case .inLobby:
                self.inLobbyState()
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
    
    func onCreateState()  {
        
        self.updateCardHeight(0.28)
        self.setupKeyboardDismissGesture()
        
        // Set title label
        self.setupSessionTitle("Creating a startup")
        
        // show field name
        self.setupCreatingForm(labelTop: self.labelTitle, constant: 80.0, label: self.labelInsertName, textField: self.textName)

        self.setupCreatingForm(labelTop: self.textName, constant: 30.0, label: self.labelInsertStartupName, textField: self.textStartupName)
        
        // show the next button
        self.setupNavigationButton("Próximo")
    }
    
    
    func inLobbyState()  {
        
        self.updateCardHeight(0.28)
        self.clearCard() {
            guard let roomId = NewTeamDatabaseFacade.newRoomId else { return }
            self.firebaseObserver = FirebaseObserver(delegate: self, reference: Database.database().reference().root.child(FirebaseKeys.newRooms.rawValue).child(roomId).child(FirebaseKeys.playersInRoom.rawValue))
            self.firebaseObserver?.setup()
            
            self.setupSessionTitle("Aguardando...")
            self.setupCollectionView()
            self.collectionView.reloadData()
            self.setupNavigationButton("Pronto")
            self.returnButton.isHidden = true
            
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
        UIView.animate(withDuration: 1.0, animations: {
            self.updateCardHeight(0.28)
        }) { _  in
            self.createStateMachine(with: [.joining, .inLobby, .pickingClass])
        }
    }
    
    
    @objc func handleTap(){
        UIView.animate(withDuration: 0.5) {
            self.updateCardHeight(0.28)
            self.view.endEditing(true)
        }
    }
    
    @objc func onReturn()  {
        
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
                
//                self.createTeamIfAllReady()
            }
            return
        }
        self.passState()
    }
    
    @objc func onTextFieldChanged(_ view: UITextView) {
        guard let state = self.stateMachine?.getCurrentState() else { return }
        switch state {
        case .creating:
            self.validateCreating()
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
        
        let newPlayer = JoiningPlayer(snap.key, from: snap.value as! NSDictionary)

        self.playersInLobby.append(newPlayer)
        
        self.collectionView.reloadData()
        
    }
    
    func onChanged(_ snap: DataSnapshot) {
        
        let newPlayer = JoiningPlayer(snap.key, from: snap.value as! NSDictionary)
        
        for (i, player) in self.playersInLobby.enumerated()  {
            if player.id == newPlayer.id {
                self.playersInLobby[i] = newPlayer
                break
            }
        }

//        self.createTeamIfAllReady()
        self.collectionView.reloadData()
    }
    
    func onRemoved(_ snap: DataSnapshot) {
        
        self.playersInLobby.removeAll { (player) -> Bool in
            player.id == snap.key
        }
        self.collectionView.reloadData()
    }
    

    // MARK: - CollectionView methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let currentState = self.stateMachine?.getCurrentState() else  { return 0 }
        
        if currentState == .inLobby {
            return self.playersInLobby.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let currentState = self.stateMachine?.getCurrentState() else  { return UICollectionViewCell() }
        guard let playerName = self.getPlayerName()   else { return UICollectionViewCell()}
        guard let startupName =  self.getRoomName() else { return UICollectionViewCell()}
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "lobby", for: indexPath)  as! LobbyCollectionViewCell
        
        
        cell.setup(self.playersInLobby)
        
        cell.ownerNameLabel.text = playerName
        cell.startupNameLabel.text = startupName
        cell.joinButton.isHidden = true
        
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let size = collectionView.frame.size
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
