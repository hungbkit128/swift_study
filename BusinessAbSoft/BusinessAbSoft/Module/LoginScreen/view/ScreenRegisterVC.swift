//
//  ScreenRegisterVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/8/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SkyFloatingLabelTextField
import NVActivityIndicatorView
import SwiftCop

class ScreenRegisterVC: UIViewController, IndicatorInfoProvider, NVActivityIndicatorViewable {
    
    @IBOutlet weak var fullNameTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var emailTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var phoneTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var companyNameTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var registerBT: UIButton!
    
    let swiftCop = SwiftCop()
    var itemInfo = IndicatorInfo(title: "View")
    var authenService: AuthenService = AuthenService()
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerBT.layer.cornerRadius = 10
        
        UiUtils.applySkyscannerThemeWithIcon(textField: fullNameTF)
        UiUtils.applySkyscannerThemeWithIcon(textField: emailTF)
        UiUtils.applySkyscannerThemeWithIcon(textField: phoneTF)
        UiUtils.applySkyscannerThemeWithIcon(textField: companyNameTF)
        
        fullNameTF.iconText = "\u{f007}"
        emailTF.iconText = "\u{f0e0}"
        phoneTF.iconText = "\u{f098}"
        companyNameTF.iconText = "\u{f1a5}"

        // gan cac validate
        swiftCop.addSuspect(Suspect(view: self.fullNameTF, sentence: "Tên phải nhập ít nhất hai từ"){
            return $0.components(separatedBy: " ").filter{$0 != ""}.count >= 2
        })
        swiftCop.addSuspect(Suspect(view:self.emailTF, sentence: "Địa chỉ email không đúng", trial: Trial.email))
        swiftCop.addSuspect(Suspect(view:self.phoneTF, sentence: "Số điện thoại phải lớn hơn 9 ký tự", trial: Trial.length(.minimum, 10)))
        swiftCop.addSuspect(Suspect(view:self.companyNameTF, sentence: "Tên công ty không được bỏ trống", trial: Trial.length(.minimum, 1)))
    }
    
    func isValidateAll() -> Bool {
        let allGuiltiesMessage = swiftCop.allGuilties().map{ return $0.sentence}.joined(separator: "\n")
        if allGuiltiesMessage.count > 0 {
            UiUtils.showAlert(title: allGuiltiesMessage, viewController: self)
            return false
        }
        return true
    }
    
    @IBAction func registerBTAction(_ sender: Any) {
        
        if !isValidateAll() {
            return
        }
        
        let regObject = RegisterRequestData()
        regObject.CompanyName = companyNameTF.text
        regObject.CustName = fullNameTF.text
        regObject.Email = emailTF.text
        regObject.Isdn = phoneTF.text
        regObject.Model = UIDevice.current.modelName
        regObject.Imei = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        let jsonData = regObject.toDictionary()
        print(jsonData)
        
        let size = CGSize(width: 30, height: 30)
        self.startAnimating(size, message: "Đang thực hiện đăng ký...", type: NVActivityIndicatorType(rawValue: 2)!)
        
        authenService.registerRequest(companyName: companyNameTF.text ?? "",
                                      custName: fullNameTF.text ?? "",
                                      email: emailTF.text ?? "",
                                      isdn: phoneTF.text ?? "") { (error) in
            self.stopAnimating()
            if error == nil {
                self.showAlert("Đăng ký thành công!")
            } else {
                self.showAlert(error?.description ?? "")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(_ title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
