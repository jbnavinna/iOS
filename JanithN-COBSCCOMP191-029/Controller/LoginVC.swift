//
//  LoginVC.swift
//  JanithN-COBSCCOMP191-029
//
//  Created by user180175 on 9/14/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class LoginVC:UIViewController{
    
    @IBOutlet weak var EmailAddress: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var signIn: UIButton!
    
    @IBOutlet weak var btnRegister: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorLabel.isHidden=true
        
            //round corners sign in button
            self.signIn.layer.cornerRadius = 10
            self.signIn.clipsToBounds = true
        
            //round corners register button
            self.btnRegister.layer.cornerRadius = 10
            self.btnRegister.clipsToBounds = true
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
        
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signInNow(_ sender: Any) {
        var status=true
        guard let email = EmailAddress.text, EmailAddress.text?.count != 0  else {
            errorLabel.isHidden = false
            errorLabel.text = "Please enter your Email"
            return
        }
        
        guard let password = Password.text, Password.text?.count != 0  else {
            errorLabel.isHidden = false
            errorLabel.text = "Please enter your Password"
            return
        }
        
        if Regex.isValidEmail(emailID: email) == false{
            errorLabel.isHidden = false
            EmailAddress.text=""
            errorLabel.text = "Please enter valid email address"
            status=false
        }
        if Regex.isPasswordValid(password: password) == false{
            errorLabel.isHidden = false
            Password.text=""
            errorLabel.text = "Invalid Password!"
            status=false
        }
        
        if(status==true){
            errorLabel.isHidden=true
            
              // Signing in the user
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.errorLabel.text = "Invalid credentials"
                User.userLogStatus=false
                print("Login unsuccessful")
                print(User.userLogStatus)
            }else{
                User.userLogStatus=true
                print("Logged in Successfully")
                print(User.userLogStatus)
                //get user type
                
                
                
                let db = Firestore.firestore()
                let userdata = Auth.auth().currentUser!.uid  //getting user id
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
                        self.performSegue(withIdentifier: "loginToHome", sender: nil)
                  }
                }
                
                
                
                
            }
        }
            
        }
        
        
    }
   
}
