//
//  AccountCell.swift
//  BusinessAbSoft
//
//  Created by Vtsoft2 on 11/21/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {

    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var departmentLB: UILabel!
    @IBOutlet weak var statusImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
