//
//  ProductViewCell.swift
//  BusinessAbSoft
//
//  Created by Vtsoft2 on 11/20/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit

class ProductViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        if isIphoneApp() {
            self.backgroundColor = UIColor.white
        } else {
            self.backgroundColor = UIColor(hexString: "#EEEEEE")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
