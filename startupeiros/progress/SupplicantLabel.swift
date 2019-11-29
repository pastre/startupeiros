//
//  SupplicantLabel.swift
//  startupeiros
//
//  Created by Bruno Pastre on 28/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class SupplicantLabel: UILabel, BindedSupplicant {
    func update(_ notification: NSNotification) {
        self.update()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    func setup() {
        
    }
    
    
    func update() {
        
    }
    
}

class WorkSupplicantLabel: SupplicantLabel  {
    
    override func setup() {
        EventBinder.bind(self, to: .work)
    }
    
    
    override func update() {
        let manager = ResourceFacade.instance.workManager
        self.text = "\(manager.accumulated) WP"
    }
    
}
