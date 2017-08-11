//
//  CoursesViewController.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 16/7/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import TwitterKit

class CoursesViewController: FirebaseViewController, TabBarIndexable {
    
    typealias T = Course
    private weak var coursesCVC: MyCoursesCollectionViewController!
    
    var index: Int { return 0 }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        path = "courses"
        navigationItem.setHidesBackButton(true, animated: true);

        tabBarItem = UITabBarItem(title: "Courses", image: UIImage(named: "ic_school"), tag: index)
        self.tabBarController?.selectedIndex = 0
        
        handler = fetchItems(withType: Course.self, at: path) { [weak self] results in
            self?.coursesCVC.didFetch(items: results)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.title = "Courses"
    }
    
    override func rightBarButtonDidTap(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "New Course", sender: nil)
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let courseCollectionVC = segue.destination as? MyCoursesCollectionViewController {
            coursesCVC = courseCollectionVC
        }
    }
    
}
