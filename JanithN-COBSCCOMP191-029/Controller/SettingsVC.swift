//
//  SettingsVC.swift
//  JanithN-COBSCCOMP191-029
//
//  Created by user180175 on 9/17/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsVC: UIViewController {
    
    @IBOutlet weak var ProfileUpdateButton: UIButton!
    
    @IBOutlet weak var LogoutButton: UIButton!
    
    @IBOutlet weak var signOutErrorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signOutErrorLabel.isHidden=true
        
        if(User.userLogStatus==false){
            self.ProfileUpdateButton.isHidden=true
            self.LogoutButton.isHidden=true
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func profileUpdate(_ sender: Any) {
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            User.userLogStatus=false
            performSegue(withIdentifier: "logoutToHome", sender: nil)
            
            /*let vc = HomeVC()
            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            self.present(vc, animated: true, completion: nil)*/
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            self.signOutErrorLabel.isHidden=false
            self.signOutErrorLabel.text="Error: couldn't sign-out"
        }
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
