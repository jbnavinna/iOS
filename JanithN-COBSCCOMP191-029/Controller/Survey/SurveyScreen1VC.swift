//
//  surveyVC.swift
//  JanithN-COBSCCOMP191-029
//
//  Created by user180175 on 9/15/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import Foundation
import UIKit

class SurveyScreen1VC: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    @IBAction func noClick(_ sender: Any) {
        SurveyData.s1=false
        self.performSegue(withIdentifier: "s1", sender: nil)
    }
    @IBAction func yesClick(_ sender: Any) {
        SurveyData.s1=true
        self.performSegue(withIdentifier: "s1", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
