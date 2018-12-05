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

class ApprovedTransVC: UIViewController, NVActivityIndicatorViewable {
    
    
    @IBOutlet weak var approveTypeBT: UIButton!
    @IBOutlet weak var warningDateBT: UIButton!
    @IBOutlet weak var contentTV: UITextView!
    @IBOutlet weak var numberUserLB: UILabel!
    
    var selectAccVC:ChoseAccountVC!
    var homeService: HomeService = HomeService()
    var lstApproveType:[ApproveTypeModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.selectAccVC = ChoseAccountVC()
        
        let size = CGSize(width: 32, height: 32)
        self.startAnimating(size, message: "Đang lấy dữ liệu...", type: NVActivityIndicatorType(rawValue: 2)!)
        self.homeService.getApproveType { (models, error) in
            self.stopAnimating()
            if error == nil {
                self.lstApproveType = models
            } else {
                UiUtils.showAlert(title:(error?.localizedDescription)!, viewController:self)
            }
        }
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
