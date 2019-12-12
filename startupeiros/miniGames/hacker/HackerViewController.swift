//
//  HackerViewController.swift
//  startupeiros
//
//  Created by Bruno Pastre on 08/12/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class HackerViewController: MiniGameViewController {


    let textView: UITextView = {
        let view = UITextView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentOffset = .zero
        view.isUserInteractionEnabled = false
        view.font = UIFont(name: "Andale-Mono", size: 14)
        view.textColor = UIColor(displayP3Red: 99/255, green: 216/255, blue: 160/255, alpha: 1)
        view.backgroundColor = UIColor(displayP3Red: 18/255, green: 17/255, blue: 17/255, alpha: 1)
        
        return view
    }()

    let scoreLabel: UILabel = {
        let view = UILabel()
        
        
        view.text = "// 0 MB HACKED"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor  = UIColor(displayP3Red: 223/255, green: 92/255, blue: 77/255, alpha: 1)
        view.font = UIFont(name: "Andale-Mono", size: 14)

        return view
    }()
    
    let timeLabel: UILabel = {
        let view = UILabel()
        
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor  = .black
        view.font = UIFont(name: "Andale-Mono", size: 14)
        view.numberOfLines = 0
        
        view.text = "TRACE: \n 00:33.39"
        
        return view
    }()
    
    var imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "hackerGameKeyboard"))
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        
        return view
    }()

    var currentLine = 0
    var currentScore: Double = 0
    var currentText: String = ""
    var lines: [String]!
    var currentTime: TimeInterval! = 30
    
    override func viewDidLoad() {

        self.lines = self.getLoadedFiles()
        
        self.view.backgroundColor = .black
        self.view.addSubview(imageView)
        self.view.addSubview(textView)
        self.view.addSubview(scoreLabel)
        self.view.addSubview(timeLabel)
        
        scoreLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        scoreLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scoreLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7).isActive = true
        scoreLabel.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        
        timeLabel.centerYAnchor.constraint(equalTo: scoreLabel.centerYAnchor).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalTo: scoreLabel.widthAnchor, multiplier: 0.3).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: scoreLabel.heightAnchor).isActive = true
        
        imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25).isActive = true
        
        textView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.imageView.topAnchor).isActive = true
        
        super.viewDidLoad()
    }
    
    
    // MARK: - Game mechanics
    
    func startCountdownTimer() {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (t) in
            self.currentTime -= 0.01
            self.timeLabel.text = "TRACE: \n 00:\(self.currentTime.rounded(toPlaces: 2))"
            if self.currentTime <= 0    {
                self.timeLabel.text = "TRACE: \n 00:00.00"
                self.onGameOver(self.currentScore)
                t.invalidate()
            }
        }
    }
    
    func updateScore() {
        let asDouble = Double(self.currentLine)
        self.currentScore += asDouble + 0.05 * asDouble
        
        self.scoreLabel.text = "// \(self.currentScore.rounded(toPlaces: 2)) MB HACKED"
    }
    
    // MARK: - File loading methods
    
    func loadFromFile(named name: String) -> String? {
        guard let path = Bundle.main.path(forResource: name, ofType: "txt") else { return nil }
        guard let content = try? String(contentsOfFile: path, encoding: .utf8) else { return nil}
        
        return content
    }
    
    func getLoadedFiles() -> [String] {
        let loadedFile: String = loadFromFile(named: "HackerContent")!
        
        return loadedFile.components(separatedBy: "\n").filter { (s) -> Bool in
            return s != ""
        }
    }
    
    func onTouch() {
        self.currentText += self.lines[self.currentLine] + "\n"
        self.currentLine += 1
        
        self.textView.text = self.currentText
        
        let bottom = NSMakeRange(textView.text.count - 1, 1)
        textView.scrollRangeToVisible(bottom)

        self.updateScore()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if self.hasStartedGame && !self.isGameOver{
            for _ in touches {
                self.onTouch()
            }
        }
    }
    

        
    override func startGame() {
        self.startCountdownTimer()
    }
    
    override func getMultiplierTransform() -> Double {
        return 0.1
    }
    
    override func getFinalMessage() -> String {
        return "Type!"
    }

}
