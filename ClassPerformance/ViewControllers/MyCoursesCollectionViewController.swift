//
//  MyCoursesCollectionViewController.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 17/7/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

private let reuseIdentifier = "Course Cell"

class MyCoursesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private var indexSelected: IndexPath?
    weak var delegate: MyCoursesDelegate?
    private var courses : [Course]?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.delegate = self
        fetchCourses()
    }
    
    private func fetchCourses() {
        if let user = AuthManager.currentUser {
            let firebaseManager = FirebaseManager.sharedInstance;
            firebaseManager.query(path: "courses", condition: "user", value: user, type: Course.self) { [weak self] results in
                self?.courses = results
                self?.delegate?.didFetchCourses(self?.courses ?? [])
                self?.collectionView?.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        if let courseCell = cell as? MyCoursesCollectionViewCell {
            courseCell.courseButton.setTitle(courses![indexPath.row].name, for: .normal)
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        let sizeOfIconItems: Float = 120
//        let spaceBetweenElements = max((Float(self.view.frame.size.width) - sizeOfIconItems * 2) / 3, 10)
//        let totalCellWidth = sizeOfIconItems * Float(self.courses?.count ?? 0) ;
//        let totalSpacingWidth = spaceBetweenElements * Float((self.courses?.count ?? 0) - 1);
//        
//        let leftInset = (self.view.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2;
//        let rightInset = leftInset;
//        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellSpacing = (collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing
        let cellWidth = (collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width
        let cellCount = CGFloat(courses?.count ?? 0)
        var inset = (collectionView.bounds.size.width - (cellCount * cellWidth) - ((cellCount - 1) * cellSpacing)) * 0.5
        inset = max(inset, 0.0);
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Course Storyboard", sender: nil)
    }
    
    // MARK: Navigation
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
}

protocol MyCoursesDelegate: class {
    func didFetchCourses(_ courses: [Course])
}
