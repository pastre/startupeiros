//
//  PlayerClass.swift
//  startupeiros
//
//  Created by Bruno Pastre on 07/12/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

enum PlayerClass: String {
    case hacker = "hacker"
    case hustler = "hustler"
    case hipster = "hipster"
    
    init(from str: String) {
        switch str {
            case "hacker":
                self = .hacker

            case "hustler":
                self = .hustler

            case "hipster":
                self = .hipster
            
            default: fatalError("Inicialitou PlayerClass com um valor invalido: \(str)")
        }
    }
}
