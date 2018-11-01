//
//  DealVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/13/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SkyFloatingLabelTextField
import CRNetworkButton
import DKImagePickerController
import NVActivityIndicatorView
import ActionSheetPicker_3_0
import SkyFloatingLabelTextField

class DealVC: UIViewController, IndicatorInfoProvider, NVActivityIndicatorViewable, ServiceManagerProtocol {
    
    @IBOutlet weak var titleTF: SkyFloatingLabelTextField!
    @IBOutlet weak var workTypeTF: SkyFloatingLabelTextField!
    @IBOutlet weak var workStateTF: SkyFloatingLabelTextField!
    @IBOutlet weak var contentTF: SkyFloatingLabelTextField!
    @IBOutlet weak var noteTF: SkyFloatingLabelTextField!
    
    @IBOutlet weak var selectImageBT: UIButton!
    @IBOutlet weak var addBT: CRNetworkButton!
    
    var lstBusinessType:NSMutableArray?
    var lstStatus:NSMutableArray?
    
    var itemInfo = IndicatorInfo(title: "View")
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        self.lstBusinessType = NSMutableArray()
        self.lstStatus = NSMutableArray()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTF.becomeFirstResponder()
        
        titleTF.font = UIFont.systemFont(ofSize: 16.0)
        workTypeTF.font = UIFont.systemFont(ofSize: 16.0)
        workStateTF.font = UIFont.systemFont(ofSize: 16.0)
        contentTF.font = UIFont.systemFont(ofSize: 16.0)
        noteTF.font = UIFont.systemFont(ofSize: 16.0)
        
        selectImageBT.imageView?.image = selectImageBT.imageView?.image?.withRenderingMode(.alwaysTemplate)
        selectImageBT.imageView?.tintColor = ColorManager.barTintColor
        
        // an ban phim khi bam ra ngoai
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (ServiceManager.token != nil && lstStatus?.count == Int(0)) {
            getData()
        }
    }
    
    @objc func getData() -> Void {
        let size = CGSize(width: 32, height: 32)
        self.startAnimating(size, message: "Đang lấy dữ liệu...", type: NVActivityIndicatorType(rawValue: 2)!)
        
        let request:RequestCommon = RequestCommon(Token: ServiceManager.token!)
        ServiceManager.delegate = self
        ServiceManager.httpPost(urlString: Constants.LOAD_DATA_URL, jsonData: request.toDictionary())
    }
    
    func getIndexBsnSelected() -> Int {
        var index:Int = 0;
        for bsnType in self.lstBusinessType! {
            let bsn = bsnType as! String
            if (workTypeTF.text?.elementsEqual(bsn))! {
                return index
            }
            index = index + Int(1)
        }
        return 0
    }
    
    func getIndexSttSelected() -> Int {
        var index:Int = 0;
        for sttItem in self.lstStatus! {
            let stt = sttItem as! String
            if (workStateTF.text?.elementsEqual(stt))! {
                return index
            }
            index = index + Int(1)
        }
        return 0
    }
    
    @IBAction func workStateTapped(_ sender: Any) {
        if self.lstStatus?.count == Int(0) {
            UiUtils.showAlert(title:"Không có thông tin trạng thái công việc, bạn vui lòng kiểm tra lại!", viewController:self)
            return
        }
        ActionSheetStringPicker.show(withTitle: "Trạng thái công việc", rows:lstStatus as! [Any], initialSelection: getIndexSttSelected(), doneBlock: {
            picker, value, index in
            
            let stringValue = self.lstStatus?.object(at:value) as! String
            self.workStateTF.text = stringValue
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    
    @IBAction func workTypeTapped(_ sender: Any) {
        if self.lstStatus?.count == Int(0) {
            UiUtils.showAlert(title:"Không có thông tin loại công việc, bạn vui lòng kiểm tra lại!", viewController:self)
            return
        }
        ActionSheetStringPicker.show(withTitle: "Loại công việc", rows:lstBusinessType as! [Any], initialSelection: getIndexBsnSelected(), doneBlock: {
            picker, value, index in
            
            let stringValue = self.lstBusinessType?.object(at:value) as! String
            self.workTypeTF.text = stringValue
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func selectImageTapped(_ sender: Any) {
        let pickerController = DKImagePickerController()
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets)
        }
        self.present(pickerController, animated: true) {}
    }
    
    
    
    @IBAction func addTapped(_ sender: Any) {
        
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    // Service delegate
    func didFinishService(data: Any, funcName: String) {
        do {
            let responseData = try JSONDecoder().decode(LoadDataResponseData.self, from: data as! Data)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                for bsnType in responseData.LstBusinessType! {
                    self.lstBusinessType?.add(bsnType.Value as Any)
                }
                for sttItem in responseData.LstStatus! {
                    self.lstStatus?.add(sttItem.Value as Any)
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
