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
        
        case coffeeStart = "coffeeStart"
  
        case workStart = "workStart"
        
        case energy = "energy"
        case work = "work"
        
        case hackerProgress = "hackerProgress"
        case hipsterProgress = "hipsterProgress"
        case hustlerProgress = "hustlerProgress"
        
        
        func asNotificationName() -> NSNotification.Name {
            return NSNotification.Name.init(rawValue: self.rawValue)
        }
    }
    
    
    static func bind<T: BindedSupplicant>(_ clasz: T, to event: Event) {
        notificationCenter.addObserver(clasz, selector: #selector(clasz.update), name: event.asNotificationName(), object: nil)
    }
    
    static func unbind(clas: BindedSupplicant) {
        notificationCenter.removeObserver(clas)
    }
    
    
    static func bind<T: BindedSupplicant>(_ clasz: T, to bindable: Bindable) {
        notificationCenter.addObserver(clasz, selector: #selector(clasz.update), name: NSNotification.Name(rawValue: bindable.getQueueName()), object: nil)
    }
    
    
    
    static func trigger(event: Event, payload: [String: Any]? = nil) {
        if let payload = payload {
            notificationCenter.post(name: event.asNotificationName(), object: nil, userInfo: payload)
            return
        }
        notificationCenter.post(name: event.asNotificationName(), object: nil)
    }
    
    
    static func trigger(event: Bindable, payload: [String: Any]? = nil) {
        if let payload = payload {
            notificationCenter.post(name: NSNotification.Name(rawValue: event.getQueueName()), object: nil, userInfo: payload)
            return
        }
        notificationCenter.post(name: NSNotification.Name(rawValue: event.getQueueName()), object: nil)
    }
}
