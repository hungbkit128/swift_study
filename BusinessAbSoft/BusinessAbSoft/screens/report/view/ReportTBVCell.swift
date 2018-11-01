//
//  ReportTBVCell.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/18/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit

class ReportTBVCell: UITableViewCell {

    @IBOutlet weak var iconRightIMV: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var iconIMV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        iconIMV.image = iconIMV.image!.withRenderingMode(.alwaysTemplate)
        iconRightIMV.image = iconRightIMV.image!.withRenderingMode(.alwaysTemplate)
        
        iconIMV.tintColor = ColorManager.barTintColor
        iconRightIMV.tintColor = ColorManager.barTintColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
