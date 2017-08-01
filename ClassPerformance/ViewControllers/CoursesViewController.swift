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

class CoursesViewController: SpinnerViewController, MyCoursesDelegate, AuthManagerDelegate {
        
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
        let authManager: AuthManager
        if let providerId = Auth.auth().currentUser?.providerData.first?.providerID {
            authManager = findAuthManager(by: providerId)
        } else {
            authManager = EmailAuthManager(delegate: self)
        }
        
        authManager.logOut() { [weak self] in
            self?.performSegue(withIdentifier: "Log Out", sender: nil)
        }
    }
    
    private func findAuthManager(by providerId: String?) -> AuthManager {
        guard let providerId = providerId else {
            return EmailAuthManager(delegate: self)
        }
        
        switch providerId {
        case "google.com":
            return GoogleAuthManager(delegate: self)
        case "twitter.com":
            return TwitterAuthManager(delegate: self)
        case "facebook.com":
            return FacebookAuthManager(delegate: self)
        default:
            return EmailAuthManager(delegate: self)
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let courseCollectionVC = segue.destination as? MyCoursesCollectionViewController {
            coursesCVC = courseCollectionVC
            coursesCVC.delegate = self
        }
    }
    
    // MARK: AuthManagerDelegate
    
    func didLogInCancel() { }
    
    func didLogInSuccess() { }
    
    func didLogInError(withMessage message: String?) {
        self.showErrorAlert(withMessage: message)
    }
    
}
