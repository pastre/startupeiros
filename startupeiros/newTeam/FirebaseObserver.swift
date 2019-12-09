//
//  FirebaseObserver.swift
//  startupeiros
//
//  Created by Maykon Meneghel on 09/12/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol FirebaseObserverDelegate {
    func onAdded(_ snap: DataSnapshot)
    func onChanged(_ snap: DataSnapshot)
    func onRemoved(_ snap: DataSnapshot)
}
class FirebaseObserver {
    
    internal init(delegate: FirebaseObserverDelegate?, reference: DatabaseReference?) {
        self.delegate = delegate
        self.reference = reference
    }
    
    
    var delegate: FirebaseObserverDelegate!
    var reference: DatabaseReference!
    
    
    func setup() {
        self.reference.observe(.childAdded) { (snap) in
            self.delegate.onAdded(snap)
        }
        
        self.reference.observe(.childChanged) { (snap) in
            self.delegate.onChanged(snap)
        }
        
        self.reference.observe(.childRemoved) { (snap) in
            self.delegate.onRemoved(snap)
        }
    }
    
    func invalidate() {
        self.reference.removeAllObservers()
    }
}
