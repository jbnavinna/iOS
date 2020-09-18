//
//  SegueHelper.swift
//  JanithN-COBSCCOMP191-029
//
//  Created by user180175 on 9/18/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import Foundation


class SegueHelper{
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if [criteria met to perform segue] {
            return true
        } else {
            return false
        }
    }
}
