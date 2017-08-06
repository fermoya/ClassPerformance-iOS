//
//  AuthManager.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 1/8/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import Foundation
import Firebase
//import GoogleSignIn
//import FBSDKLoginKit
//import TwitterKit

class AuthManager: NSObject {
    
    weak var delegate: AuthManagerDelegate?
    
    static var currentUser: String? {
        return Auth.auth().currentUser?.uid
    }
    
    init(delegate: AuthManagerDelegate) {
        self.delegate = delegate;
    }

    func logIn() {}
    
    func signInSocialNetwork(withCredential credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { [weak self] user, error in
            guard error == nil else {
                self?.delegate?.didLogInError(withMessage: error?.localizedDescription)
                return
            }
            
            self?.delegate?.didLogInSuccess();
        }
    }
    
    func logOut(_ completion: ((Void) -> Void)? = nil) {
        do {
            try Auth.auth().signOut()
            if let completion = completion {
                completion()
            }
        } catch let error as NSError {
            self.delegate?.didLogInError(withMessage: error.localizedDescription)
        }
    }

}
