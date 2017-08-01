//
//  LogInViewController.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 14/7/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import UIKit

class LogInViewController: SpinnerViewController, AuthManagerDelegate {
    
    private var authManager: AuthManager?
    
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
    
    // MARK: Social Networks
    @IBAction func logInWithFacebookDidTouch() {
        startLoading()
        authManager = FacebookAuthManager(delegate: self)
        authManager?.logIn()
    }
    
    @IBAction func logOut(segue: UIStoryboardSegue) { }

    
    @IBAction func logInWithGoogleDidTouch() {
        startLoading()
        authManager = GoogleAuthManager(delegate: self)
        authManager?.logIn()
    }
    
    @IBAction func logInWithTwitterDidTouch() {
        startLoading()
        authManager = TwitterAuthManager(delegate: self)
        authManager?.logIn()
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
        
        authManager = EmailAuthManager(delegate: self, email: emailTextField.text!, password: passwordTextField.text!)
        authManager?.logIn()
    }
    
    // MARK: AuthManagerDelegate
    
    func didLogInSuccess() {
        stopLoading()
        self.performSegue(withIdentifier: "Courses Scene", sender: nil)
    }
    
    func didLogInCancel() {
        stopLoading()
    }
    
    func didLogInError(withMessage: String?) {
        stopLoading()
        self.showErrorAlert(withMessage: withMessage)
    }
}
