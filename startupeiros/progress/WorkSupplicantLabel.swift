//
//  WorkSupplicantLabel.swift
//  startupeiros
//
//  Created by Bruno Pastre on 29/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

class WorkSupplicantLabel: SupplicantLabel  {
    
    override func setup() {
        EventBinder.bind(self, to: .work)
    }
    
    
    override func update() {
        let manager = ResourceFacade.instance.workManager
        self.text = "\(manager.accumulated) WP"
    }
    
}
