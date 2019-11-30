//
//  TutorialViewController.swift
//  startupeiros
//
//  Created by Maykon Meneghel on 29/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

enum TutorialState: CaseIterable {
    case coffee
    case work
}

class TutorialViewController: ViewController {
    
    var currentState: Int!
    @IBOutlet var buttonParents: UIView!
    
//    var refereceVC: UIV
    
    let overlayView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.7

        return view
    }()
    
    let nextButton:  UIButton = {
       let button = UIButton()

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Próximo", for: .normal)
        return button
    }()
    
    let labelText: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Essa é a sua área de trabalho!"
        label.font  = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        label.textColor = UIColor.black
        return label
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentState = 0
        self.displayState()
        self.setupOverlay()
        self.setupNextButton()
        
    }
    
    func setupNextButton() {
        self.overlayView.addSubview(labelText)

        self.nextButton.addTarget(self, action: #selector(self.onNextState), for: .touchDown)

        self.overlayView.addSubview(nextButton)


    }
    
    func setupOverlay() {
        self.view.addSubview(self.overlayView)

        self.overlayView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.overlayView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.overlayView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.overlayView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func updateState(){
        self.currentState += 1
        self.displayState()
        
    }
    
    func displayState() {
        let state = TutorialState.allCases[self.currentState]
        self.updateOverlay()
        
        switch state {
        case .coffee:
            self.displayCoffee()
        default:
            displayWork()
        }
    }
    
    func updateOverlay() {
//        self.view.bringSubviewToFront(self.overlayView)
    }
    
    func displayCoffee() {
//        self.view.bringSubviewToFront(self.buttonParents)
//        self.buttonParents.backgroundColor = .white
//        self.coffeeButton.layer.borderColor = UIColor.orange.cgColor
        print("COFFE IS IN FRONT")
        
//        self.nextButton.trailingAnchor.constraint(equalTo: self.overlayView.trailingAnchor).isActive = true

//        self.nextButton.bottomAnchor.constraint(equalTo: self.overlayView.bottomAnchor).isActive = true
//        self.nextButton.widthAnchor.constraint(equalTo: self.overlayView.widthAnchor, multiplier: 0.3).isActive = true
//        self.nextButton.heightAnchor.constraint(equalTo: self.overlayView.heightAnchor, multiplier: 0.1).isActive = true

//        self.labelText.centerYAnchor.constraint(equalTo: self.overlayView.centerYAnchor).isActive = true
//        self.labelText.centerXAnchor.constraint(equalTo: self.overlayView.centerXAnchor).isActive = true
//
        
    }

    func displayWork() {
        
    }
    
    @objc func onNextState() {
        self.updateState()
    }
    
    
}
