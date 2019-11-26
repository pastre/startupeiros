//
//  Protocols.swift
//  startupeiros
//
//  Created by Bruno Pastre on 25/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

protocol Lockable {
    func isLocked() -> Bool
    func lock()
    func unlock()
}

protocol Completable {
    func isCompleted() -> Bool
}

protocol Coastable {
    func getCoastPerRun() -> Double
    func getMultiplier() -> Double
}

protocol Upgradeable {
    func getUpgradeCoast() -> Double
}

protocol Levelable {
    func getAbsoluteLevelPoints() -> Int
    func getLevel() -> Int
    func getLevelProgress() -> Int
    func getNextLevelRequirement() -> Int
}
