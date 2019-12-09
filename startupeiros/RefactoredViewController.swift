//
//  RefactoredViewController.swift
//  startupeiros
//
//  Created by Maykon Meneghel on 09/12/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

enum ConfiguringState {
    case start
    case creating
    case joining
    case inLobby
    case pickingClass
}

protocol StateMachineDelegate {
    func onStateChanged(to newState: ConfiguringState)
    func getPlayerName() -> String?
    func getRoomName() -> String?
}

class StateMachine {
    
    var states: [ConfiguringState]
    var delegate: StateMachineDelegate?
    var currentState = 0
    
    init(state: [ConfiguringState]) {
        self.states = state
    }
    
    func getCurrentState() -> ConfiguringState {
        return self.states[self.currentState]
    }
    
    func passState() {
        switch self.getCurrentState() {
            
        case .creating:
            self.createRoom {
                error in
                if let error = error  {
                    // TODO
                }  else {
                    self._passState()
                }
            }
        default:break
        }
    }
    
    private func _passState() {
        
        self.currentState += 1
        self.delegate?.onStateChanged(to: self.getCurrentState())
    }
    
    func setup() {
        self.delegate?.onStateChanged(to: self.getCurrentState())
    }
    
    func createRoom(completion: @escaping (Error?) -> ()) {
        guard let playerName = self.delegate?.getPlayerName() else { return }
        guard let startupName = self.delegate?.getPlayerName() else { return }
        Authenticator.instance.createPlayer(named: playerName) { (error) in
            NewTeamDatabaseFacade.createRoom(named: startupName) { (creationError) in
                if error != nil {
                    completion(error)
                    return
                }
                
                if creationError != nil {
                    completion(creationError)
                    return
                }
                
                completion(nil)
            }
        }
    }
    
}

class RefactoredViewController: UIViewController, StateMachineDelegate, UITextFieldDelegate {

    
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
        text.borderStyle = .line
        return text
    }()

    
    let textStartupName: UITextField = {
        let text = UITextField()
        text.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        text.textColor = .black
        text.placeholder = ""
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
        button.isEnabled = false
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
    
    var stateMachine: StateMachine?
    
    var tap: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.textStartupName.addTarget(self, action: #selector(self.onTextFieldChanged(_:)), for: .editingChanged)
        self.textName.addTarget(self, action: #selector(self.onTextFieldChanged(_:)), for: .editingChanged)
        // Do any additional setup after loading the view
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        self.setupStartButtons()
        self.view.layoutIfNeeded()
    }
    
    // MARK: - Setup methods
    
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
