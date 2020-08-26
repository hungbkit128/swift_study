//
//  SignedinVC.swift
//  GoogleSigninDemo
//
//  Created by Tran Van Hung on 4/7/20.
//  Copyright © 2020 hba. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignedinVC: UIViewController {
    
    
    let userDefault = UserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    @IBAction func signoutBtnClick(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance()?.signOut()
            self.userDefault.removeObject(forKey: "signedin")
            self.userDefault.synchronize()
            self.dismiss(animated: true, completion: nil)
        } catch let err as NSError {
            print(err.localizedDescription)
        }
    }
    
}
