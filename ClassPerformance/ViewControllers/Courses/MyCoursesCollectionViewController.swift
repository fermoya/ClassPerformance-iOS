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

class MyCoursesCollectionViewController: UICollectionViewController, FirebaseObserver, UICollectionViewDelegateFlowLayout {
    
    typealias T = Course
    
    private var indexSelected: IndexPath?
    private var courses : [Course]?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.delegate = self
    }
    
    func didFetch(items: [Course]) {
        self.courses = items
        self.collectionView?.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellSpacing = (collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing
        let cellWidth = (collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width
        let cellCount = CGFloat(courses?.count ?? 0)
        
        let collectionViewWidth = collectionView.bounds.size.width
        let totalCellWidth = cellCount * cellWidth
        
        var inset: CGFloat
        var count: CGFloat = 1
        repeat {
            inset = (collectionViewWidth - (totalCellWidth / count) - (((cellCount - 1) / count) * cellSpacing)) * 0.5
            count = count + 1
        } while (inset < 0)
        
        inset = max(inset, 0.0);
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: change
//        performSegue(withIdentifier: "Course Storyboard", sender: nil)
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
