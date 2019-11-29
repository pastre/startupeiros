//
//  CoffeeManager.swift
//  startupeiros
//
//  Created by Bruno Pastre on 27/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

class ResourceManager<T>: Profiter, Giver where T: PlayerProducer{
    
    var currentTask: T?
    var accumulated: Double = 0

    func runTask(configure: @escaping() -> ()){
        let profiter = self
        if let task = self.currentTask  {
            if !(task.taskTimer?.isDone() ?? false)  { return }
        }
        
        if let task = self.currentTask as? Coaster {
            if !task.canRun()  { return }
        }
        
        self.currentTask = T(profiter)
        configure()
        self.currentTask?.run()
    }
    
    func getAccumulated() -> Double {
        return self.accumulated
    }
    
    // MARK: - PROFITER
    func receive(_ amount: Coin, from producer: Producer) {
        self.accumulated += amount.getRawAmount()
        self.triggerIfPossible()
    }
    
    func take(_ amount: Coin) {
        self.accumulated -= amount.getRawAmount()
        print(self, accumulated)
        self.triggerIfPossible()
    }
    
    func triggerIfPossible() {
        guard let task = self.currentTask, let supplicator = task as? BindedSupplicator else { return }
        
        supplicator.triggerUpdate()
    }
    
}

class ResourceFacade {
    var coffeeManager = ResourceManager<Coffee>()
    var workManager = ResourceManager<Work>()
    
    static let instance = ResourceFacade()
    
    private init() {}

}
