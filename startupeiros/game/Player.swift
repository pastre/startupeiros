//
//  Player.swift
//  startupeiros
//
//  Created by Bruno Pastre on 26/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

class Player: Profiter, Giver {
    func take(_ amount: Coin) {
        for i in 0..<Int(amount.getRawAmount()) {
            self.currentValue.removeFirst()
        }
        
        print("THE PLAYERS HAS", self.getCoffeeAmount(), "COFFEE POINTS")
        print("THE PLAYERS HAS", self.getWorkAmount(), "WORK POINTS")
    }
    
   
    var currentValue: [Coin]!
    
    func receive(_ amount: Coin, from producer: Producer) {
        self.currentValue.append(amount)
        
        print("THE PLAYERS HAS", self.getCoffeeAmount(), "COFFEE POINTS")
        print("THE PLAYERS HAS", self.getWorkAmount(), "WORK POINTS")
    }
    
    func getCurrentAmount() -> Double {
        fatalError("PLAYER  DOESNT KNOW CURRENT AMOUNT")
    }
    
    func getCoffeeAmount() -> Double {
        return self.getCoffeeCoins().map { (coin) -> Double in
            return coin.getRawAmount()
        }.reduce(0, +)
    }
    
    
    func getWorkAmount() -> Double {
        return self.getWorkCoins().map { (coin) -> Double in
            return coin.getRawAmount()
        }.reduce(0, +)
    }
    
    private func getCoffeeCoins() -> [CoffeeCoin] {
        return self.currentValue.filter { (coin) -> Bool in
            coin is CoffeeCoin
        }.map { (coin) -> CoffeeCoin in
            return coin as! CoffeeCoin
        }
    }
    
    private func getWorkCoins() -> [WorkCoin] {
        return self.currentValue.filter { (coin) -> Bool in
            coin is WorkCoin
        }.map { (coin) -> WorkCoin in
            return coin as! WorkCoin
        }
    }
    
    static let instance = Player()
    
    private init(){
        self.currentValue = []
    }
    
    
}
