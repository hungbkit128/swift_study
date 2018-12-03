//
//  ScreenLoginVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/8/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SkyFloatingLabelTextField
import NVActivityIndicatorView

class ScreenLoginVC: UIViewController, IndicatorInfoProvider, NVActivityIndicatorViewable {
    
    @IBOutlet weak var loginBT: UIButton!
    @IBOutlet weak var pwdTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var userNameTF: SkyFloatingLabelTextFieldWithIcon!
    
    private var authenService:AuthenService
    
    var itemInfo = IndicatorInfo(title: "View")
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        self.authenService = AuthenService()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //userNameTF.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginBT.layer.cornerRadius = 10
        
        UiUtils.applySkyscannerThemeWithIcon(textField: pwdTF)
        UiUtils.applySkyscannerThemeWithIcon(textField: userNameTF)
        pwdTF.iconText = "\u{f13e}"
        userNameTF.iconText = "\u{f007}"
        
        userNameTF.text = "lanhdao"
    }

    @IBAction func loginBTAction(_ sender: Any) {
        
        view.endEditing(true)
        let size = CGSize(width: 32, height: 32)
        self.startAnimating(size, message: "Đang xác thực...", type: NVActivityIndicatorType(rawValue: 2)!)
        
        authenService.loginRequest(username: userNameTF.text ?? "",
                                   password: pwdTF.text ?? "",
                                   captchaId: "test",
                                   captchaString: "test") {
            
            (userModel: UserInfoModel?, error: NSError?) in
            
            if error == nil {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    NVActivityIndicatorPresenter.sharedInstance.setMessage("Đăng nhập thành công")
                }
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                    self.stopAnimating()
                    self.dismiss(animated: true, completion: nil)
                    
                    let secondSB:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let secondVC = secondSB.instantiateInitialViewController()
                    self.present(secondVC!, animated: true, completion: nil)
                }
                
                ServiceManager.token = userModel?.Token
                ServiceManager.userData = userModel
                DataManager.shareInstance.userInfo = userModel
            } else {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    NVActivityIndicatorPresenter.sharedInstance.setMessage("Đăng nhập thất bại")
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                    self.stopAnimating()
                    UiUtils.showAlert(title:error?.localizedDescription ?? "xxx", viewController:self)
                }
            }
            
        }
        
//        let logObject = LoginRequestData()
//        logObject.UserName = userNameTF.text
//        logObject.PassWord = pwdTF.text
//        //logObject.Model = UIDevice.current.modelName
//        //logObject.Imei = UIDevice.current.identifierForVendor?.uuidString ?? ""
//
//        logObject.Model = "test"
//        logObject.Imei = "D83A295E-E598-4F6E-BFE4-5C25DEFE7D8F"
//
//        let jsonData = logObject.toDictionary()
//        print(jsonData)
//
//        let size = CGSize(width: 32, height: 32)
//        self.startAnimating(size, message: "Đang xác thực...", type: NVActivityIndicatorType(rawValue: 2)!)
//
//        ServiceManager.delegate = self
//        ServiceManager.httpPost(urlString: Constants.LOGIN_URL, jsonData: jsonData)
        
        
        //UiUtils.showConfirm(title:"Bạn có đồng ý đăng nhập không?", viewController:self, handlerOk:okLogin)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    func didErrorService(errString: String, funcName: String) {
        
    }
}
