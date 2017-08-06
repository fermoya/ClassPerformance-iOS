//
//  TwitterAuthManager.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 1/8/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import Foundation
import TwitterKit
import Firebase

class TwitterAuthManager: AuthManager {
    
    override func logIn() {
        let store = Twitter.sharedInstance().sessionStore
        if let session = store.session() {
            let credential = TwitterAuthProvider.credential(withToken: session.authToken, secret: session.authTokenSecret)
            self.signInSocialNetwork(withCredential: credential)
        } else if let viewController = delegate as? UIViewController {
            Twitter.sharedInstance().logIn(with: viewController) { [weak self] session, error in
                guard error == nil, let session = session else {
                    self?.delegate?.didLogInError(withMessage: error?.localizedDescription ?? "Unexpected error, please try again")
                    return
                }
                
                let credential = TwitterAuthProvider.credential(withToken: session.authToken, secret: session.authTokenSecret)
                self?.signInSocialNetwork(withCredential: credential)
            }
        }
    }
    
    override func logOut(_ completion: ((Void) -> Void)? = nil) {
        super.logOut() {
            let store = Twitter.sharedInstance().sessionStore
            
            if let userID = store.session()?.userID {
                store.logOutUserID(userID)
            }
            
            if let completion = completion {
                completion()
            }
        }
    }
    
}
