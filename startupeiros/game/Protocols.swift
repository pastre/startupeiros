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
    func getCoastPerRun() -> Double
    func getMultiplier() -> Double
    func coast(from profiter: Profiter)
}

protocol Producer {
    func deliver(_ amount: Coin, to profiter: Profiter)
}

protocol Profiter {
    var currentValue: [Coin] { get set }
    func receive(_ amount: Coin, from producer: Producer)
}

protocol Upgradeable {

    func getUpgradeCoast() -> Double
    func getUpgradeMultiplier() -> Double
}

protocol Levelable {
    func getAbsoluteLevelPoints() -> Int
    func getLevel() -> Int
    func getLevelProgress() -> Int
    func getNextLevelRequirement() -> Int
}
