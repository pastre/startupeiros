//
//  EventBinder.swift
//  startupeiros
//
//  Created by Bruno Pastre on 28/11/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

class EventBinder {
    private static let notificationCenter = NotificationCenter.default
    
    enum Event: String {
        
        case energy = "energy"
        
        func asNotificationName() -> NSNotification.Name {
            return NSNotification.Name.init(rawValue: self.rawValue)
        }
    }
    
    static func bind<T: BindedSupplicant>(_ clasz: T,to event: Event) {
        notificationCenter.addObserver(clasz, selector: #selector(clasz.update), name: event.asNotificationName(), object: nil)
    }
    
    static func trigger(event: Event) {
        notificationCenter.post(name: event.asNotificationName(), object: nil)
    }
}
