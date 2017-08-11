//
//  NewExamViewController.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 11/8/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import UIKit

class NewExamViewController: SpinnerViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    private var handler: UInt?
    private var courses: [Course]?
    
    @IBOutlet weak var examNameTextField: UITextField!
    @IBOutlet weak var coursePicker: UIPickerView! {
        didSet {
            coursePicker.delegate = self
            coursePicker.dataSource = self
        }
    }
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func cancelDidTap(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func doneDidTap(_ sender: UIBarButtonItem) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading()

        let firebaseManager = FirebaseManager.sharedInstance;
        handler = firebaseManager.query(path: "courses", type: Course.self) { [weak self] results in
            
            if results.count == 0 {
                self?.datePicker.isHidden = true
                self?.coursePicker.isHidden = true
            } else {
                self?.courses = results
                self?.coursePicker.reloadAllComponents()
            }
            
            if self?.isLoading ?? false {
                self?.stopLoading()
            }
            
            if let handler = self?.handler {
                FirebaseManager.sharedInstance.quit(observingHandler: handler)
            }
        }
        
    }
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return courses?.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return courses?[row].name ?? ""
    }
}
