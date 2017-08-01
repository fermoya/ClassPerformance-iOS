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
        self.ref = Database.database().reference()
    }
    
    func query <T: FirebaseObservable> (path: String? = nil,
               condition: String,
               value: String,
               type: T.Type,
               completion: (([T]) -> Void)? = nil) {
        
        var reference = ref
        if let path = path {
            reference = reference.child(path)
        }
        
        reference.queryOrdered(byChild: condition).queryEqual(toValue: value).observe(.value, with: { snapshot in

            var results: [T] = []
            for item in snapshot.children {
                if let result = type.init(with: item as? DataSnapshot) {
                    results.append(result)
                }
                
            }
            
            if let completion = completion {
                completion(results)
            }
        })
    }
//    
//    func save <T: FirebaseObservable> (value: T, path: String) {
//        let courseRef = ref.child(course.name)
//        courseRef.setValue(course.toAnyObject())
//    }
    
}
