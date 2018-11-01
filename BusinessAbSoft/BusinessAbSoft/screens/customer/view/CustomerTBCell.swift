//
//  CustomerTBCell.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/9/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit

class CustomerTBCell: UITableViewCell {
    
    @IBOutlet weak var iconNameIMV: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var iconPhoneIMV: UIImageView!
    @IBOutlet weak var phoneLB: UILabel!
    @IBOutlet weak var iconMailIMV: UIImageView!
    @IBOutlet weak var mailLB: UILabel!
    @IBOutlet weak var locationLB: UILabel!
    @IBOutlet weak var iconLocationIMV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconNameIMV.image = iconNameIMV.image!.withRenderingMode(.alwaysTemplate)
        iconPhoneIMV.image = iconPhoneIMV.image!.withRenderingMode(.alwaysTemplate)
        iconMailIMV.image = iconMailIMV.image!.withRenderingMode(.alwaysTemplate)
        iconLocationIMV.image = iconLocationIMV.image!.withRenderingMode(.alwaysTemplate)
        
        iconNameIMV.tintColor = ColorManager.barTintColor
        iconPhoneIMV.tintColor = ColorManager.barTintColor
        iconMailIMV.tintColor = ColorManager.barTintColor
        iconLocationIMV.tintColor = ColorManager.barTintColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
