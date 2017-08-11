//
//  ExamsViewController.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 7/8/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import UIKit

class ExamsViewController: FirebaseViewController, TabBarIndexable {

    private weak var examsTVC: MyExamsTableViewController!
    
    var index: Int { return 1 }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        path = "exams"
        tabBarItem = UITabBarItem(title: "Exams", image: UIImage(named: "ic_exam"), tag: index)
        
        handler = fetchItems(withType: Exam.self, at: path) { [weak self] results in
            self?.examsTVC.didFetch(items: results)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.title = "Exams"
    }
    
    override func rightBarButtonDidTap(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "New Exam", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let examTableViewController = segue.destination as? MyExamsTableViewController {
            examsTVC = examTableViewController
        }
    }
    
}
