//
//  SignUpViewController.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 18/7/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: SpinnerViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confimPasswordTextField: UITextField!
    
    @IBAction func signUpDidTouch() {
        //TODO: security, pass and email valid
        
        guard !emailTextField.text!.isEmpty, !passwordTextField.text!.isEmpty, !confimPasswordTextField.text!.isEmpty else {
            self.showErrorAlert(withMessage: "The email and password are not valid")
            return
        }
        
        guard passwordTextField.text == confimPasswordTextField.text else {
            self.showErrorAlert(withMessage: "Password and confirmation do not match")
            return
        }
        
        self.startLoading()
        Auth.auth().createUser(withEmail: emailTextField.text!,
                           password: passwordTextField.text!) { [weak self] user, error in
                            self?.stopLoading()
                            guard error == nil else {
                                self?.showErrorAlert(withMessage: error?.localizedDescription)
                                return
                            }
                            
                            self?.performSegue(withIdentifier: "Courses Scene", sender: nil)
                            
        }
    }
    
}
