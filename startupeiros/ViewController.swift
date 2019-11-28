//
//  ViewController.swift
//  startupeiros
//
//  Created by Bruno Pastre on 20/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var energyBarSpace: UIView!
    @IBOutlet weak var coffeeProgressBarSpace: UIView!
    
    
    let coffeeProgressBar: CoffeeBar = {
        let bar = CoffeeBar()
        
        bar.translatesAutoresizingMaskIntoConstraints = false
        
        return bar
    }()
    
    let energyProgressBar: WorkBar =  {
        let bar = WorkBar()
        
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.setup()
        
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCoffeeProgressBar()
        self.setupEnergyBar()
        // Do any additional setup after loading the view.
    }

    func setupEnergyBar() {
        self.energyBarSpace.addSubview(self.energyProgressBar)
        
        self.energyProgressBar.topAnchor.constraint(equalTo: self.energyBarSpace.topAnchor).isActive = true
        self.energyProgressBar.leadingAnchor.constraint(equalTo: self.energyBarSpace.leadingAnchor).isActive = true
        self.energyProgressBar.bottomAnchor.constraint(equalTo: self.energyBarSpace.bottomAnchor).isActive = true
        self.energyProgressBar.trailingAnchor.constraint(equalTo: self.energyBarSpace.trailingAnchor).isActive = true
    }
    
    func setupCoffeeProgressBar() {
        self.coffeeProgressBarSpace.addSubview(self.coffeeProgressBar)
        
        self.coffeeProgressBar.topAnchor.constraint(equalTo: self.coffeeProgressBarSpace.topAnchor).isActive = true
         self.coffeeProgressBar.leadingAnchor.constraint(equalTo: self.coffeeProgressBarSpace.leadingAnchor).isActive = true
         self.coffeeProgressBar.trailingAnchor.constraint(equalTo: self.coffeeProgressBarSpace.trailingAnchor).isActive = true
         self.coffeeProgressBar.bottomAnchor.constraint(equalTo: self.coffeeProgressBarSpace.bottomAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    @IBAction func onCoffee(_ sender: Any) {
        self.coffeeProgressBar.startProgress()
        ResourceFacade.instance.coffeeManager.runTask()
    }
    
}

