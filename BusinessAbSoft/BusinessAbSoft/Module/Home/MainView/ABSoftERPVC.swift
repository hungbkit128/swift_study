//
//  ABSoftERPVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 10/27/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ABSoftERPVC: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var chartContentView: UIView!
    @IBOutlet weak var mainContentView: UIView!
    
    var itemInfo: IndicatorInfo = "View"
    var erpMainContentVC:ERPMainContentVC?
    var chartView:ERPChartVC?
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        chartView = ERPChartVC(num1: 100, num2: 123, num3: 10)
        self.addChildViewController(chartView!)
        chartView?.view.frame = chartContentView.frame
        chartContentView.addSubview((chartView?.view)!)
        
        erpMainContentVC = ERPMainContentVC()
        self.addChildViewController(erpMainContentVC!)
        erpMainContentVC?.view.frame = CGRect(x: 0, y: 0, width: mainContentView.bounds.size.width, height: mainContentView.bounds.size.height)
        mainContentView.addSubview((erpMainContentVC?.view)!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateIndayData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    func updateIndayData() -> Void {
        if (erpMainContentVC != nil) {
            erpMainContentVC?.updateInDayData()
        }
    }
}
