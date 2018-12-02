//
//  SimpleCell.swift
//  TableViewDemo
//
//  Created by Vtsoft2 on 12/1/18.
//  Copyright © 2018 hungtv64. All rights reserved.
//

import UIKit

class SimpleCell: UITableViewCell {

    @IBOutlet weak var nameLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
