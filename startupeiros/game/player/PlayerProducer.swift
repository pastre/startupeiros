//
//  PlayerProducer.swift
//  startupeiros
//
//  Created by Bruno Pastre on 27/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

class PlayerProducer: Producer, TimerDelegate {
    func onTrigger() {
        // METODO EM BRANCO, IMPLEMENTADO PELAS SUBCLASSES
    }
    
    func onComplete() {
        // METODO EM BRANCO, IMPLEMENTADO PELAS SUBCLASSES
    }
    
    func onInvalidated() {
        // METODO EM BRANCO, IMPLEMENTADO PELAS SUBCLASSES
    }
    
    
    var profiter: Profiter!
    var taskTimer: TaskTimer?
    
    required init(_  profiter: Profiter) {
        self.profiter = profiter
    }
    
    func deliver(_ amount: Coin, to profiter: Profiter) {
        profiter.receive(amount, from: self)
    }
    
    func run() {
        self.taskTimer = TimerFactory.timer(delegate: self)
        
        self.taskTimer?.run()
    }
}
