//
//  AppDelegate.swift
//  ClassPerformance
//
//  Created by Fernando Moya De Rivas on 14/7/17.
//  Copyright © 2017 Fernando Moya De Rivas. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleSignIn
import FBSDKLoginKit
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configureApp(application, didFinishLaunchingWithOptions: launchOptions)
        checkAutoLogin()
        return true
    }

    func configureApp(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        // Firebase configuration
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        // Google-Sign-In configuration
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        // Facebook login configuration
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Twitter login configuration
        let keys = readPlistFile(withName: "keys")
        let consumerKey = keys?["twitter-consumer-key"]
        let consumerSecret = keys?["twitter-consumer-secret"]
        
        if let consumerKey = consumerKey, let consumerSecret = consumerSecret {
            Twitter.sharedInstance().start(withConsumerKey: consumerKey, consumerSecret: consumerSecret)
        }
    }
    
    func checkAutoLogin() {
        if Auth.auth().currentUser != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let logInVC = storyboard.instantiateViewController(withIdentifier: "LogInViewController")
            let coursesVC = storyboard.instantiateViewController(withIdentifier: "CoursesViewController")
            let navigationController = UINavigationController()
            navigationController.pushViewController(logInVC, animated: false)
            navigationController.pushViewController(coursesVC, animated: false)
            self.window?.rootViewController = navigationController
        }
    }
    
    func readPlistFile(withName name: String) -> [String : String]? {
        var dictionary: [String : String]?
        if let path = Bundle.main.path(forResource: name, ofType: "plist") {
            dictionary = NSDictionary(contentsOfFile: path) as? [String : String]
        }
        return dictionary
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme?.hasPrefix("fb") ?? false {
            return FBSDKApplicationDelegate.sharedInstance().application(app,
                                                                         open: url,
                                                                         sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                                         annotation: [:])
        } else if url.scheme?.contains("twitter") ?? false {
            return Twitter.sharedInstance().application(app, open: url, options: options)
        } else {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

