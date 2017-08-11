//
//  FirebaseViewController.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 7/8/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import UIKit

class FirebaseViewController: SpinnerViewController {
    
    private var emptyMessage: UILabel!
    var handler: UInt?
    var path: String?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tabBarController?.navigationItem.rightBarButtonItem == nil {
            tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBarButtonDidTap(_:)))
        }
        
        emptyMessage = UILabel()//(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
        emptyMessage.translatesAutoresizingMaskIntoConstraints = false
        emptyMessage.text = "You don't have any items. Tap to add a new one."
        emptyMessage.textAlignment = .center
        emptyMessage.font = UIFont .systemFont(ofSize: 50)
        emptyMessage.numberOfLines = 0
        emptyMessage.backgroundColor = UIColor.white
        
        self.view.addSubview(emptyMessage)
        self.view.bringSubview(toFront: emptyMessage)
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[view]-10-|", options: [], metrics: nil, views: ["view": emptyMessage])
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[view]-10-|", options: [], metrics: nil, views: ["view": emptyMessage])
        
        self.view.addConstraints(horizontalConstraints)
        self.view.addConstraints(verticalConstraints)
    }
    
    func rightBarButtonDidTap(_ sender: UIBarButtonItem) { }
    
    func fetchItems <T: FirebaseObservable> (withType type: T.Type, at path: String?, completion: (([T]) -> Void)? = nil) -> UInt? {
        startLoading()
        guard let user = AuthManager.currentUser else { return 0}
        
        let firebaseManager = FirebaseManager.sharedInstance;
        let handler = firebaseManager.query(path: path, type: type) { [weak self] results in
            
            if results.count == 0 {
                self?.addTapGestureRecognizer()
                self?.emptyMessage.isHidden = false
            } else {
                self?.emptyMessage.isHidden = true
                self?.removeTapGestureRecognizer()
            }
            
            if self?.isLoading ?? false {
                self?.stopLoading()
            }
            
            completion?(results)
        }
        
        return handler
    }
    
    func handleTap(_ recognizer: UITapGestureRecognizer) { rightBarButtonDidTap(UIBarButtonItem()) }
    
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
    
    deinit {
        if let handler = self.handler {
            FirebaseManager.sharedInstance.quit(observingHandler: handler, atPath: path)
        }
    }
}
