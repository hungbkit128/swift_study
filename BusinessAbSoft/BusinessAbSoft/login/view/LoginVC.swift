//
//  LoginVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 10/11/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoginVC: UIViewController, ServiceManagerProtocol, NVActivityIndicatorViewable {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = 0
        contentView.layer.cornerRadius = 4
        contentView.layer.masksToBounds = false
        contentView.clipsToBounds = false
        contentView.layer.shadowRadius = 10
        contentView.layer.shadowColor = UIColor.black.cgColor
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bgView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bgView.addSubview(blurEffectView)
        
        // an ban phim khi bam ra ngoai
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // select username
        usernameLabel.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func loginTapped(_ sender: UIButton) {
        let logObject = LoginRequestData()
        logObject.UserName = usernameLabel.text
        logObject.PassWord = passwordLabel.text
        //logObject.Model = UIDevice.current.modelName
        //logObject.Imei = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        logObject.Model = "test"
        logObject.Imei = "D83A295E-E598-4F6E-BFE4-5C25DEFE7D8F"
        
        let jsonData = logObject.toDictionary()
        print(jsonData)
        
        let size = CGSize(width: 32, height: 32)
        self.startAnimating(size, message: "Đang xác thực...", type: NVActivityIndicatorType(rawValue: 2)!)
        
        ServiceManager.delegate = self
        ServiceManager.httpPost(urlString: Constants.LOGIN_URL, jsonData: jsonData)
        
        
        //UiUtils.showConfirm(title:"Bạn có đồng ý đăng nhập không?", viewController:self, handlerOk:okLogin)
    }
    
    func okLogin(alert: UIAlertAction!)
    {
        let logObject = LoginRequestData()
        logObject.UserName = usernameLabel.text
        logObject.PassWord = passwordLabel.text
        //logObject.Model = UIDevice.current.modelName
        //logObject.Imei = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        logObject.Model = "test"
        logObject.Imei = "D83A295E-E598-4F6E-BFE4-5C25DEFE7D8F"
        
        let jsonData = logObject.toDictionary()
        print(jsonData)
        
        let size = CGSize(width: 32, height: 32)
        self.startAnimating(size, message: "Đang xác thực...", type: NVActivityIndicatorType(rawValue: 2)!)
        
        ServiceManager.delegate = self
        ServiceManager.httpPost(urlString: Constants.LOGIN_URL, jsonData: jsonData)
    }
    
    @IBAction func passForgetTapped(_ sender: UIButton) {
    }
    
    @IBAction func signupTapped(_ sender: UIButton) {
        let secondViewController:SignupVC = SignupVC()
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // delegate
    func didFinishService(data: Any, funcName: String) {
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
        
        do {
            let loginResponseData = try JSONDecoder().decode(LoginResponseData.self, from: data as! Data)
            ServiceManager.token = loginResponseData.UserLogin?.Token
            ServiceManager.userData = loginResponseData.UserLogin
        } catch {
            print(error)
        }
    }
    func didErrorService(errString: String, funcName: String) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            NVActivityIndicatorPresenter.sharedInstance.setMessage("Đăng nhập thất bại")
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.stopAnimating()
            UiUtils.showAlert(title:errString, viewController:self)
        }
    }
}
