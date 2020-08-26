//
//  ViewController.swift
//  GoogleSigninDemo
//
//  Created by Tran Van Hung on 4/7/20.
//  Copyright © 2020 hba. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, GIDSignInDelegate {
    
    let userDefault = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.userDefault.bool(forKey: "signedin") {
            self.performSegue(withIdentifier: "go_to_signedin", sender: self)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        print(user.userID as Any)
        print(user.authentication.idToken as Any)
        print(user.profile.name as Any)
        print(user.profile.givenName as Any)
        print(user.profile.familyName as Any)
        print(user.profile.email as Any)

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error == nil {
                self.userDefault.set(true, forKey: "signedin")
                self.userDefault.synchronize()
                self.performSegue(withIdentifier: "go_to_signedin", sender: nil)
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // ...
    }
}

