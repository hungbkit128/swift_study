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
    
    @IBOutlet weak var detailView: UIView!
    
    var cusTransDetailVC:CusTransDetailVC?
    var cusModel: CustomerModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cusNameLB.text = cusModel?.CustomerName
        cusAdressLB.text = cusModel?.Address
        cusPhoneLB.text = cusModel?.PhoneNumber
        cusMailLB.text = cusModel?.Email
        
        cusTransDetailVC = CusTransDetailVC()
        cusTransDetailVC?.cusModel = cusModel
        self.addChildViewController(cusTransDetailVC!)
        cusTransDetailVC?.view.frame = CGRect(x: 0, y: 0, width: detailView.bounds.size.width, height: detailView.bounds.size.height)
        detailView.addSubview((cusTransDetailVC?.view)!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
