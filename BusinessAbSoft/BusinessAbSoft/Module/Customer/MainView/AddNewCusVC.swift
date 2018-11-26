//
//  AddNewCusVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/9/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import CRNetworkButton

class AddNewCusVC: UIViewController, ServiceManagerProtocol {
    
    @IBOutlet weak var cusNameTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var cusPhoneTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var cusMailTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var cusAddressTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var addCusBT: CRNetworkButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textFields = [cusNameTF, cusPhoneTF, cusMailTF, cusAddressTF]
        for textField in textFields {
            applySkyscannerThemeWithIcon(textField: textField!)
        }
        
        cusNameTF.becomeFirstResponder()
        cusNameTF.iconText = "\u{f2b9}" // 007,
        cusPhoneTF.iconText = "\u{f098}"
        cusMailTF.iconText = "\u{f0e0}" // 199
        cusAddressTF.iconText = "\u{f0f9}"
        
        // an ban phim khi bam ra ngoai
        hideKeyboardWhenTappedAround()
    }
    
    func applySkyscannerThemeWithIcon(textField: SkyFloatingLabelTextFieldWithIcon) {
        self.applySkyscannerTheme(textField: textField)
        textField.iconColor = ColorManager.lightGreyColor
        textField.selectedIconColor = ColorManager.barTintColor
        textField.iconFont = UIFont(name: "FontAwesome", size: 14)
    }
    
    func applySkyscannerTheme(textField: SkyFloatingLabelTextField) {
        textField.tintColor = ColorManager.barTintColor
        textField.textColor = ColorManager.darkGreyColor
        textField.lineColor = ColorManager.lightGreyColor
        textField.selectedTitleColor = ColorManager.barTintColor
        textField.selectedLineColor = ColorManager.barTintColor
        
        // Set custom fonts for the title, placeholder and textfield labels
        textField.titleLabel.font = UIFont.systemFont(ofSize: 12.0)
        textField.placeholderFont = UIFont.systemFont(ofSize: 18.0)
        textField.font = UIFont.systemFont(ofSize: 18.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addCusBTTapped(_ sender: CRNetworkButton) {
        
        if sender.currState == .finished {
            sender.resetToReady()
            return
        }
        
        if !validateAllField() {
            sender.stopByError()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                sender.resetToReady()
            }
            return
        }
        
        let request:InsertCusRequestData = InsertCusRequestData(CustomerName:cusNameTF.text!, Address:cusAddressTF.text!, Email:cusMailTF.text!, PhoneNumber:cusPhoneTF.text!, Token:ServiceManager.token!)
        ServiceManager.delegate = self
        ServiceManager.httpPost(urlString: Constants.DO_INSERT_CUSTOMER_URL, jsonData: request.toDictionary())
    }
    
    func validateAllField() -> Bool {
        if cusNameTF.text!.isEmpty {
            cusNameTF.errorMessage = "Tên khách hàng không được để trống"
            cusNameTF.becomeFirstResponder()
            return false
        }
        if cusPhoneTF.text!.isEmpty {
            cusPhoneTF.errorMessage = "Số điện thoại không được để trống"
            cusPhoneTF.becomeFirstResponder()
            return false
        }
        if cusMailTF.text!.isEmpty {
            cusMailTF.errorMessage = "Địa chỉ email không được để trống"
            cusMailTF.becomeFirstResponder()
            return false
        } else {
            let email:String = cusMailTF.text!
            if !validateEmail(email) {
                cusMailTF.errorMessage = NSLocalizedString(
                    "Địa chỉ email không đúng",
                    tableName: "SkyFloatingLabelTextField",
                    comment: ""
                )
                return false
            }
        }
        if cusAddressTF.text!.isEmpty {
            cusAddressTF.errorMessage = "Địa chỉ không được để trống"
            cusAddressTF.becomeFirstResponder()
            return false
        }
        return true
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - validation
    func validateEmail(_ candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }

    @IBAction func cusInfoChanged(_ sender: SkyFloatingLabelTextFieldWithIcon) {
        if sender.isEqual(cusNameTF) {
            cusNameTF.errorMessage = nil
            return
        }
        if sender.isEqual(cusPhoneTF) {
            cusPhoneTF.errorMessage = nil
            return
        }
        if sender.isEqual(cusMailTF) {
            cusMailTF.errorMessage = nil
            return
        }
        if sender.isEqual(cusAddressTF) {
            cusAddressTF.errorMessage = nil
            return
        }
    }
    
    // Service delegate
    func didFinishService(data: Any, funcName: String) {
        //DispatchQueue.main.async() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.addCusBT.stopAnimate()
            self.cusNameTF.text = ""
            self.cusPhoneTF.text = ""
            self.cusMailTF.text = ""
            self.cusAddressTF.text = ""
            self.cusNameTF.becomeFirstResponder()
        }
    }
    func didErrorService(errString: String, funcName: String) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            UiUtils.showAlert(title:errString, viewController:self)
            self.addCusBT.stopByError()
        }
    }
}
