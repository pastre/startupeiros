////
////  JoinGameViewController.swift
////  startupeiros
////
////  Created by Bruno Pastre on 21/11/19.
////  Copyright © 2019 Bruno Pastre. All rights reserved.
////
//
//import UIKit
//import FirebaseDatabase
//
//enum State {
//    case initialState
//    case newGameState
//    case joinGameState
//    case roomState
//    case selectPlayerState
//    case gamePlayState
//}
//
//enum Event {
//    case appearButtons
//    case newGamePressed
//    case joinGamePressed
//    case nextButtonPressed
//    case returnButtonPressed
//    case isReady
//}
//
//enum Errors: Error {
//    case transitionNotFound
//}
//
//class NewTeamViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    
//    var players: [JoiningPlayer] = []
//    var roomId: String!
//    var collectionView: UICollectionView!
//    
//    // Firebase reference
//    lazy var baseRef = Database.database().reference().root.child(FirebaseKeys.newRooms.rawValue).child(roomId).child(FirebaseKeys.playersInRoom.rawValue)
//    
//    lazy var roomRef = Database.database().reference().root.child(FirebaseKeys.newRooms.rawValue)
//    
//    // State Machine
//    var state = State.initialState
//    
//    let rolesList: [String]  = ["hustler", "hipster", "hacker"]
//    var rooms: [Room]! = []
//    
//    typealias Transition = () throws -> (State)
//    
//    
//    func transition(forEvent event: Event) throws -> Transition {
//        switch (state, event) {
//            
//        case(.initialState, .appearButtons): return showButtons()
//        case(.initialState, .newGamePressed): return startNewGame("Criando uma startup")
//        case(.initialState, .joinGamePressed): return startNewGame("Entrando em uma startup", false)
//            
//        case(.newGameState, .nextButtonPressed): return joinGameLobby()
//        case(.newGameState, .returnButtonPressed): return showButtons()
//            
//        case(.joinGameState, .nextButtonPressed): return selectClass()
//        case(.joinGameState, .returnButtonPressed): return showButtons()
//            
//        case(.selectPlayerState, .nextButtonPressed): return letsPlay()
//            
//        default: throw Errors.transitionNotFound
//        }
//    }
//    
//    // MARK: - Firebase functions
//    
//    
//    func setupObservers(){
//        
//        roomRef.observe(.childAdded) { (snap) in
//            self.onAdded(snap)
//        }
//        
//        roomRef.observe(.childChanged) { (snap) in
//            self.onChanged(snap)
//        }
//        
//        roomRef.observe(.childRemoved) { (snap) in
//            self.onRemoved(snap)
//        }
//    }
//    
//    // MARK: - Observer methods
//    
//    func onAdded(_ snap: DataSnapshot) {
//        
//        switch state {
//        case .joinGameState:
//            let newRoom = Room(snap.key, from: snap.value as! NSDictionary)
//            self.rooms.append(newRoom)
//        default:
//            let newPlayer = JoiningPlayer(snap.key, from: snap.value as! NSDictionary)
//            self.players.append(newPlayer)
//        }
//        self.createTeamIfAllReady()
//        self.collectionView.reloadData()
//    }
//    
//    func onChanged(_ snap: DataSnapshot) {
//        
//        let newPlayer = JoiningPlayer(snap.key, from: snap.value as! NSDictionary)
//        
//        for (i, player) in self.players.enumerated()  {
//            if player.id == newPlayer.id {
//                self.players[i] = newPlayer
//                break
//            }
//        }
//    
//        self.createTeamIfAllReady()
//        self.collectionView.reloadData()
//    }
//    
//    
//    func createTeamIfAllReady() {
//        // TODO: VER QUE TEM 3 PLAYERS
////        for player in self.players {
////            if !player.isReady { return }
////        }
//        
//        NewTeamDatabaseFacade.completeRoom(self.roomId) {
//            error in
//            if let error = error{
//                print("Erro ao remover a sala!", error)
//            }
//            
////            self.state.pass
//        }
//    }
//
//    
//    func onRemoved(_ snap: DataSnapshot) {
//        
//        self.players.removeAll { (player) -> Bool in
//            player.id == snap.key
//        }
//        self.collectionView.reloadData()
//    }
//    // Transition functions
//    func showButtons() -> Transition {
//        return {
//            UIView.animate(withDuration: 0.5) {
//                self.upCardRise(0)
//                self.clearCard()
//                
//                self.cardView.addSubview(self.newGame)
//                self.cardView.addSubview(self.joinGame)
//                
//                self.newGame.translatesAutoresizingMaskIntoConstraints = false
//                self.joinGame.translatesAutoresizingMaskIntoConstraints = false
//                self.newGame.heightAnchor.constraint(equalToConstant: 45).isActive = true
//                self.newGame.widthAnchor.constraint(equalToConstant: 240).isActive = true
//                
//                self.newGame.topAnchor.constraint(equalTo: self.cardView.topAnchor, constant: 60.0).isActive = true
//                self.newGame.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 60.0).isActive = true
//                
//                self.joinGame.heightAnchor.constraint(equalToConstant: 45).isActive = true
//                self.joinGame.widthAnchor.constraint(equalToConstant: 280).isActive = true
//                
//                self.joinGame.topAnchor.constraint(equalTo: self.newGame.bottomAnchor, constant: 8.0).isActive = true
//                self.joinGame.leadingAnchor.constraint(equalTo: self.newGame.leadingAnchor).isActive = true
//            }
//            return State.initialState
//        }
//    }
//    
//    func startNewGame(_ title: String, _ startup: Bool? =  true) -> Transition {
//        return {
//            // remove views from cardView
//            self.clearCard()
//            
//            self.setupTapGesture()
//            
//            // Set title label
////            self.sessionTitle(title)
//            
//            // show field name
//            self.field(labelTop: self.labelTitle, constant: 80.0, label: self.labelInsertName, textField: self.textName, view: self.bar1)
//            
//            if startup  ?? true {
//                // show field startup name
//                self.field(labelTop: self.bar1, constant: 30.0, label: self.labelInsertStartupName, textField: self.textStartupName, view: self.bar2)
//            }
//            
//            
//            // show the next button
//            self.sessionButton("Próximo")
//            
//            return State.newGameState
//        }
//    }
//    
//    func joinGameLobby() -> Transition {
//        return {
//            self.setupJoinRoomObserver()
//            self.clearCard()
////            self.sessionTitle("Aguardando")
//            self.setupCollectionView()
//            self.collectionView.reloadData()
//            self.sessionButton("Pronto")
//            return State.joinGameState
//        }
//    }
//    
//    func selectClass() -> Transition {
//        return {
//            self.clearCard()
//            self.cardView.addSubview(self.labelTitle)
////            self.sessionTitle("Escolha o seu papel")
//            self.setupCollectionView()
//            self.collectionView.reloadData()
//            self.sessionButton("Jogar", false)
//            return State.selectPlayerState
//        }
//    }
//
//    func letsPlay() -> Transition {
//        // aqui  chama o jogo
//        return{
//            self.clearCard()
//            return State.gamePlayState
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch state {
//        case .selectPlayerState:
//            return rolesList.count
//        default:
//            return rooms.count
//        }
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath) as! RolesCollectionViewCell
//        let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "lobby", for: indexPath) as! LobbyCollectionViewCell
//        print(state)
//        switch state {
//        case .selectPlayerState:
//            cell.setup()
//            
//            cell.imageView.image = UIImage(named: rolesList[indexPath.row])
//            cell.labelView.text = rolesList[indexPath.row]
//            
//            switch rolesList[indexPath.row] {
//            case "hustler":
//                cell.labelView.backgroundColor = UIColor(red: 71/255, green: 83/255, blue: 191/255, alpha: 1.0)
//            case "hipster":
//                cell.labelView.backgroundColor = UIColor(red: 190/255, green: 86/255, blue: 215/255, alpha: 1.0)
//            default:
//                cell.labelView.backgroundColor = UIColor(red: 88/255, green: 86/255, blue: 91/255, alpha: 1.0)
//            }
//            return cell
//        default:
//            if rooms.count == 0 {
//                self.collectionView.addSubview(self.noRoomLabel)
//            } else {
////                cell2.setup()
//                cell2.startupNameLabel.text = rooms[indexPath.row].name
//                cell2.ownerNameLabel.text = rooms[indexPath.row].players[0].name
//                cell2.numberLabel.text = "\(players.count)/3"
//            }
//            
//            return cell2
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if state ==  .joinGameState {
//            let size = collectionView.frame.size
//            return CGSize(width: size.width * 0.4,  height: size.height * 0.8)
//        } else {
//            let size = collectionView.frame.size
//            return CGSize(width: size.width * 0.4,  height: size.height)
//        }
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if state == .selectPlayerState  {
//            let cell = collectionView.cellForItem(at: indexPath) as! RolesCollectionViewCell
//            cell.cardView.alpha = 1.0
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        if state == .selectPlayerState {
//            let cell = collectionView.cellForItem(at: indexPath) as! RolesCollectionViewCell
//            cell.cardView.alpha = 0.5
//        }
//    }
//    
//    // Outlets
//    @IBOutlet var cardView: UIView!
//    @IBOutlet var heightConstraint: NSLayoutConstraint!
//    
//    // Objects
//    
//    var tap: UITapGestureRecognizer!
//    
//    let newGame: UIButton = {
//        let button = UIButton()
//        button.setTitle("Criar uma startup", for: .normal)
//        button.titleLabel?.font  = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
//        button.titleLabel?.textColor = .white
//        button.titleLabel?.textAlignment = .left
//        button.backgroundColor = UIColor(red: 4/255, green: 119/255, blue: 235/255, alpha: 1.0)
//        button.addTarget(self, action: #selector(onCreate), for: .touchUpInside)
//        return button
//    }()
//    
//    let joinGame: UIButton = {
//        let button = UIButton()
//        button.setTitle("Entrar em uma startup", for: .normal)
//        button.titleLabel?.font  = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
//        button.titleLabel?.textColor = .white
//        button.titleLabel?.textAlignment = .left
//        button.backgroundColor = UIColor(red: 235/255, green: 4/255, blue: 4/255, alpha: 1.0)
//        button.addTarget(self, action: #selector(onJoin), for: .touchUpInside)
//        return button
//    }()
//    
//    let labelTitle: UILabel = {
//        let label = UILabel()
//        label.text = "Criando uma startup"
//        label.font = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
//        label.textColor = UIColor(red: 4/255, green: 119/255, blue: 235/255, alpha: 1.0)
//        return label
//    }()
//    
//    let labelInsertName: UILabel = {
//        let label = UILabel()
//        label.text = "Insira o seu nome"
//        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
//        label.textColor =  UIColor(red: 4/255, green: 119/255, blue: 235/255, alpha: 1.0)
//        return label
//    }()
//    
//    let labelInsertStartupName: UILabel = {
//        let label = UILabel()
//        label.text = "Insira o nome da sua startup"
//        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
//        label.textColor =  UIColor(red: 4/255, green: 119/255, blue: 235/255, alpha: 1.0)
//        return label
//    }()
//    
//    let textName: UITextField = {
//        let text = UITextField()
//        text.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
//        text.textColor = .black
//        text.placeholder = ""
//        return text
//    }()
//    
//    let textStartupName: UITextField = {
//        let text = UITextField()
//        text.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
//        text.textColor = .black
//        text.placeholder = ""
//        return text
//    }()
//    
//    let bar1: UIView = {
//        let view  = UIView()
//        view.backgroundColor =  UIColor(red: 4/255, green: 119/255, blue: 235/255, alpha: 1.0)
//        return view
//    }()
//    
//    let bar2: UIView = {
//        let view  = UIView()
//        view.backgroundColor =  UIColor(red: 4/255, green: 119/255, blue: 235/255, alpha: 1.0)
//        return view
//    }()
//    
//    let nextButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Próximo", for: .normal)
//        button.titleLabel?.font  = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
//        button.titleLabel?.textColor = .white
//        button.backgroundColor =  UIColor(red: 4/255, green: 119/255, blue: 235/255, alpha: 1.0)
//        button.addTarget(self, action: #selector(onNext), for: .touchUpInside)
//        return button
//    }()
//    
//    let returnButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Voltar", for: .normal)
//        button.titleLabel?.font  = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
//        button.titleLabel?.textColor = .white
//        button.backgroundColor = UIColor(red: 235/255, green: 4/255, blue: 4/255, alpha: 1.0)
//        button.addTarget(self, action: #selector(onReturn), for: .touchUpInside)
//        return button
//    }()
//    
//    lazy var noRoomLabel: UILabel = {
//        let label = UILabel(frame: self.collectionView.frame)
//        
//        label.text = "Nenhuma startup cadastrada"
//        label.font = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
//        
//        return label
//    }()
//    
//    // Overrides functions
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.setupCard()
//        
//        try? handle(event: .appearButtons)
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        print("apareceu - will appear")
//        addKeyboardListeners()
//        if state == State.roomState {
//            NewTeamDatabaseFacade.joinRoom(self.roomId) { error in
//                if let error = error {
//                    print("erro ao entrar na sala", error)
//                }
//            }
//        }
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
//        
//    }
//    
//    // Just functions
//    func handle(event: Event) throws {
//        let transition = try self.transition(forEvent: event)
//        state = try transition()
//    }
//    
//    func sessionButton(_ title: String, _ key: Bool? = true) {
//        self.cardView.addSubview(self.nextButton)
//        self.nextButton.setTitle(title, for: .normal)
//        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
//        self.nextButton.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor, constant: -10.0).isActive = true
//        self.nextButton.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -30.0).isActive = true
//        self.nextButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
//        self.nextButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
//       
//        if key ?? true {
//            self.cardView.addSubview(self.returnButton)
//            self.returnButton.setTitle("Voltar", for: .normal)
//            self.returnButton.translatesAutoresizingMaskIntoConstraints = false
//            self.returnButton.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor, constant: -10.0).isActive = true
//            self.returnButton.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 30).isActive = true
//            self.returnButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
//            self.returnButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
//        }
//    }
//    
//    func setupTapGesture() {
//        self.tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        tap.delegate = self as? UIGestureRecognizerDelegate
//        self.cardView.addGestureRecognizer(tap)
//    }
//    
//    func addKeyboardListeners() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//    }
//    
//    func setupCard(){
//        cardView.layer.cornerRadius = 15.0
//        cardView.layer.applySketchShadow()
//    }
//    
//    
//    func joinRoom(_ roomId: String) {
//        let vc = RoomViewController()
//        
//        vc.roomId = roomId
//        vc.view.backgroundColor = .brown
//        
//        self.present(vc, animated: true, completion: nil)
//    }
//    
//    func upCardRise(_ multiplier: CGFloat) {
//        self.heightConstraint.constant = self.view.frame.height * multiplier
//        self.view.layoutIfNeeded()
//    }
//    
//    func field(labelTop: AnyObject, constant: CGFloat, label: UILabel, textField: UITextField, view: UIView) {
//        
//        // Add a text field title
//        self.cardView.addSubview(label)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.topAnchor.constraint(equalTo: labelTop.bottomAnchor, constant: constant).isActive = true
//        label.leadingAnchor.constraint(equalTo: labelTop.leadingAnchor).isActive = true
//        label.trailingAnchor.constraint(equalTo: labelTop.trailingAnchor).isActive = true
//        
//        // Add a text field title
//        self.cardView.addSubview(textField)
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8.0).isActive = true
//        textField.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
//        textField.trailingAnchor.constraint(equalTo: label.trailingAnchor).isActive = true
//        textField.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
//        
//        // Add a space bar
//        self.cardView.addSubview(view)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.topAnchor.constraint(equalTo: textField.bottomAnchor).isActive = true
//        view.leadingAnchor.constraint(equalTo: textField.leadingAnchor).isActive = true
//        view.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
//        view.widthAnchor.constraint(equalToConstant: 290.0).isActive = true
//        
//    }
//    
//    
//    func setupCollectionView()  {
//        let layout =  UICollectionViewFlowLayout()
//        
//        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 20
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
//        
//        self.cardView.removeGestureRecognizer(self.tap)
//        self.collectionView  = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        self.collectionView.showsHorizontalScrollIndicator = false
//        
//        self.collectionView.register(RolesCollectionViewCell.self, forCellWithReuseIdentifier: "default")
//        self.collectionView.register(LobbyCollectionViewCell.self, forCellWithReuseIdentifier: "lobby")
//        self.collectionView.backgroundColor = .clear
//        
//        self.collectionView.delegate = self
//        self.collectionView.dataSource = self
//        
//        self.cardView.addSubview(collectionView)
//        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
//        self.collectionView.topAnchor.constraint(equalTo: self.labelTitle.bottomAnchor, constant: 50).isActive  = true
//        self.collectionView.leadingAnchor.constraint(equalTo: self.labelTitle.leadingAnchor).isActive = true
//        self.collectionView.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor).isActive = true
//        self.collectionView.heightAnchor.constraint(equalToConstant: 250.0).isActive = true
//        
//        layout.invalidateLayout()
//            
//    }
//        
//    func clearCard(){
//        return 
//        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
//            for view in self.cardView.subviews {
//                view.removeFromSuperview()
//            }
//        }, completion: nil)
//    }
//    
//    // Object functions
//    @objc func handleTap(){
//        UIView.animate(withDuration: 0.5) {
//            self.upCardRise(0.28)
//            self.view.endEditing(true)
//        }
//    }
//    
//    @objc func keyboardWillShow(_ notification: Notification) {
//        self.upCardRise(0.5)
//    }
//    
//    func setupJoinRoomObserver() {
//        roomRef.observe(.childAdded) { (snap) in
//            self.onAdded(snap)
//        }
//        
//        roomRef.observe(.childChanged) { (snap) in
//            self.onChanged(snap)
//        }
//        
//        roomRef.observe(.childRemoved) { (snap) in
//            self.onRemoved(snap)
//        }
//    }
//    
//    @objc func onNext(){
//        print("entrou")
//        
//        if state == .newGameState {
//
//            Authenticator.instance.createPlayer(named: self.textName.text!) { error in
//
//                NewTeamDatabaseFacade.createRoom(named: String(describing: self.textStartupName.text!)) { (error) in
//                    if let error  = error {
//                        print("Erro ao criar a sala", error)
//                        return
//                    }
//                    try? self.handle(event: .nextButtonPressed)
//                }
//            }
//        } else{
//            try? self.handle(event: .nextButtonPressed)
//        }
//    }
//    
//    @objc func onReturn(){
//           print("voltando")
//        UIView.animate(withDuration: 0.5, animations: {
//            self.upCardRise(Bool(self.state==State.newGameState) ? 0 : 0.28)
//        }) { _  in
//            try? self.handle(event: .returnButtonPressed)
//        }
//       }
//    
//    @objc func onCreate() {
//        print("Creating")
//        UIView.animate(withDuration: 0.5, animations: {
//            self.upCardRise(0.28)
//        }) { _  in
//            try? self.handle(event: .newGamePressed)
//        }
//    }
//    
//    @objc func onJoin() {
//        UIView.animate(withDuration: 1.0, animations: {
//            self.upCardRise(0.28)
//        }) { _  in
//            try? self.handle(event: .joinGamePressed)
//        }
//    }
//    
//}
