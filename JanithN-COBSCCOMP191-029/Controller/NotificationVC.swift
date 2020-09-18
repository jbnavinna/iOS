//
//  NotificationVC.swift
//  JanithN-COBSCCOMP191-029
//
//  Created by user180175 on 9/17/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore


class NotificationVC: UIViewController{
    
    @IBOutlet weak var notifTitle: UILabel!
    
    @IBOutlet weak var notifBody: UITextView!
    
    var notiftitle=""
    var notifsummary=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()

        //set notification
          let notiRef = db.collection("notifications").document("update")

                   notiRef.getDocument { (document, error) in
                       if let document = document, document.exists {
                           let documentData = document.data()
                           
                           self.notiftitle = documentData?["notiftopic"]! as! String
                        self.notifsummary = documentData?["notifsummary"]! as! String
                        
                        print("Summary",self.notifsummary)



                        self.notifTitle.text=self.notiftitle
                        self.notifBody.text=self.notifsummary
                  
                       } else {
                           print("Document does not exist")
                       }
                   }
          
   
    }
    
    @IBAction func viewMessage(_ sender: UIButton) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
