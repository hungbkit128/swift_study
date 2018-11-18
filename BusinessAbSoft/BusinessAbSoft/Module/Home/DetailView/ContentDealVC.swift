//
//  ContentDealVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/15/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ContentDealVC: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var tranType: UILabel!
    @IBOutlet weak var tranStatus: UILabel!
    @IBOutlet weak var tranId: UILabel!
    @IBOutlet weak var tranTitle: UILabel!
    @IBOutlet weak var tranDate: UILabel!
    @IBOutlet weak var tranNote: UILabel!
    @IBOutlet weak var headTextLB: UILabel!
    
    var itemInfo = IndicatorInfo(title: "View")
    var transModel: DetailTransModel?
    
    init(itemInfo: IndicatorInfo, transModel: DetailTransModel?) {
        self.itemInfo = itemInfo
        self.transModel = transModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.headTextLB.text = transModel?.implementerName ?? "Không có"
        self.tranType.text = transModel?.typeName ?? "Không có"
        self.tranStatus.text = transModel?.implementName ?? "Không có"
        self.tranId.text = transModel?.code ?? "Không có"
        self.tranTitle.text = transModel?.subject ?? "Không có"
        self.tranDate.text = transModel?.createDate ?? "Không có"
        self.tranNote.text = transModel?.note ?? "Không có"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
