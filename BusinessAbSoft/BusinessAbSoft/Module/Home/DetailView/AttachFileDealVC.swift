//
//  AttachFileDealVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/15/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class AttachFileDealVC: UIViewController, IndicatorInfoProvider {
    
    
    var itemInfo = IndicatorInfo(title: "View")
    var dataModel: DetailTransModel?
    
    
    init(itemInfo: IndicatorInfo, detailTransModel: DetailTransModel?) {
        self.itemInfo = itemInfo
        self.dataModel = detailTransModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
