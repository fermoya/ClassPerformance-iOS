//
//  RoundButton.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 19/7/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {

    @IBInspectable var cornerRadius: Float = 5 { didSet { self.setNeedsDisplay() } }
    @IBInspectable var borderWidth: Float = 1 { didSet { self.setNeedsDisplay() } }
    @IBInspectable var borderColor: UIColor = UIColor.blue { didSet { self.setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        super.draw(rect)
    }

}
