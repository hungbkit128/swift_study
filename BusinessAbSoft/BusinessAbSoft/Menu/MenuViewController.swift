//
//  MenuViewController.swift
//  SlideMenuDemoFirst
//
//  Created by Tran Van Hung on 10/6/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var labelProfileName: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    
    var menuNameArray:Array = [String]()
    var imageIconArray:Array = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuNameArray = ["Home",
                         "Thông tin phiên bản",
                         //"Button Bar",
                         //"Charts",
                         "Đăng xuất"
        ]
        
        imageIconArray = [UIImage(named:"ic_account_circle")!,
                          UIImage(named:"ic_settings")!,
                          //UIImage(named:"ic_settings")!,
                          //UIImage(named:"ic_settings")!,
                          UIImage(named:"ic_power_settings_new")!
        ]
        
        menuTableView.tableFooterView = UIView()
        
        imageProfile.layer.borderColor = UIColor.white.cgColor
        imageProfile.layer.borderWidth = 2
        imageProfile.layer.cornerRadius = 32
        imageProfile.layer.masksToBounds = false
        imageProfile.clipsToBounds = true
        
        imageProfile.image = imageProfile.image!.withRenderingMode(.alwaysTemplate)
        imageProfile.tintColor = .white
        labelProfileName.text = ServiceManager.userData?.UserName
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        cell.imageIcon.image = imageIconArray[indexPath.row]
        cell.labelName.text = menuNameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNameArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let revealViewController:SWRevealViewController = self.revealViewController()
        let cell:MenuTableViewCell = tableView.cellForRow(at:indexPath) as! MenuTableViewCell
        let mainStoryboard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        
        
        if cell.labelName.text! == "Home"
        {
            let desController = mainStoryboard.instantiateViewController(withIdentifier:"ViewController") as! ViewController
            let newFrontViewController = UINavigationController.init(rootViewController:desController)
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
        }
            
        else if cell.labelName.text! == "Thông tin phiên bản"
        {
            let desController = mainStoryboard.instantiateViewController(withIdentifier:"SystemInfoVC") as! SystemInfoVC
            let newFrontViewController = UINavigationController.init(rootViewController:desController)
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
        }
            
        else if cell.labelName.text! == "Button Bar"
        {
            let desController = mainStoryboard.instantiateViewController(withIdentifier:"ButtonBarVC") as! ButtonBarVC
            let newFrontViewController = UINavigationController.init(rootViewController:desController)
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
        }
            
        else if cell.labelName.text! == "Charts"
        {
            let desController = mainStoryboard.instantiateViewController(withIdentifier:"ChartTestVC") as! ChartTestVC
            let newFrontViewController = UINavigationController.init(rootViewController:desController)
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
        }
        
        else if cell.labelName.text! == "Đăng xuất"
        {
            self.dismiss(animated: true, completion: nil)
            let secondViewController:LoginVC = LoginVC()
            self.present(secondViewController, animated: true, completion: nil)
        }
    }
}
