//
//  CourseCellButton.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 16/7/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import UIKit

@IBDesignable
class CourseCellButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = rect.size.width / 2
        layer.borderWidth = 1.0
        layer.borderColor = self.titleLabel?.textColor.cgColor
        titleLabel?.numberOfLines = 0
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.textAlignment = .center
        
        let verticalSpacing = rect.size.height / 10
        let horizontalSpacing = rect.size.height / 10

        titleEdgeInsets.left = horizontalSpacing
        titleEdgeInsets.right = horizontalSpacing
        titleEdgeInsets.top = verticalSpacing
        titleEdgeInsets.bottom = verticalSpacing
    }
    
    override func setTitle(_ title: String?, for state: UIControlState) {
        let maxChars = Int(frame.size.width) / 3
        
        var name = title ?? ""
        if title != nil {
            if name.characters.count > maxChars {
                name = name.substring(to: name.index(name.startIndex, offsetBy: maxChars)).appending("...")
            }
        }
        
        super.setTitle(name, for: .normal)
    }
    
}
