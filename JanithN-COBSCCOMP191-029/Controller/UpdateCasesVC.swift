//
//  UpdateCasesVC.swift
//  JanithN-COBSCCOMP191-029
//
//  Created by user180175 on 9/17/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

class UpdateCasesVC: UIViewController{
    
    @IBOutlet weak var InfectedCount: UITextField!
    @IBOutlet weak var DeathCount: UITextField!
    @IBOutlet weak var RecoveredCount: UITextField!

    @IBOutlet weak var errorLabel: UILabel!
    
    var infected=""
    var deaths=""
    var recovered=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

         //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
         //tap.cancelsTouchesInView = false

         view.addGestureRecognizer(tap)
        
        self.errorLabel.isHidden=true
        
        let db = Firestore.firestore()

        
        let docRef = db.collection("cases").document("update")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let documentData = document.data()
                
                self.infected = documentData?["infected"]! as! String
                self.deaths = documentData?["deaths"]! as! String
                self.recovered = documentData?["recovered"]! as! String

                self.InfectedCount.text=self.infected
                self.DeathCount.text=self.deaths
                self.RecoveredCount.text=self.recovered


//                print("INFECTED",self.infected)

                
                
            } else {
                print("Document does not exist")
            }
        }
    }
   
    
    @objc func dismissKeyboard() {
         //Causes the view (or one of its embedded text fields) to resign the first responder status.
         view.endEditing(true)
     }
    @IBAction func updateCase(_ sender: Any) {
        var proceedStatus=true
                //validation
                guard let infected = InfectedCount.text, InfectedCount.text?.count != 0  else {
                    errorLabel.isHidden = false
                    errorLabel.text = "Please fill all details"
                    proceedStatus=false
                    return
                }
                
                guard let deaths = DeathCount.text, DeathCount.text?.count != 0  else {
                    errorLabel.isHidden = false
                    errorLabel.text = "Please fill all details"
                    proceedStatus=false
                    return
                }
                
                guard let recovered = RecoveredCount.text, RecoveredCount.text?.count != 0  else {
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
                let caseDate : String = formatter.string(from:   NSDate.init(timeIntervalSinceNow: 0) as Date)
                
                db.collection("cases").document("update").setData([
                    "infected": infected,
                    "deaths": deaths,
                    "recovered": recovered,
                    "casedate": caseDate,
                    "uid": userdata
                    
                ]) { (error) in
                    
                    if error != nil {
                        // Show error message
                        self.errorLabel.isHidden=false
                        self.errorLabel.text="Unexpected error occured"
                    }
                    if proceedStatus==true{
                        self.performSegue(withIdentifier: "gohome", sender: nil)
                    }
                }
                
    }

    
    @IBAction func discardPost(_ sender: Any) {
       
        var status1=true
        var status2=true
        var status3=true
        if(InfectedCount.text==""){
            status1=false
        }
        if(DeathCount.text==""){
            status2=false
        }
        if(RecoveredCount.text==""){
            status3=false
        }
        if(status1==true || status2==true || status3==true){
            let alert = UIAlertController(title: "Discard Post?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Don't", style: .cancel, handler: nil))

            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                //logic
                self.performSegue(withIdentifier: "gohome", sender: nil)
                
            }))
            self.present(alert, animated: true)
            
        }
        else{
            self.performSegue(withIdentifier: "gohome", sender: nil)
        }
        
    }
}

