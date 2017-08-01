//
//  GoogleAuthManager.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 1/8/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

class GoogleAuthManager: AuthManager, GIDSignInDelegate, GIDSignInUIDelegate {
    
    override init(delegate: AuthManagerDelegate) {
        super.init(delegate: delegate)
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func logIn() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            GIDSignIn.sharedInstance().signInSilently()
        } else {
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
    // MARK: GIDSignInDelegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil, let authentication = user.authentication else {
            self.delegate?.didLogInCancel()
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        self.signInSocialNetwork(withCredential: credential)
    }
    
    override func logOut(_ completion: ((Void) -> Void)? = nil) {
        super.logOut() {
            GIDSignIn.sharedInstance().signOut()
            if let completion = completion {
                completion()
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        if let presenterViewController = delegate as? UIViewController {
            presenterViewController.present(viewController, animated: true)
        }
    }
    
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        if let presenterViewController = delegate as? UIViewController {
            presenterViewController.dismiss(animated: true)
        }
    }
}
