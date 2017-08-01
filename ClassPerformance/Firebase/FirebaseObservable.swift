//
//  FirebaseObservable.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 1/8/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol FirebaseObservable {
    init?(with snapshot: DataSnapshot?)
    func toAnyObject() -> Any
}
