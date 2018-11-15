//
//  SignupVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 10/12/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwiftCop

class SignupVC: UIViewController, ServiceManagerProtocol, NVActivityIndicatorViewable {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var fullNameMessLB: UILabel!
    @IBOutlet weak var companyNameTF: UITextField!
    @IBOutlet weak var companyMessLB: UILabel!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var phoneMessLB: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var emailMessLB: UILabel!
    
    let swiftCop = SwiftCop()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bgView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bgView.addSubview(blurEffectView)
        
        // an ban phim khi bam ra ngoai
        self.hideKeyboardWhenTappedAround()
        
        // gan cac validate
        swiftCop.addSuspect(Suspect(view: self.fullNameTF, sentence: "Tên phải nhập ít nhất hai từ"){
            return $0.components(separatedBy: " ").filter{$0 != ""}.count >= 2
        })
        swiftCop.addSuspect(Suspect(view:self.emailTF, sentence: "Địa chỉ email không đúng", trial: Trial.email))
        swiftCop.addSuspect(Suspect(view:self.phoneTF, sentence: "Số điện thoại phải lớn hơn 9 ký tự", trial: Trial.length(.minimum, 10)))
        swiftCop.addSuspect(Suspect(view:self.companyNameTF, sentence: "Tên công ty không được bỏ trống", trial: Trial.length(.minimum, 1)))
        
        // gan text:
        self.fullNameMessLB.text = ""
        self.emailMessLB.text = ""
        self.phoneMessLB.text = ""
        self.companyMessLB.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // select name
        fullNameTF.becomeFirstResponder()
    }
    
    @IBAction func validateFullName(_ sender: UITextField) {
        self.fullNameMessLB.text = swiftCop.isGuilty(sender)?.verdict()
    }
    
    @IBAction func validateEmail(_ sender: UITextField) {
        self.emailMessLB.text = swiftCop.isGuilty(sender)?.verdict()
    }
    
    @IBAction func validatePhoneNumber(_ sender: UITextField) {
        self.phoneMessLB.text = swiftCop.isGuilty(sender)?.verdict()
    }
    
    @IBAction func validateCompanyName(_ sender: UITextField) {
        self.companyMessLB.text = swiftCop.isGuilty(sender)?.verdict()
    }
    
    func validateAll() -> Bool {
        self.fullNameMessLB.text = swiftCop.isGuilty(fullNameTF)?.verdict()
        self.emailMessLB.text = swiftCop.isGuilty(emailTF)?.verdict()
        self.phoneMessLB.text = swiftCop.isGuilty(phoneTF)?.verdict()
        self.companyMessLB.text = swiftCop.isGuilty(companyNameTF)?.verdict()
        
        let allGuiltiesMessage = swiftCop.allGuilties().map{ return $0.sentence}.joined(separator: "\n")
        if allGuiltiesMessage.count > 0 {
            UiUtils.showAlert(title: allGuiltiesMessage, viewController: self)
            return false
        }
        return true
    }
    
    @IBAction func signupTapped(_ sender: UIButton) {
        
        if !validateAll() {
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
        
        ServiceManager.delegate = self
        ServiceManager.httpPost(urlString: Constants.REGISTER_URL, jsonData: jsonData)
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showAlert(_ title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func didFinishService(data: Any, funcName: String) {
        DispatchQueue.main.async() {
            self.stopAnimating()
            do {
                let regResponse = try JSONDecoder().decode(RegisterResponseData.self, from: data as! Data)
                if "1" == regResponse.ErrorCode {
                    self.showAlert("Đăng ký thành công!")
                } else {
                    self.showAlert(regResponse.Description!)
                }
            } catch {
                print(error)
            }
        }
    }
    func didErrorService(errString: String, funcName: String) {
        DispatchQueue.main.async() {
            self.stopAnimating()
            UiUtils.showAlert(title: errString, viewController: self)
        }
    }
    
    // an ban phim khi bam ra ngoai
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
