//
//  HisTransCell.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 12/5/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit

class HisTransCell: UITableViewCell {

    @IBOutlet weak var idLB: UILabel!
    @IBOutlet weak var typeLB: UILabel!
    @IBOutlet weak var contentLB: UILabel!
    @IBOutlet weak var employeeLB: UILabel!
    @IBOutlet weak var dateLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func binData(_ model: ApproveHistoryModel) {
        self.idLB.text = String(model.id ?? 0)
        self.typeLB.text = StringUtils.getTextData(model.confirmName)
        self.contentLB.text = StringUtils.getTextData(model.confirmNote)
        self.employeeLB.text = StringUtils.getTextData(model.implementerName)
        
        let dateString = StringUtils.getTextData(model.confirmDate)
        self.dateLB.text = DateTimeUtils.getDateTimeString(inputString:dateString,
                                                           inputFormat:"yyyy-MM-dd'T'HH:mm:ss",
                                                           outputFormat:"dd/MM/yyyy HH:mm:ss")
    }
}
