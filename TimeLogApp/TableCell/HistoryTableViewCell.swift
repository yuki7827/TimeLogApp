//
//  HistoryTableViewCell.swift
//  TimeLogApp
//
//  Created by Apple on 2020/04/05.
//  Copyright © 2020年 Baminami. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var passageTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
