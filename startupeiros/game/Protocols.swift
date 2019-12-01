//
//  Protocols.swift
//  startupeiros
//
//  Created by Bruno Pastre on 25/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit
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
    
    func canRun() -> Bool
    func getCoastPerRun() -> Coin
    func getCoastMultiplier() -> Double
    func coast(from giver: Giver)
}

protocol Giver {
    func take(_ amount: Coin)
    func canTake(_ amount: Coin) -> Bool
}

protocol Producer {
    var profiter: Profiter! { get set }
    func getProductionMultiplier() -> Double
    func getProductionBase() -> Double
    func getProductionOwned() -> Double
    func getProductionResult() -> Double
    func deliver(_ amount: Coin, to profiter: Profiter)
}

protocol Profiter {
    func receive(_ amount: Coin, from producer: Producer)
}

protocol Upgradeable {
    func isUpgradeable() -> Bool
    func getBaseUpgradeCoast() -> Double
    func getUpgradeCoast() -> Double
    func getGrowthRate() -> Double
    func getOwnedCount() -> Double
    func getUpgradeMultiplier() -> Double
    func upgrade()
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
    
    init(name: String, iconName: String)
}

@objc protocol BindedSupplicant {
    @objc func update(_ notification: NSNotification)
}

protocol BindedSupplicator {
    func triggerUpdate()
}

protocol ProgressSupplicant {
    func updateProgress()
    func getProgress() -> CGFloat
    func isDone() -> Bool
    func onComplete()
}

protocol Bindable {
    func getQueueName() -> String
}
