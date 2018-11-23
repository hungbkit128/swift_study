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
        
        self.headTextLB.text = getTextData(dataModel?.transModel?.implementerName)
        self.tranType.text = getTextData(dataModel?.transModel?.typeName)
        self.tranStatus.text = getTextData(dataModel?.transModel?.implementName)
        self.tranId.text = getTextData(dataModel?.transModel?.code)
        self.tranTitle.text = getTextData(dataModel?.transModel?.subject)
        self.tranDate.text = getTextData(dataModel?.transModel?.createDate)
        self.tranNote.text = getTextData(dataModel?.transModel?.note)
    }
    
    func getTextData(_ text: String?) -> String {
        if let strValue = text, !strValue.isEmpty {
            return strValue
        } else {
            return "Không có"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
