//
//  SurveyScreen5VC.swift
//  JanithN-COBSCCOMP191-029
//
//  Created by user180175 on 9/16/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import Foundation
import UIKit

class SurveyScreen5VC: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
    @IBAction func noClick(_ sender: Any) {
        SurveyData.s5=false
        self.performSegue(withIdentifier: "s5", sender: nil)
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
    }
    
    
    @IBAction func yesClick(_ sender: Any) {
        SurveyData.s5=true
        self.performSegue(withIdentifier: "s5", sender: nil)
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
