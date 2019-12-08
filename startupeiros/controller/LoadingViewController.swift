//
//  LoadingViewController.swift
//  startupeiros
//
//  Created by Bruno Pastre on 28/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        GameDatabaseFacade.instance.load { (jobs, currentJob) in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "viewController") as! ViewController

            vc.job = currentJob
            vc.modalPresentationStyle = .overFullScreen
            
            self.present(vc, animated: true, completion: nil)
        }
        
    }

}
