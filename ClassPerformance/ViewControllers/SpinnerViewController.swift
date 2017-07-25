//
//  SpinnerViewController.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 24/7/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import UIKit

class SpinnerViewController: UIViewController {

    private var spinnerView: SpinnerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        awakeSpinnerView()
    }
    
    func awakeSpinnerView() {
        spinnerView = UINib(nibName: "SpinnerView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! SpinnerView
        spinnerView.isHidden = true
        self.view.addSubview(spinnerView)
        
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[spinnerView]-0-|", options: [], metrics: nil, views: ["spinnerView": spinnerView])
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[spinnerView]-0-|", options: [], metrics: nil, views: ["spinnerView": spinnerView])
        self.view.addConstraints(verticalConstraints)
        self.view.addConstraints(horizontalConstraints)
    }
    
    func startLoading() {
        spinnerView.startAnimating()
    }
    
    func stopLoading() {
        spinnerView.stopAnimating()
    }

}
