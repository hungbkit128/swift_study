//
//  ERPMainContentVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/5/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ERPMainContentVC: ButtonBarPagerTabStripViewController {
    
    var inDayVC:InDayVC?
    var outOfDateVC:OutOfDateVC?
    
    override func viewDidLoad() {
        initMenuView()
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initMenuView() -> Void {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        settings.style.buttonBarItemBackgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        settings.style.selectedBarBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.6639554795)
            oldCell?.label.font = UIFont.systemFont(ofSize: 16.0)
            newCell?.label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            newCell?.label.font = UIFont.boldSystemFont(ofSize: 16.0)
        }
    }
    
    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        inDayVC = InDayVC(itemInfo: "TRONG NGÀY")
        outOfDateVC = OutOfDateVC(itemInfo: "QUÁ HẠN")
        return [inDayVC!, outOfDateVC!]
    }
    
    func updateInDayData() -> Void {
        inDayVC?.initData()
    }
}
