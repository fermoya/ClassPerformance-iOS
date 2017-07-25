//
//  MyCoursesCollectionViewCell.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 17/7/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import UIKit

class MyCoursesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var courseButton: CourseCellButton! { didSet { self.courseButton.isUserInteractionEnabled = false } }
}
