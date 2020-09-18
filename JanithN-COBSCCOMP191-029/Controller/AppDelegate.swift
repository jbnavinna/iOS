//
//  AppDelegate.swift
//  JanithN-COBSCCOMP191-029
//
//  Created by user180175 on 9/13/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval:2.0)
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        if Auth.auth().currentUser?.uid != nil {
            User.userLogStatus=true
            let userdata = Auth.auth().currentUser!.uid
            print(userdata)
            //get user type from firestore
            
            // Create a reference to the cities collection
            let db = Firestore.firestore()

            db.collection("users").whereField("uid", isEqualTo: userdata).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                        let documentData = document.data()
                        let typedata = documentData["type"]! as! String
                        print(typedata)
                        User.userType=typedata
                }
              }
            }
            
            print("log status is true++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
            
        } else {
           User.userLogStatus=false
            print("log status is false++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        }
        print(User.userLogStatus)
        print("+++++++++++++++++")
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

