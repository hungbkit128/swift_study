//
//  SystemInfoVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 10/9/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit

class SystemInfoVC: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255.0, green: 140/255.0, blue: 198/255.0, alpha: 1.0)
        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.navigationItem.title = "Thông tin hệ thống"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
