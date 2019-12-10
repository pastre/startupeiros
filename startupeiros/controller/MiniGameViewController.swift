//
//  MiniGameViewController.swift
//  startupeiros
//
//  Created by Bruno Pastre on 10/12/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class MiniGameViewController: UIViewController {
    var currentTimerValue: TimeInterval = 3
    
    let timerLabel: UILabel = {
       let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    
    let labelOverlay: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTimerLabel()
        self.setupLabelOverlay()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.startTimer()
    }
    
    // MARK: - Setup Methods
    
    func setupTimerLabel() {
        self.labelOverlay.addSubview(timerLabel)
        
        self.timerLabel.topAnchor.constraint(equalTo: self.labelOverlay.topAnchor).isActive = true
        self.timerLabel.leadingAnchor.constraint(equalTo: self.labelOverlay.leadingAnchor).isActive = true
        self.timerLabel.trailingAnchor.constraint(equalTo: self.labelOverlay.trailingAnchor).isActive = true
        self.timerLabel.bottomAnchor.constraint(equalTo: self.labelOverlay.bottomAnchor).isActive = true
    }
    
    func setupLabelOverlay() {
        
        self.view.addSubview(self.labelOverlay)
        
        self.labelOverlay.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.labelOverlay.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.labelOverlay.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        self.labelOverlay.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5).isActive = true
    }
    
    // MARK: - Timer methods
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.updateTimerLabel(self.currentTimerValue == 0)
            self.currentTimerValue -= 1
            if self.currentTimerValue < -1 {
                timer.invalidate()
                self.labelOverlay.removeFromSuperview()
                self.startGame()
            }
        }
    }
    
    func updateTimerLabel(_ isLast: Bool = false) {
        if isLast {
            self.timerLabel.text = self.getFinalMessage()
        } else {
            self.timerLabel.text = "\(Int(self.currentTimerValue))"
        }
    }
    
    // MARK: - Game over methods
    
    func onGameOver(_ score: Double) {
        
        let multiplier = ((score * self.getMultiplierTransform()).truncatingRemainder(dividingBy: 10))
        
        self.setupLabelOverlay()
        
        self.timerLabel.text = "Congrats!\nYou scored\n\(score.rounded(toPlaces: 2))\nWhich converts to a\n \(multiplier.rounded(toPlaces: 2))X\n multiplier"
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now().advanced(by: DispatchTimeInterval.seconds(3))) {
            self.dismiss(animated: true) {
                print("Dismissed MinigameViewController")
            }
        }
        
    }
    
    
    

    // MARK: - Abstract methods
    func startGame() {
        
        fatalError("\(self) did not implement startGame")
    }
    
    func getMultiplierTransform() -> Double {
        
        fatalError("\(self) did not implement getMultiplierTransform")
    }
    
    func getFinalMessage() -> String {
        fatalError("\(self) did not implement getFinalMessage")
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
