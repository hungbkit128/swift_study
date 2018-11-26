//
//  ApprovedTransVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/20/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import NVActivityIndicatorView

class ApprovedTransVC: UIViewController {
    
    
    @IBOutlet weak var approveTypeBT: UIButton!
    @IBOutlet weak var warningDateBT: UIButton!
    @IBOutlet weak var contentTV: UITextView!
    @IBOutlet weak var numberUserLB: UILabel!
    
    var selectAccVC:ChoseAccountVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.selectAccVC = ChoseAccountVC()
    }


    @IBAction func updateBTAction(_ sender: Any) {
        
    }
    
    @IBAction func selectUserBTAction(_ sender: Any) {
        self.present(selectAccVC, animated: true, completion: nil)
    }
    
    @IBAction func backTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

}
