//
//  NewCourseViewController.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 16/7/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import UIKit
import FirebaseAuth

class NewGroupViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: true);
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func doneFillingNewCourseInfo(_ sender: UIBarButtonItem) {
        
        let nameIsEmpty = nameTextField.text?.isEmpty ?? true
        let descriptionIsEmpty = descriptionTextField.text?.isEmpty ?? true
        
        guard !nameIsEmpty || !descriptionIsEmpty else {
            let alert = UIAlertController(title: "Incomplete data", message: "Please fill in the name and description", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard !nameIsEmpty else {
            let alert = UIAlertController(title: "Incomplete data", message: "Please fill in the name", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            return
        }
        
        guard !descriptionIsEmpty else {
            let alert = UIAlertController(title: "Incomplete data", message: "Please fill in the description", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            return
        }
        
        let course = Course(name: nameTextField.text!,
                            description: descriptionTextField.text!)
        FirebaseManager.sharedInstance.save(value: course, path: "courses")
        self.dismiss(animated: true)
    }
    
}
