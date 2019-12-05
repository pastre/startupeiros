//
//  TimerFactory.swift
//  startupeiros
//
//  Created by Bruno Pastre on 01/12/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation


class TimerFactory {
    static func timer(delegate: TimerDelegate, for timeable: Balanceable) -> TaskTimer {
        let timer = TaskTimer(duration: timeable.getDuration())
        timer.delegate = delegate
        return timer
    }
}
