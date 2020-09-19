//
//  UpdateProfileVC.swift
//  JanithN-COBSCCOMP191-029
//
//  Created by user180175 on 9/17/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class UpdateProfileVC: UIViewController{
    
    @IBOutlet weak var FirstNameText: UITextField!
    
    @IBOutlet weak var LastNameText: UITextField!
    
    @IBOutlet weak var IndexText: UITextField!
    
    @IBOutlet weak var CountryPicker: UIPickerView!
    private let dataSource = ["Sri Lanka","United Kingdom"]
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    var country=""
    var documentIdString=""
    var index=""
    var userFirstName=""
    var userLastName=""
    var userIndex=""
    var countrySelected=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(User.userType=="Student"){
                   IndexText.placeholder="Enter Student Id"
               }else{
                   IndexText.placeholder="Enter Work Id"
               }
        
        ErrorLabel.isHidden = true
        
        CountryPicker.delegate=self
        CountryPicker.dataSource=self
        
        if Auth.auth().currentUser?.uid != nil {
            User.userLogStatus=true
            //setting the data for textfields
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
                        self.userFirstName = documentData["firstname"]! as! String
                        self.userLastName = documentData["lastname"]! as! String
                        self.userIndex = documentData["index"]! as! String
                        self.countrySelected=documentData["country"]! as! String
                        self.FirstNameText.text=self.userFirstName
                        self.LastNameText.text=self.userLastName
                        self.IndexText.text=self.userIndex
                        self.documentIdString=document.documentID
                        
                        if(self.countrySelected=="Sri Lanka"){
                            self.CountryPicker.selectRow(0, inComponent:0, animated:true)
                        }else if(self.countrySelected=="United Kingdom"){
                            self.CountryPicker.selectRow(1, inComponent:0, animated:true)
                        }
                }
              }
            }
            
        }else{
            User.userLogStatus=false
        }
        
   
    }
    
    @IBAction func updateNow(_ sender: Any) {
        guard let fName = FirstNameText.text, FirstNameText.text?.count != 0  else {
            ErrorLabel.isHidden = false
            ErrorLabel.text = "Please fill all details"
            return
        }
        
        guard let lName = LastNameText.text, LastNameText.text?.count != 0  else {
            ErrorLabel.isHidden = false
            ErrorLabel.text = "Please fill all details"
            return
        }
       
        guard let _ = IndexText.text, IndexText.text?.count != 0  else {
              ErrorLabel.isHidden = false
              ErrorLabel.text = "Please fill all details"
              return
          }
        
        if (country == "") {
            country="Sri Lanka"
        }
        ErrorLabel.isHidden=true
        
        //update query
        let db = Firestore.firestore()
        db.collection("users").document(documentIdString).setData(["firstname":fName,"lastname":lName,"index":index,"country":country], merge:true)
        
        
        let alert = UIAlertController(title: "Profile Update Success", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension UpdateProfileVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count}
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        return self.country=dataSource[row]
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
}
