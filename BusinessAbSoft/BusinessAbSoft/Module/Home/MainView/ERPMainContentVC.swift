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
        settings.style.buttonBarBackgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 0.0976027397)
        settings.style.buttonBarItemBackgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 0.1029537672)
        settings.style.selectedBarBackgroundColor = ColorManager.mainColor
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarItemFont = .systemFont(ofSize: 14, weight:.regular)
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = ColorManager.mainColor
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.textColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
            oldCell?.label.font = .systemFont(ofSize: 14, weight:.bold)
            newCell?.label.textColor = ColorManager.mainColor
            newCell?.label.font = .systemFont(ofSize: 14, weight:.heavy)
        }
    }
    
    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        inDayVC = InDayVC(itemInfo: "TRONG NGÀY")
        outOfDateVC = OutOfDateVC(itemInfo: "QUÁ HẠN", viewType: TYPE_VIEW_HOME, idCus: nil)
        return [inDayVC!, outOfDateVC!]
    }
    
    func updateInDayData() -> Void {
        inDayVC?.initData()
    }
}
