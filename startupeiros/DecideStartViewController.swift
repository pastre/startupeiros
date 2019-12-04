//
//  DecideStartViewController.swift
//  startupeiros
//
//  Created by Bruno Pastre on 21/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class DecideStartViewController: UIViewController {

    var hasJustCreated: Bool!  = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let indicator = UIActivityIndicatorView(style: .large)
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(indicator)
        
        
        indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        indicator.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        indicator.heightAnchor.constraint(equalTo: indicator.widthAnchor).isActive = true
        
        indicator.startAnimating()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let created = PlayerFacade.hasCreated(), created == true {
            
        }
        
        if self.hasJustCreated {
            self.presentGameView()
        } else if Authenticator.instance.hasCreated() {
            Authenticator.instance.login { (error) in
                if let error = error {
                    print("Erro ao fazer login!", error)
                }
            }
            self.presentGameView()
        } else {
            self.presentFirstView()
        }
    }
    
    func presentGameView()  {
        let vc = NewTeamViewController()
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func presentFirstView(){
        let vc = CreateNameViewController()
        vc.navParent = self
        vc.modalPresentationStyle = .overCurrentContext
        self.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
}
