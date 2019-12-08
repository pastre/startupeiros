//
//  TaskBar.swift
//  startupeiros
//
//  Created by Bruno Pastre on 28/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class TaskBar: ProgressBarView  {
    var task: Task!

    override func commonInit() {
        super.commonInit()
        self.backgroundColor = .white
        self.progressView.backgroundColor = .systemGreen
    }
    func startProgress() {
        EventBinder.bind(self, to: task)
    }
    
    
    
}
