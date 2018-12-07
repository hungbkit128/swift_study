//
//  CusDetailVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/27/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import WYPopoverController
import NVActivityIndicatorView
import ExpandingMenu

class CusDetailVC: UIViewController {
    
    @IBOutlet weak var iconLocalImg: UIImageView!
    @IBOutlet weak var iconPhoneImg: UIImageView!
    @IBOutlet weak var iconMailImg: UIImageView!
    
    @IBOutlet weak var cusNameLB: UILabel!
    @IBOutlet weak var cusAdressLB: UILabel!
    @IBOutlet weak var cusPhoneLB: UILabel!
    @IBOutlet weak var cusMailLB: UILabel!
    
    @IBOutlet weak var detailView: UIView!
    
    var cusTransDetailVC:CusTransDetailVC?
    var cusModel: CustomerModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set color icon
        let color = ColorManager.mainColor
        iconLocalImg.image = iconLocalImg.image!.withRenderingMode(.alwaysTemplate)
        iconPhoneImg.image = iconPhoneImg.image!.withRenderingMode(.alwaysTemplate)
        iconMailImg.image = iconMailImg.image!.withRenderingMode(.alwaysTemplate)
        iconLocalImg.tintColor = color
        iconPhoneImg.tintColor = color
        iconMailImg.tintColor = color

        cusNameLB.text = cusModel?.CustomerName
        cusAdressLB.text = cusModel?.Address
        cusPhoneLB.text = cusModel?.PhoneNumber
        cusMailLB.text = cusModel?.Email
        
        cusTransDetailVC = CusTransDetailVC()
        cusTransDetailVC?.cusModel = cusModel
        self.addChildViewController(cusTransDetailVC!)
        cusTransDetailVC?.view.frame = CGRect(x: 0, y: 0, width: detailView.bounds.size.width, height: detailView.bounds.size.height)
        detailView.addSubview((cusTransDetailVC?.view)!)
    }
    
    @IBAction func backTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initExpandingMenuButton()
    }
    
    fileprivate func initExpandingMenuButton() {
        let menuButtonSize: CGSize = CGSize(width: 64.0, height: 64.0)
        let menuButton = ExpandingMenuButton(frame: CGRect(origin: CGPoint.zero, size: menuButtonSize), image: UIImage(named: "chooser-button-tab")!, rotatedImage: UIImage(named: "chooser-button-tab-highlighted")!)
        menuButton.center = CGPoint(x: self.view.bounds.width - 32.0, y: self.view.bounds.height - 32.0)
        menuButton.playSound = false
        self.view.addSubview(menuButton)
        
        let item1 = ExpandingMenuItem(size: menuButtonSize, title: "Giao dịch", image: UIImage(named: "ic_person_add")!, highlightedImage: UIImage(named: "ic_person_add")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            
            let secondViewController:TransMainVC = TransMainVC()
            self.present(secondViewController, animated: true, completion: nil)
        }
        
        let item2 = ExpandingMenuItem(size: menuButtonSize, title: "Hợp đồng", image: UIImage(named: "ic_sync")!, highlightedImage: UIImage(named: "ic_sync")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            
            let secondViewController:MainDealVC = MainDealVC()
            self.present(secondViewController, animated: true, completion: nil)
        }
        
        let item3 = ExpandingMenuItem(size: menuButtonSize, title: "Đơn hàng", image: UIImage(named: "ic_monetization_on")!, highlightedImage: UIImage(named: "ic_monetization_on")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            
            //... ShowPriceMainVC
            let secondViewController:ShowPriceMainVC = ShowPriceMainVC()
            self.present(secondViewController, animated: true, completion: nil)
        }
        
        let item4 = ExpandingMenuItem(size: menuButtonSize, title: "Báo giá", image: UIImage(named: "ic_monetization_on")!, highlightedImage: UIImage(named: "ic_monetization_on")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            
            //... ShowPriceMainVC
            let secondViewController:DetailDealMainVC = DetailDealMainVC()
            secondViewController.typeView = TYPE_PRICE
            self.present(secondViewController, animated: true, completion: nil)
        }
        
        menuButton.addMenuItems([item1, item2, item3, item4])
        menuButton.willPresentMenuItems = { (menu) -> Void in
            print("MenuItems will present.")
        }
        menuButton.didDismissMenuItems = { (menu) -> Void in
            print("MenuItems dismissed.")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
