//
//  ContentDealVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/15/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SkyFloatingLabelTextField
import NVActivityIndicatorView

class ContentDealVC: UIViewController, IndicatorInfoProvider, NVActivityIndicatorViewable {
    
    @IBOutlet weak var headTextLB: UILabel!
    @IBOutlet weak var tranStatusBT: UIButton!
    @IBOutlet weak var tranTypeBT: UIButton!
    @IBOutlet weak var tranIdTF: SkyFloatingLabelTextField!
    @IBOutlet weak var tranTitleTF: SkyFloatingLabelTextField!
    @IBOutlet weak var tranDateTF: SkyFloatingLabelTextField!
    @IBOutlet weak var tranNoteTF: SkyFloatingLabelTextField!
    @IBOutlet weak var tranContentTF: SkyFloatingLabelTextField!
    @IBOutlet weak var statusLineIMG: UIImageView!
    @IBOutlet weak var typeLineIMG: UIImageView!
    
    var itemInfo = IndicatorInfo(title: "View")
    var dataModel: DetailTransModel?
    var enableEdit: Bool = false
    var homeService: HomeService = HomeService()
    
    var lstApproveType:[ApproveTypeModel] = []
    
    init(itemInfo: IndicatorInfo, detailTransModel: DetailTransModel?, enableEdit: Bool) {
        self.itemInfo = itemInfo
        self.dataModel = detailTransModel
        self.enableEdit = enableEdit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if dataModel != nil {
            self.headTextLB.text = StringUtils.getTextData(dataModel?.transModel?.implementerName)
            self.tranTypeBT.setTitle(StringUtils.getTextData(dataModel?.transModel?.typeName), for: .normal)
            self.tranStatusBT.setTitle(StringUtils.getTextData(dataModel?.transModel?.implementName), for: .normal)
            self.tranIdTF.text = StringUtils.getTextData(dataModel?.transModel?.code)
            self.tranTitleTF.text = StringUtils.getTextData(dataModel?.transModel?.title)
            self.tranContentTF.text = StringUtils.getTextData(dataModel?.transModel?.subject)
            let dateString = StringUtils.getTextData(dataModel?.transModel?.createDate)
            self.tranDateTF.text = DateTimeUtils.getDateTimeString(inputString:dateString,
                                                                   inputFormat:"yyyy-MM-dd'T'HH:mm:ss",
                                                                   outputFormat:"dd/MM/yyyy HH:mm:ss")
            self.tranNoteTF.text = StringUtils.getTextData(dataModel?.transModel?.note)
        }
        
        let size = CGSize(width: 32, height: 32)
        self.startAnimating(size, message: "Đang lấy dữ liệu...", type: NVActivityIndicatorType(rawValue: 2)!)
        self.homeService.getApproveType { (models, error) in
            self.stopAnimating()
            if error == nil {
                self.lstApproveType = models
            } else {
                UiUtils.showAlert(title:(error?.localizedDescription)!, viewController:self)
            }
        }
        
        if enableEdit {
            self.tranTypeBT.isEnabled = true
            self.tranStatusBT.isEnabled = true
            self.tranIdTF.isEnabled = true
            self.tranTitleTF.isEnabled = true
            self.tranDateTF.isEnabled = true
            self.tranNoteTF.isEnabled = true
            self.tranContentTF.isEnabled = true
            self.statusLineIMG.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
            self.typeLineIMG.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
            
            
        } else {
            self.tranTypeBT.isEnabled = false
            self.tranStatusBT.isEnabled = false
            self.tranIdTF.isEnabled = false
            self.tranTitleTF.isEnabled = false
            self.tranDateTF.isEnabled = false
            self.tranNoteTF.isEnabled = false
            self.tranContentTF.isEnabled = false
            self.statusLineIMG.backgroundColor = ColorManager.lightGreyColor
            self.typeLineIMG.backgroundColor = ColorManager.lightGreyColor
        }
    }
    
    @IBAction func tranTypeBTAction(_ sender: Any) {
    }
    
    @IBAction func tranStatusBTAction(_ sender: Any) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
