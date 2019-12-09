//
//  HackerViewController.swift
//  startupeiros
//
//  Created by Bruno Pastre on 08/12/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class HackerViewController: UIViewController {


    let textView: UITextView = {
        let view = UITextView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentOffset = .zero
        view.isUserInteractionEnabled = false
        view.font = UIFont(name: "Andale-Mono", size: 14)
        view.textColor = UIColor(displayP3Red: 99/255, green: 216/255, blue: 160/255, alpha: 1)
        
        return view
    }()

    var imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "hackerGameKeyboard"))
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        
        return view
    }()

    var currentLine = 0
    var currentText: String = ""
    var lines: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lines = self.getLoadedFiles()
        
        self.view.addSubview(imageView)
        self.view.addSubview(textView)
        
        imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25).isActive = true
        
        textView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.imageView.topAnchor).isActive = true
    }
    
    // MARK: -
    
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

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.onTouch()
    }
    
    
}
