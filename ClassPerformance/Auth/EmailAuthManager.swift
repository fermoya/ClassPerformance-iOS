//
//  EmailAuthManager.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 1/8/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import Foundation
import Firebase

class EmailAuthManager: AuthManager {
    
    private var email: String
    private var password: String
    
    init(delegate: AuthManagerDelegate, email: String = "", password: String = "") {
        self.email = email
        self.password = password
        super.init(delegate: delegate)
    }
    
    override func logIn() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            guard error == nil else {
                self?.delegate?.didLogInError(withMessage: error?.localizedDescription)
                return
            }
            
            self?.delegate?.didLogInSuccess()
        }
    }
    
    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) {
            [weak self] user, error in
            
            guard error == nil else {
                self?.delegate?.didLogInError(withMessage: error?.localizedDescription)
                return
            }
            
            self?.delegate?.didLogInSuccess()
        }
    }
    
}
