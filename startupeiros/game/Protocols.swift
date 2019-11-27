//
//  Protocols.swift
//  startupeiros
//
//  Created by Bruno Pastre on 25/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

protocol Coin {
    func getRawAmount() -> Double
}

protocol Lockable {
    func isLocked() -> Bool
    func lock()
    func unlock()
}

protocol Coaster {
    var giver: Giver! { get set }
    
    func getCoastPerRun() -> Coin
    func getMultiplier() -> Double
    func coast(from giver: Giver)
}

protocol Giver {
    func take(_ amount: Coin)
}

protocol Producer {
    var profiter: Profiter! { get set }
    func deliver(_ amount: Coin, to profiter: Profiter)
}

protocol Profiter {
    var currentValue: [Coin]! { get set }
    func receive(_ amount: Coin, from producer: Producer)
    func getCurrentAmount() -> Double
}

protocol Upgradeable {
    func isUpgradeable() -> Bool
    func getUpgradeCoast() -> Double
    func getUpgradeMultiplier() -> Double
}

protocol Levelable {
    func getAbsoluteLevelPoints() -> Int
    func getLevel() -> Int
    func getLevelProgress() -> Int
    func getNextLevelRequirement() -> Int
}


protocol Identifier {
    func getName() -> String
    func getIconName() -> String
}
