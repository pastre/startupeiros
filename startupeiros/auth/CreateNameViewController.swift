//
//  FirstViewController.swift
//  startupeiros
//
//  Created by Bruno Pastre on 21/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class CreateNameViewController: UIViewController {

    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    let nextButton: UIButton =  {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var navParent: DecideStartViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.setTitle("Done", for: .normal)
        nextButton.addTarget(self, action: #selector(self.onNext), for: .touchUpInside)
        nextButton.tintColor = .green
        nextButton.backgroundColor = .blue
        
        self.view.addSubview(nextButton)
        self.view.addSubview(textView)
        
        textView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        textView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        textView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        textView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.15).isActive = true
        
        
        nextButton.topAnchor.constraint(equalTo: textView.bottomAnchor).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: textView.centerXAnchor).isActive = true
        
        nextButton.widthAnchor.constraint(equalTo: textView.widthAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalTo: textView.heightAnchor).isActive = true
        
    }
    
    
    
    
    @objc func onNext() {
        Authenticator.instance.createPlayer(named: textView.text) { error in
            print("ERROR", error)
            self.navParent.hasJustCreated  = true
            self.dismiss(animated: true) {
                self.navParent.presentGameView()
            }
        }
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
