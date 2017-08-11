//
//  Course.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 16/7/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Course: FirebaseObservable {
    
    var id: String {
        get {
            return name
        }
    }

    var name: String
    var description: String
    var ref: DatabaseReference?
    var key: String?
    
    init?(with snapshot: DataSnapshot?) {
        guard let snapshot = snapshot else { return nil }
        
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        description = snapshotValue["description"] as! String
        ref = snapshot.ref
    }
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "description": description
        ]
    }
}
