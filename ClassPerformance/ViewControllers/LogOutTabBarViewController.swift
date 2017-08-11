//
//  LogOutTabBarViewController.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 10/8/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import UIKit

class LogOutTabBarViewController: UITabBarController, AuthManagerDelegate, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    // MARK: log out
    
    @IBAction func logOutDidTap(_ sender: UIBarButtonItem) {
        let authManager: AuthManager
        if let providerId = AuthManager.providerId {
            authManager = findAuthManager(by: providerId)
        } else {
            authManager = EmailAuthManager(delegate: self)
        }
        
        authManager.logOut() { [weak self] in
            self?.performSegue(withIdentifier: "Log Out", sender: nil)
        }
    }
    
    private func findAuthManager(by providerId: String?) -> AuthManager {
        guard let providerId = providerId else {
            return EmailAuthManager(delegate: self)
        }
        
        switch providerId {
        case "google.com":
            return GoogleAuthManager(delegate: self)
        case "twitter.com":
            return TwitterAuthManager(delegate: self)
        case "facebook.com":
            return FacebookAuthManager(delegate: self)
        default:
            return EmailAuthManager(delegate: self)
        }
    }
    
    // MARK: UITabBarViewControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        navigationItem.rightBarButtonItem?.target = viewController
    }
    
    // MARK: AuthManagerDelegate
    
    func didLogInCancel() { }
    
    func didLogInSuccess() { }
    
    func didLogInError(withMessage message: String?) {
        self.showErrorAlert(withMessage: message)
    }
    
}
