//
//  CusDetailVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/27/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import WYPopoverController
import NVActivityIndicatorView

class CusDetailVC: UIViewController {
    
    @IBOutlet weak var cusNameLB: UILabel!
    @IBOutlet weak var cusAdressLB: UILabel!
    @IBOutlet weak var cusPhoneLB: UILabel!
    @IBOutlet weak var cusMailLB: UILabel!
    
    var cusModel: CustomerModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cusNameLB.text = cusModel?.CustomerName
        cusAdressLB.text = cusModel?.Address
        cusPhoneLB.text = cusModel?.PhoneNumber
        cusMailLB.text = cusModel?.Email
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
