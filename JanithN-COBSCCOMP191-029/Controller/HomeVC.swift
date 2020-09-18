
//
//  HomeVC.swift
//  JanithN-COBSCCOMP191-029
//
//  Created by user180175 on 9/13/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import UIKit
import Foundation

import Firebase
import FirebaseAuth
import FirebaseFirestore



class HomeVC: UIViewController{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var formStackView: UIStackView!
        
    @IBOutlet weak var notifBody:
        UILabel!
    
    @IBOutlet weak var lblInfected:
        UILabel!
    
    @IBOutlet weak var lblDeaths:
        UILabel!
    
    @IBOutlet weak var lblRecovered:
        UILabel!
    
    @IBOutlet weak var lblDate:
        UILabel!
    @IBOutlet weak var midView: UIView!
    
    var infected=""
    var deaths=""
    var recovered=""
    var date=""
     var notifSummary=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //round corners
//        self.midView.layer.cornerRadius = self.midView.frame.size.width / 2
        self.midView.layer.cornerRadius = 10


        self.midView.clipsToBounds = true
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false;
               
               self.scrollView.addSubview(formStackView)
               
               self.formStackView.translatesAutoresizingMaskIntoConstraints=false
               
               self.formStackView.alignment = .fill
               self.formStackView.distribution = .fill
               formStackView.axis = .vertical
               formStackView.spacing = 0
               
               self.formStackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor,constant: 0).isActive=true
               self.formStackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor,constant: 0).isActive=true
               
               self.formStackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor,constant: 20).isActive=true
               self.formStackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive=true
               
               formStackView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
               
       
        //self.formStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive=true
        
         let db = Firestore.firestore()

            //set cases count
                let docRef = db.collection("cases").document("update")

                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let documentData = document.data()
                        
                        self.infected = documentData?["infected"]! as! String
                        self.deaths = documentData?["deaths"]! as! String
                        self.recovered = documentData?["recovered"]! as! String
                        self.date = documentData?["casedate"]! as! String


                        self.lblInfected.text=self.infected
                        self.lblDeaths.text=self.deaths
                        self.lblRecovered.text=self.recovered
                        self.lblDate.text=("Updated: "+self.date)
                        
                        
                    } else {
                        print("Document does not exist")
                    }
                }
        
        //set notification
        let notiRef = db.collection("notifications").document("update")

                 notiRef.getDocument { (document, error) in
                     if let document = document, document.exists {
                         let documentData = document.data()
                         
                         self.notifSummary = documentData?["notiftopic"]! as! String

                         self.notifBody.text=self.notifSummary
                
                     } else {
                         print("Document does not exist")
                     }
                 }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

