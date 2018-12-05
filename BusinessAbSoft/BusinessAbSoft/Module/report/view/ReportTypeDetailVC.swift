//
//  ReportTypeDetailVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/18/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit
import CRNetworkButton
import ActionSheetPicker_3_0
import NVActivityIndicatorView

class ReportTypeDetailVC: UIViewController, NVActivityIndicatorViewable, ServiceManagerProtocol {
    
    @IBOutlet weak var navBarItem: UINavigationItem!
    @IBOutlet weak var reportBT: CRNetworkButton!
    @IBOutlet weak var toDateBT: UIButton!
    @IBOutlet weak var fromDateBT: UIButton!
    @IBOutlet weak var typeReportBT: UIButton!

    var reportTypes:NSMutableArray?
    var groupReportId:String?
    var reportTypeSelected:String?
    var fromDateSelected:String?
    var toDateSelected:String?
    
    init(_ groupReportId: String) {
        self.groupReportId = groupReportId
        self.reportTypes = NSMutableArray()
        self.reportTypeSelected = ""
        self.fromDateSelected = DateTimeUtils.getDateStringFromDate(date:Date(), outputFormat:"dd/MM/yyyy")
        self.toDateSelected = DateTimeUtils.getDateStringFromDate(date:Date(), outputFormat:"dd/MM/yyyy")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navBarItem.title = "Thông tin hệ thống"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (ServiceManager.token != nil) {
            getData()
        }
    }
    
    @objc func getData() -> Void {
        let size = CGSize(width: 32, height: 32)
        self.startAnimating(size, message: "Đang lấy loại báo cáo...", type: NVActivityIndicatorType(rawValue: 2)!)
        
        let request:InitReportTypeRequest = InitReportTypeRequest(GroupReportId:self.groupReportId!, Token: ServiceManager.token!)
        ServiceManager.delegate = self
        ServiceManager.httpPost(urlString: Constants.INIT_REPORT_TYPE_URL, jsonData: request.toDictionary())
    }
    
    func getIndexTypeSelected() -> Int {
        var index:Int = 0;
        for typeRp in self.reportTypes! {
            
            let value:String = typeRp as! String
            if (reportTypeSelected?.elementsEqual(value))! {
                return index
            }
            index = index + Int(1)
        }
        return 0
    }
    
    @IBAction func backTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func reportBTTapped(_ sender: Any) {
        
        
    }
    
    @IBAction func reportTypeBTTapped(_ sender: UIButton) {
        
        if self.reportTypes?.count == Int(0) {
            UiUtils.showAlert(title:"Không có thông tin loại báo cáo, bạn vui lòng kiểm tra lại!", viewController:self)
            return
        }
        
        ActionSheetStringPicker.show(withTitle: "Chọn loại báo cáo", rows:reportTypes as? [Any], initialSelection: getIndexTypeSelected(), doneBlock: {
            picker, value, index in
            
            let stringValue = self.reportTypes?.object(at:value) as! String
            self.reportTypeSelected = stringValue
            sender.setTitle(stringValue, for:.normal)
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func fromDateBTTapped(_ sender: UIButton) {
        
        let dateCurrent:Date = DateTimeUtils.getDateFromString(inputString:self.fromDateSelected!, inputFormat:"dd/MM/yyyy")
        
        let datePicker = ActionSheetDatePicker(title: "Chọn ngày", datePickerMode: UIDatePickerMode.date, selectedDate: dateCurrent, doneBlock: {
            picker, value, index in
            
            let date:Date = value as! Date
            let stringValue = DateTimeUtils.getDateStringFromDate(date:date, outputFormat:"dd/MM/yyyy")
            self.fromDateSelected = stringValue
            sender.setTitle(stringValue, for: .normal)
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender.superview!.superview)
        datePicker?.show()
    }
    
    @IBAction func toDateBTTapped(_ sender: UIButton) {
        
        let dateCurrent:Date = DateTimeUtils.getDateFromString(inputString:self.toDateSelected!, inputFormat:"dd/MM/yyyy")
        
        let datePicker = ActionSheetDatePicker(title: "Chọn ngày", datePickerMode: UIDatePickerMode.date, selectedDate: dateCurrent, doneBlock: {
            picker, value, index in
            
            let date:Date = value as! Date
            let stringValue = DateTimeUtils.getDateStringFromDate(date:date, outputFormat:"dd/MM/yyyy")
            self.toDateSelected = stringValue
            sender.setTitle(stringValue, for: .normal)
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender.superview!.superview)
        datePicker?.show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Service delegate
    func didFinishService(data: Any, funcName: String) {
        
        do {
            let reportTypeResponseData = try JSONDecoder().decode(ReportTypeResponseData.self, from: data as! Data)
            
            //DispatchQueue.main.async() {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                for rpType in reportTypeResponseData.LstReportType! {
                    self.reportTypes?.add(rpType.Value as Any)
                }
                self.stopAnimating()
            }
        } catch {
            print(error)
        }
    }
    func didErrorService(errString: String, funcName: String) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.stopAnimating()
            UiUtils.showAlert(title:errString, viewController:self)
        }
    }
}
