//
//  FirebaseObserver.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 7/8/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import Foundation
protocol FirebaseObserver: class {
    associatedtype T: FirebaseObservable
    func didFetch(items: [T])
}
