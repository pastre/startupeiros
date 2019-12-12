//
//  PredictionResult.swift
//  startupeiros
//
//  Created by Bruno Pastre on 08/12/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

func classToEmoji(className: String) -> String {

    let dict = [
        "apple" :  "🍎",
        "banana" :  "🍌",
        "bread" :  "🍞",
        "broccoli" :  "🥦",
        "cake" :  "🎂",
        "carrot" :  "🥕",
        "coffee" : "☕️",
        "coffee cup" : "☕️",
        "cookie" :  "🍪",
        "donut" :  "🍩",
        "grapes" :  "🍇",
        "hotdog" :  "🌭",
        "hot dog" :  "🌭",
        "icecream" :  "🍦",
        "ice cream" :  "🍦",
        "lollipop" :  "🍭",
        "mushroom" :  "🍄",
        "peanut" :  "🥜",
        "pear" :  "🍐",
        "pineapple" :  "🍍",
        "pizza" :  "🍕",
        "potato" :  "🥔",
        "sandwich" :  "🥪",
        "steak" :  "🥩",
        "strawberry" :  "🍓",
        "watermelon" :  "🍉"
    ]
    
    return dict[className]!
}

func getEmojis() -> [String] {
    return getClasses().map { (s) -> String in
        return classToEmoji(className: s)
    }
}

func getClasses() -> [String] {
    return [
        "apple" ,
        "banana" ,
        "bread" ,
        "broccoli" ,
        "cake" ,
        "carrot" ,
        "coffee",
        "cookie" ,
        "donut" ,
        "grapes" ,
        "hotdog" ,
        "icecream" ,
        "lollipop" ,
        "mushroom" ,
        "peanut" ,
        "pear" ,
        "pineapple" ,
        "pizza" ,
        "potato" ,
        "sandwich" ,
        "steak" ,
        "strawberry" ,
        "watermelon" ,
    ]
}

class PredictionResult {
    
    private var identifier: String!
    private var confidence: Float!
    
    
    init(_ identifier: String, confidence: Float) {
        self.identifier = identifier
        self.confidence = confidence
    }
    
    func getIdentifier() -> String {
        return self.identifier
    }
    
    func getConfidence() -> Float {
        return self.confidence
    }
    
    func getEmoji() -> String {
        return classToEmoji(className: self.identifier)
    }
}
