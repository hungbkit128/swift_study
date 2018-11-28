//
//  IndayViewCell.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/5/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit

class IndayViewCell: UITableViewCell {
    
    @IBOutlet weak var dateIconIM: UIImageView!
    @IBOutlet weak var staffIconIM: UIImageView!
    @IBOutlet weak var contentIconIM: UIImageView!
    @IBOutlet weak var cusIconIMV: UIImageView!
    
    @IBOutlet weak var bgNumberIM: UIImageView!
    @IBOutlet weak var indexLB: UILabel!
    
    @IBOutlet weak var cusLB: UILabel!
    @IBOutlet weak var contentLB: UILabel!
    @IBOutlet weak var staffLB: UILabel!
    @IBOutlet weak var dateLB: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        let color = ColorManager.mainColor
        
        cusIconIMV.image = cusIconIMV.image!.withRenderingMode(.alwaysTemplate)
        contentIconIM.image = contentIconIM.image!.withRenderingMode(.alwaysTemplate)
        staffIconIM.image = staffIconIM.image!.withRenderingMode(.alwaysTemplate)
        dateIconIM.image = dateIconIM.image!.withRenderingMode(.alwaysTemplate)
        
        cusIconIMV.tintColor = color
        contentIconIM.tintColor = color
        staffIconIM.tintColor = color
        dateIconIM.tintColor = color
        
        bgNumberIM.layer.borderColor = UIColor.white.cgColor
        bgNumberIM.layer.borderWidth = 1
        bgNumberIM.layer.cornerRadius = 16
        bgNumberIM.layer.masksToBounds = false
        bgNumberIM.clipsToBounds = true
        
        bgNumberIM.backgroundColor = color
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
