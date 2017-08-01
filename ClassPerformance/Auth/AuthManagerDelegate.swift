//
//  AuthManagerDelegate.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 1/8/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import Foundation
protocol AuthManagerDelegate: class {
    
    func didLogInSuccess()
    func didLogInCancel()
    func didLogInError(withMessage message: String?)
    
}
