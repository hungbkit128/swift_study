//
//  LoginMainVC.swift
//  BusinessAbSoft
//
//  Created by Vtsoft2 on 11/2/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit

class LoginMainVC: UIViewController {

    @IBOutlet weak var mainContentView: UIView!
    
    private var loginContentVC: LoginContentVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginContentVC = LoginContentVC()
        self.addChildViewController(loginContentVC!)
        loginContentVC?.view.frame = CGRect(x: 0, y: 0, width: mainContentView.bounds.size.width, height: mainContentView.bounds.size.height)
        mainContentView.addSubview((loginContentVC?.view)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
