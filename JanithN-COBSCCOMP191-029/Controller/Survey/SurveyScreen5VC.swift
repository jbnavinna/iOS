//
//  SurveyScreen5VC.swift
//  JanithN-COBSCCOMP191-029
//
//  Created by user180175 on 9/16/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class SurveyScreen5VC: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
    @IBAction func noClick(_ sender: Any) {
        SurveyData.s5=false
        let s1=SurveyData.s1
        let s2=SurveyData.s2
        let s3=SurveyData.s3
        let s4=SurveyData.s4
        let s5=SurveyData.s5
        createSurvey(s1:s1,s2:s2,s3:s3,s4:s4,s5:s5)
        
    }
    
    
    @IBAction func yesClick(_ sender: Any) {
        SurveyData.s5=true
        let s1=SurveyData.s1
        let s2=SurveyData.s2
        let s3=SurveyData.s3
        let s4=SurveyData.s4
        let s5=SurveyData.s5
        createSurvey(s1:s1,s2:s2,s3:s3,s4:s4,s5:s5)
        //self.performSegue(withIdentifier: "s5", sender: nil)
    }
    
    func createSurvey(s1:Bool,s2:Bool,s3:Bool,s4:Bool,s5:Bool){
        
        //print all values
        
        print(SurveyData.s1)
        print("s1--------------------------------------------------------------")
        print(SurveyData.s2)
        print("s2--------------------------------------------------------------")
        print(SurveyData.s3)
        print("s3--------------------------------------------------------------")
        print(SurveyData.s4)
        print("s4--------------------------------------------------------------")
        print(SurveyData.s5)
        print("s5--------------------------------------------------------------")
        //create
        let userdata = Auth.auth().currentUser!.uid
        let db = Firestore.firestore()
        var documentIdString=""
        
        
        //get current date
        let formatter : DateFormatter = DateFormatter()
        formatter.dateFormat = "d/M/yy"
        let surveyDate : String = formatter.string(from:   NSDate.init(timeIntervalSinceNow: 0) as Date)
        var health=""
        var points=5
        //do you have sypmtoms?
        if s1==true {
            points=points-1
        }else if s1==false{
            points=points+1
        }
        //have you worn a mask?
        if s2==true {
            points=points+1
        }else if s2==false{
             points=points-1
        }
        //did you get exposed?
        if s3==true {
            points=points-1
        }else if s3==false{
             points=points+1
        }
        //did you interact with other?
        if s4==true {
            points=points-1
        }else if s4==false{
             points=points+1
        }
        //did you stay at home?
        if s5==true {
            points=points+1
        }else if s5==false{
             points=points-1
        }
        
        if points <= 2 {
            //high possibility
            health="high possibility"
        }
        else if points > 2 && points<7 {
            //medium possibility
            health="mid possibility"
        }
        else if points >= 7 {
            //low possibility
            health="low possibility"
        }
        User.userHealth=health
        
        print("``````````````````````````````````````````````````````````````````````````````````````````````````````````````````")
        print(health)
        print("``````````````````````````````````````````````````````````````````````````````````````````````````````````````````")

        
        
        db.collection("survey").addDocument(data: ["question1":s1,"question2":s2,"question3":s3,"question4":s4,"question5":s5,"health":health, "uid": userdata ]) { (error) in
            
            if error != nil {
                // Show error message
                print(error as Any)
            }else{
                //when the create goes right
                
                //get document id from UI to update the document from ID
                db.collection("users").whereField("uid", isEqualTo: userdata).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                            documentIdString=document.documentID
                    }
                        //update query for user update
                        db.collection("users").document(documentIdString).setData(["health":health,"surveydate":surveyDate], merge:true)
                        self.performSegue(withIdentifier: "s5", sender: nil)
                  }
                }
            }
        }
        
        
        
        

       

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
