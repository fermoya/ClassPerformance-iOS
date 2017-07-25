//
//  CoursesViewController.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 16/7/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleSignIn
import FBSDKLoginKit
import TwitterKit

class CoursesViewController: SpinnerViewController, MyCoursesDelegate {
        
    @IBOutlet weak var emptyMessage: UILabel!
    @IBOutlet weak var coursesContainer: UIView!
    
    var newCourse: Course?
    private var coursesCVC: MyCoursesCollectionViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading()
        navigationItem.setHidesBackButton(true, animated: true);
    }
    
    @IBAction func newCourse(_ sender: Any) {
        performSegue(withIdentifier: "New Course", sender: nil)
    }
    
    func handleTap(_ recognizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: "New Course", sender: nil)
    }
    
    @IBAction func addCourse(segue: UIStoryboardSegue) {
        if let course = newCourse {
            coursesCVC.addCourse(course)
        }
    }
    
    // MARK: MyCourseDelegate
    func didFetchCourses(_ courses: [Course]) {
        if courses.count == 0 {
            addTapGestureRecognizer()
            self.emptyMessage.isHidden = false
        } else {
            self.emptyMessage.isHidden = true
            removeTapGestureRecognizer()
        }
        
        stopLoading()
    }
    
    func addTapGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    func removeTapGestureRecognizer() {
        if let gestureRecognizers = self.view.gestureRecognizers {
            for gestureRecognizer in gestureRecognizers {
                self.view.removeGestureRecognizer(gestureRecognizer)
            }
        }
    }
    
    // MARK: log out
    
    @IBAction func logOutDidTap(_ sender: UIBarButtonItem) {
        let providerId = Auth.auth().currentUser?.providerData.first?.providerID
        if logOutFromFirebase() {
            logOut(fromProvider: providerId)
            self.performSegue(withIdentifier: "Log Out", sender: nil)
        }
    }
    
    func logOutFromFirebase() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch let error as NSError {
            self.showErrorAlert(withMessage: error.localizedDescription)
            return false
        }
    }
    
    func logOut(fromProvider providerId: String?) {
        if let providerId = providerId {
            switch providerId {
            case "google.com":
                logOutWithGoogle()
            case "twitter.com":
                logOutWithTwitter()
            case "facebook.com":
                logOutWithFacebook()
            default:
                break
            }
        }
    }
    
    func logOutWithFacebook() {
        FBSDKLoginManager().logOut()
    }
    
    func logOutWithGoogle() {
        GIDSignIn.sharedInstance().signOut()
    }
    
    func logOutWithTwitter() {
        let store = Twitter.sharedInstance().sessionStore
        
        if let userID = store.session()?.userID {
            store.logOutUserID(userID)
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let courseCollectionVC = segue.destination as? MyCoursesCollectionViewController {
            coursesCVC = courseCollectionVC
            coursesCVC.delegate = self
        }
    }
    
}
