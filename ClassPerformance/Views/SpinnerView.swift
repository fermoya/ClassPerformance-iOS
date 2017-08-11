//
//  SpinnerView.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 23/7/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import UIKit

@IBDesignable
class SpinnerView: UIView {

    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    func startAnimating() {
        activityIndicatorView.startAnimating()
        isHidden = false
    }
    
    func stopAnimating() {
        activityIndicatorView.stopAnimating()
        isHidden = true
    }
    
    var isAnimating: Bool {
        return activityIndicatorView.isAnimating
    }
}
