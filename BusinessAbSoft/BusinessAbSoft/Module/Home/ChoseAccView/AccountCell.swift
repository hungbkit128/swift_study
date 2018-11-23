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
    
    func bindModelData(_ model: AccountApproveModel) {
        
        iconImg.image = iconImg.image!.withRenderingMode(.alwaysTemplate)
        statusImg.image = statusImg.image!.withRenderingMode(.alwaysTemplate)
        iconImg.tintColor = ColorManager.barTintColor
        
        nameLB.text = model.userName
        departmentLB.text = model.departmentsName
        if model.isSelected {
            statusImg.tintColor = ColorManager.barTintColor
        } else {
            statusImg.tintColor = ColorManager.lightGreyColor
        }
    }
}
