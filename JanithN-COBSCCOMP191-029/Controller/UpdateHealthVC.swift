//
//  UpdateHealthVC.swift
//  JanithN-COBSCCOMP191-029
//
//  Created by user180175 on 9/17/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase
import CoreLocation

class UpdateHealthVC: UIViewController{
    
    @IBOutlet weak var UpdateCasesButton: UIButton!
    @IBOutlet weak var loginRequestView: UIView!
    
    @IBOutlet weak var NewNotificationButton: UIButton!
    
    @IBOutlet weak var updatedDateSurvey: UILabel!
    
    @IBOutlet weak var updatedDateHealth: UILabel!
    
    @IBOutlet weak var TempPicker: UIPickerView!
    private let dataSource = ["35°C - 37.5°C","Above 37.5°C"]
    
    @IBOutlet weak var tempLabel: UILabel!
    
    var currentLat: Double = 0
    var currentLon: Double = 0
    
    let locationManager =  CLLocationManager()
    
    var bodyTemp=""
    var documentIdString=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

          //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
          //tap.cancelsTouchesInView = false
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 20
        locationManager.requestAlwaysAuthorization()

          view.addGestureRecognizer(tap)
        if(User.userLogStatus==false)
        {
            self.loginRequestView.isHidden=false
        }
        else if(User.userLogStatus==true)
        {
            self.loginRequestView.isHidden=true
        }
        if(User.userType=="Academic Staff")
        {
            self.NewNotificationButton.isHidden=false
            self.UpdateCasesButton.isHidden=false
        }else{
            self.NewNotificationButton.isHidden=true
            self.UpdateCasesButton.isHidden=true
        }
        
        
        if Auth.auth().currentUser?.uid != nil {
            User.userLogStatus=true
            
            //setting the data for labels
            let userdata = Auth.auth().currentUser!.uid
            print(userdata)
            //get user type from firestore
            
            // Create a reference to the cities collection
            let db = Firestore.firestore()
            var temp=""
            var tempdate=""
            var surveydate=""
            db.collection("users").whereField("uid", isEqualTo: userdata).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                        let documentData = document.data()
                        temp = documentData["temp"]! as! String
                        tempdate = documentData["tempdate"]! as! String
                        surveydate = documentData["surveydate"]! as! String
                        self.updatedDateSurvey.text=surveydate
                        self.documentIdString=document.documentID
                        if(temp=="35°C - 37.5°C"){
                            self.TempPicker.selectRow(0, inComponent:0, animated:true)
                        }else if(temp=="Above 37.5°C"){
                            self.TempPicker.selectRow(1, inComponent:0, animated:true)
                        }
                }
              }
            }
            
        }else{
            User.userLogStatus=false
        }
        
        TempPicker.delegate=self
        TempPicker.dataSource=self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    @IBAction func updateTemperature(_ sender: Any) {
        if(self.bodyTemp==""){
            self.bodyTemp="35°C - 37.5°C"
        }
        
        //get current date
        let formatter : DateFormatter = DateFormatter()
        formatter.dateFormat = "d/M/yy"
        let tempDate : String = formatter.string(from:   NSDate.init(timeIntervalSinceNow: 0) as Date)
        
        //update query
        let db = Firestore.firestore()
        db.collection("users").document(documentIdString).setData(["temp":self.bodyTemp,"tempdate":tempDate], merge:true)
        
        self.tempLabel.text=bodyTemp
        self.updatedDateHealth.text=tempDate
        
        let rtDBRef = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        if currentLat == 0 && currentLon == 0 {
            let lastLocation = locationManager.location?.coordinate
            currentLat = lastLocation?.latitude ?? 10
            currentLon = lastLocation?.longitude ?? 10
        }
        
        let tempData = [
            "uid" : uid,
            "temp" : bodyTemp,
            "lat" : currentLat,
            "lon" : currentLon
        ] as [String : Any]
        
        if let uid = uid{
            rtDBRef.child("temperatureData").child(uid).setValue(tempData) {
                (error: Error?, ref: DatabaseReference) in
                if let error = error {
                    print("Tempratre data not added " + error.localizedDescription)
                } else {
                    print("Temprature data added")
                }
            }
        }
        
        
        
        
        
        let alert = UIAlertController(title: "Temperature Update Success", message: nil,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension UpdateHealthVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count}
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        return self.bodyTemp=dataSource[row]
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
}

extension UpdateHealthVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Locations changed")
        if let location = locations.last {
            self.currentLat = location.coordinate.latitude
            self.currentLon = location.coordinate.longitude
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
