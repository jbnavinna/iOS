//
//  SurveyBorderStyling.swift
//  JanithN-COBSCCOMP191-029
//
//  Created by user180175 on 9/15/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import UIKit

class SurveyBorderStyling: UIView {
    
    override func awakeFromNib() {
        layer.borderColor=UIColor.black.cgColor
        layer.borderWidth=3
        layer.cornerRadius=15
        clipsToBounds=true
    }

}
