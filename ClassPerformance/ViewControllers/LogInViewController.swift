//
//  LogInViewController.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 14/7/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import TwitterKit

class LogInViewController: SpinnerViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var invalidDataMessageLabel: UILabel! {
        didSet {
            self.invalidDataMessageLabel.text = nil
        }
    }
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            let eyeIcon = UIButton(type: .roundedRect)
            eyeIcon.frame = iconRect
            eyeIcon.addTarget(self, action: #selector(eyeIconDidTouch), for: .touchUpInside)
            eyeIcon.setImage(UIImage(named: "ic_visibility"), for: .normal)
            self.passwordTextField.rightView = eyeIcon
            self.passwordTextField.rightViewMode = .always
        }
    }
    
    // MARK: Properties
    private var iconRect: CGRect {
        let parentWidth = Int(self.passwordTextField.frame.size.width)
        let parentHeight = Int(self.passwordTextField.frame.size.height)
        let width = parentHeight - 2 * iconMargin
        let height = width
        let x = parentWidth - width - 2 * iconMargin
        let y = parentHeight - iconMargin
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    private let iconMargin = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    // MARK: Social Networks
    @IBAction func logInWithFacebookDidTouch() {
        startLoading()
        if let accessToken = FBSDKAccessToken.current() {
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            self.signInSocialNetwork(withCredential: credential)
        } else {
            let manager = FBSDKLoginManager()
            manager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { [weak self ] result, error in
                guard error == nil else {
                    self?.stopLoading()
                    self?.showErrorAlert(withMessage: error?.localizedDescription ?? "Unexpected error, please try again")
                    return
                }
                
                if !result!.isCancelled {
                    let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                    self?.signInSocialNetwork(withCredential: credential)
                }
                
                self?.stopLoading()
            }
        }
    }
    
    @IBAction func logOut(segue: UIStoryboardSegue) { }

    
    @IBAction func logInWithGoogleDidTouch() {
        startLoading()
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            GIDSignIn.sharedInstance().signInSilently()
        } else {
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
    @IBAction func logInWithTwitterDidTouch() {
        startLoading()
        let store = Twitter.sharedInstance().sessionStore
        if let session = store.session() {
            let credential = TwitterAuthProvider.credential(withToken: session.authToken, secret: session.authTokenSecret)
            self.signInSocialNetwork(withCredential: credential)
        } else {
            Twitter.sharedInstance().logIn(with: self) { [weak self] session, error in
                guard error == nil, let session = session else {
                    self?.stopLoading()
                    self?.showErrorAlert(withMessage: error?.localizedDescription ?? "Unexpected error, please try again")
                    return
                }
                
                let credential = TwitterAuthProvider.credential(withToken: session.authToken, secret: session.authTokenSecret)
                self?.signInSocialNetwork(withCredential: credential)
            }
        }
    }

    // MARK: Button Actions
    func eyeIconDidTouch() {
        guard let eyeIcon = passwordTextField.rightView as? UIButton else { return }
        
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        if passwordTextField.isSecureTextEntry {
            eyeIcon.setImage(UIImage(named: "ic_visibility"), for: .normal)
        } else {
            eyeIcon.setImage(UIImage(named: "ic_visibility_off"), for: .normal)
        }
    }
    
    @IBAction func logInWithEmailDidTouch() {
        guard !emailTextField.text!.isEmpty, !passwordTextField.text!.isEmpty else {
            self.invalidDataMessageLabel.text = "Invalid data"
            return
        }
        
        startLoading()
        self.invalidDataMessageLabel.text = nil
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] user, error in
            self?.stopLoading()
            guard error == nil else {
                self?.showErrorAlert(withMessage: error?.localizedDescription)
                return
            }
            
            self?.performSegue(withIdentifier: "Courses Scene", sender: nil)
        }
    }
    
    // MARK: GIDSignInDelegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil, let authentication = user.authentication else {
            stopLoading()
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
        self.signInSocialNetwork(withCredential: credential)
    }
    
    // MARK: Utils
    func signInSocialNetwork(withCredential credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { [weak self] user, error in
            self?.stopLoading()
            guard error == nil else {
                self?.showErrorAlert(withMessage: error?.localizedDescription)
                return
            }
            
            self?.performSegue(withIdentifier: "Courses Scene", sender: nil)
        }
    }
}
