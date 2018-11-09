//
//  LoginContentVC.swift
//  BusinessAbSoft
//
//  Created by Vtsoft2 on 11/2/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class LoginContentVC: ButtonBarPagerTabStripViewController {
    
    var scrLoginVC:ScreenLoginVC?
    var scrRegisterVC:ScreenRegisterVC?

    override func viewDidLoad() {
        initMenuView()
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initMenuView() -> Void {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
        settings.style.buttonBarItemBackgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
        settings.style.selectedBarBackgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.textColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
            oldCell?.label.font = UIFont.systemFont(ofSize: 16.0)
            newCell?.label.textColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            newCell?.label.font = UIFont.boldSystemFont(ofSize: 16.0)
        }
    }
    
    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        scrLoginVC = ScreenLoginVC(itemInfo: "ĐĂNG NHẬP")
        scrRegisterVC = ScreenRegisterVC(itemInfo: "ĐĂNG KÝ")
        return [scrLoginVC!, scrRegisterVC!]
    }
}