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
    var lstStringType:[String] = []
    
    var typeSelected:String?
    var dateSelected:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.selectAccVC = ChoseAccountVC()
        
        self.typeSelected = ""
        self.dateSelected = DateTimeUtils.getDateStringFromDate(date:Date(), outputFormat:"dd/MM/yyyy")
        
        let size = CGSize(width: 32, height: 32)
        self.startAnimating(size, message: "Đang lấy dữ liệu...", type: NVActivityIndicatorType(rawValue: 2)!)
        self.homeService.getApproveType { (models, error) in
            self.stopAnimating()
            if error == nil {
                self.lstApproveType = models
                for item in models {
                    self.lstStringType.append(item.value ?? "nil")
                }
            } else {
                UiUtils.showAlert(title:(error?.localizedDescription)!, viewController:self)
            }
        }
    }
    
    func getIndexTypeSelected() -> Int {
        var index:Int = 0;
        for item in self.lstStringType {
            if typeSelected == item {
                return index
            }
            index = index + 1
        }
        return 0
    }
    
    @IBAction func typeBTAction(_ sender: UIButton) {
        
        if self.lstApproveType.count == 0 {
            UiUtils.showAlert(title:"Không có thông tin loại phê duyệt, bạn vui lòng kiểm tra lại!", viewController:self)
            return
        }
        
        ActionSheetStringPicker.show(withTitle: "Chọn loại báo cáo", rows:lstStringType as [Any], initialSelection: getIndexTypeSelected(), doneBlock: {
            picker, value, index in
        
            let stringValue = self.lstStringType[value]
            self.typeSelected = stringValue
            sender.setTitle(stringValue, for:.normal)
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func dateBTAction(_ sender: UIButton) {
        let dateCurrent:Date = DateTimeUtils.getDateFromString(inputString:self.dateSelected!, inputFormat:"dd/MM/yyyy")
        
        let datePicker = ActionSheetDatePicker(title: "Chọn ngày", datePickerMode: UIDatePickerMode.date, selectedDate: dateCurrent, doneBlock: {
            picker, value, index in
            
            let date:Date = value as! Date
            let stringValue = DateTimeUtils.getDateStringFromDate(date:date, outputFormat:"dd/MM/yyyy")
            self.dateSelected = stringValue
            sender.setTitle(stringValue, for: .normal)
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender.superview!.superview)
        datePicker?.show()
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
