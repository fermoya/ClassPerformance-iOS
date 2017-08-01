//
//  FacebookAuthManager.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 1/8/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit

class FacebookAuthManager: AuthManager {
    
    override func logIn() {
        if let accessToken = FBSDKAccessToken.current() {
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            self.signInSocialNetwork(withCredential: credential)
        } else if let viewController = delegate as? UIViewController {
            let manager = FBSDKLoginManager()
            manager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: viewController) {
                [weak self] result, error in
                
                guard error == nil else {
                    self?.delegate?.didLogInError(withMessage: error?.localizedDescription ?? "Unexpected error, please try again")
                    return
                }
                
                if result!.isCancelled {
                    self?.delegate?.didLogInCancel()
                } else {
                    let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                    self?.signInSocialNetwork(withCredential: credential)
                }
                
            }
        }
    }
    
    override func logOut(_ completion: ((Void) -> Void)? = nil) {
        super.logOut() {
            FBSDKLoginManager().logOut()
            if let completion = completion {
                completion()
            }
        }
    }
    
}
