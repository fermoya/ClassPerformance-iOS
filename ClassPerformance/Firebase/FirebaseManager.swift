//
//  FirebaseManager.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 1/8/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseManager {
    
    private let ref: DatabaseReference
    static let sharedInstance = FirebaseManager()
    
    private init() {
        let user = AuthManager.currentUser!
        self.ref = Database.database().reference(withPath: user)
    }
    
    func query <T: FirebaseObservable> (path: String? = nil,
//               condition: String? = nil,
//               value: String? = nil,
               orderBy: String? = nil,
               type: T.Type,
               completion: (([T]) -> Void)? = nil) -> UInt? {
        
        var reference = ref
        if let path = path {
            reference = reference.child(path)
        }
      
        var handler: UInt?
        if let orderBy = orderBy {
            handler = reference.queryOrdered(byChild: orderBy).observe(.value, with: { [weak self] snapshot in
                self?.handle(response: snapshot, ofType: type, withCompletion: completion)
            })
        } else {
            handler = reference.observe(.value, with: { [weak self]
                snapshot in self?.handle(response: snapshot, ofType: type, withCompletion: completion)
            })
        }
        
        return handler
    }
    
    func handle <T: FirebaseObservable> (response snapshot: DataSnapshot, ofType type: T.Type, withCompletion completion: (([T]) -> Void)? = nil) {
        var results: [T] = []
        for item in snapshot.children {
            if let result = type.init(with: item as? DataSnapshot) {
                results.append(result)
            }
        }
        
        if let completion = completion {
            completion(results)
        }
    }
    
    func save <T: FirebaseObservable> (value: T, path: String? = nil) {
        var reference = ref
        if let path = path {
            reference = reference.child(path)
        }
        reference.child(value.id).setValue(value.toAnyObject())
    }
    
    func quit(observingHandler handler: UInt, atPath path: String? = nil) {
        var reference = ref
        if let path = path {
            reference = reference.child(path)
        }
        
        reference.removeObserver(withHandle: handler)
    }
    
}
