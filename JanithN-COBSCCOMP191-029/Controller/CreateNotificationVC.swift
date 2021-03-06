//
//  CreateNotificationVC.swift
//  JanithN-COBSCCOMP191-029
//
//  Created by user180175 on 9/17/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase

class CreateNotificationVC: UIViewController{
    
    @IBOutlet weak var NotifTopic: UITextField!
    
    @IBOutlet weak var NotifSummary: UITextField!
    @IBOutlet weak var btnPublish: UIButton!
    
    @IBOutlet weak var btnDiscard: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

           //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
           //tap.cancelsTouchesInView = false

           view.addGestureRecognizer(tap)
        self.errorLabel.isHidden=true
        
        //round corners publish button
               self.btnPublish.layer.cornerRadius = 10
               self.btnPublish.clipsToBounds = true
        
        //round corners discard button
                self.btnDiscard.layer.cornerRadius = 10
                self.btnDiscard.clipsToBounds = true
   
    }
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    @IBAction func publishNotification(_ sender: Any) {
        var proceedStatus=true
        //validation
        guard let notifTopic = NotifTopic.text, NotifTopic.text?.count != 0  else {
            errorLabel.isHidden = false
            errorLabel.text = "Please fill all details"
            proceedStatus=false
            return
        }
        
        guard let notifSummary = NotifSummary.text, NotifSummary.text?.count != 0  else {
            errorLabel.isHidden = false
            errorLabel.text = "Please fill all details"
            proceedStatus=false
            return
        }
        
        
        //create
        let userdata = Auth.auth().currentUser!.uid
        let db = Firestore.firestore()
        //get current date
        let formatter : DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let notifDate : String = formatter.string(from:   NSDate.init(timeIntervalSinceNow: 0) as Date)
        

                db.collection("notifications").document("update").setData([
                    "notiftopic": notifTopic,
                    "notifsummary": notifSummary,
                    "notifdate": notifDate,
                    "uid": userdata
                    
                ]) { (error) in
                    
                    if error != nil {
                        // Show error message
                        self.errorLabel.isHidden=false
                        self.errorLabel.text="Unexpected error occured"
                    }
                    if proceedStatus==true{
                        self.performSegue(withIdentifier: "publishandgohome", sender: nil)
                    }
                }
        
        let rtDBRef = Database.database().reference()
        let notificationData = [
            "title" : notifTopic,
            "content" : notifSummary,
            "date": notifDate
        ]
        
        rtDBRef.child("notifications").child(rtDBRef.child("notifications").childByAutoId().key ?? "defaultkey").setValue(notificationData) {
            (error: Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data not saved : " + error.localizedDescription)
            } else {
                print("Data saved")
            }
        }
                
    }
    
    @IBAction func discardPost(_ sender: Any) {
       
        var status1=true
        var status2=true
        if(NotifTopic.text==""){
            status1=false
        }
        if(NotifSummary.text==""){
            status2=false
        }
        if(status1==true || status2==true){
            let alert = UIAlertController(title: "Discard Post?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Don't", style: .cancel, handler: nil))

            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                //logic
                self.performSegue(withIdentifier: "publishandgohome", sender: nil)
                
            }))
            self.present(alert, animated: true)
            
        }
        else{
            self.performSegue(withIdentifier: "publishandgohome", sender: nil)
        }
        
    }
    
   
     

     
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
