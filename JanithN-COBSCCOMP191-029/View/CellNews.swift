//
//  CellNews.swift
//  JanithN-COBSCCOMP191-029
//
//  Created by Janith Navinna on 9/20/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import UIKit

class CellNews: UITableViewCell {
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(title: String, content: String, date: String) {
        lblTitle.text = title
        lblContent.text = content
        lblDate.text = date
    }
    
}
