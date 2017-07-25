//
//  ViewController+ErrorAlert.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 19/7/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showErrorAlert(withMessage message: String?) {
        let alert = UIAlertController(title: "Error", message: message ?? "Unexpected error, please try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
