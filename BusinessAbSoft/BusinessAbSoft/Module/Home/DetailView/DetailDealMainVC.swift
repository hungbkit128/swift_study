//
//  DetailDealMainVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/15/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import WYPopoverController
import NVActivityIndicatorView

class DetailDealMainVC: ButtonBarPagerTabStripViewController, NVActivityIndicatorViewable, WYPopoverControllerDelegate {
    
    var contentDealVC:ContentDealVC?
    var productDealVC:ProductDealVC?
    var attachFileDealVC:AttachFileDealVC?
    var detailTransModel: DetailTransModel?
    var jobModel: JobWarningModel?
    
    var homeService:HomeService = HomeService()
    var popOverVC:WYPopoverController?
    
    override func viewDidLoad() {
        initMenuView()
        super.viewDidLoad()
    }
    
    @IBAction func backTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func hisTransTapped(_ sender: UIBarButtonItem) {
        
        let size = CGSize(width: 32, height: 32)
        self.startAnimating(size, message: "Đang lấy chi tiết công việc...", type: NVActivityIndicatorType(rawValue: 2)!)
        if let model = self.jobModel,
            let id = model.jobId  {
            homeService.getTransApproveHistory(businessType: BusinessType.typeFromString(model.jobType ?? ""), tranId: id, completion: { (hisModels, error) in
                self.stopAnimating()
                if error == nil {
                    if hisModels.count == 0 {
                        UiUtils.showAlert(title: "Không có thông tin lịch sử giao dịch", viewController: self)
                    } else {
                        let vc = HisTransListVC()
                        vc.listHisTrans = hisModels
                        let cgSize: CGSize = isIphoneApp() ? CGSize(width: 320.0, height: 250.0) : CGSize(width: 400.0, height: 300.0)
                        vc.preferredContentSize = cgSize
                        self.presentPopOverVC(viewController: vc, sender: sender.value(forKey: "view") as? UIView, style: .up)
                    }
                } else {
                    UiUtils.showAlert(title: error?.description ?? "Đã có lỗi xảy ra", viewController: self)
                }
            })
        }
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
        contentDealVC = ContentDealVC(itemInfo: "NỘI DUNG", detailTransModel: detailTransModel, enableEdit: false)
        productDealVC = ProductDealVC(itemInfo: "SẢN PHẨM", detailTransModel: detailTransModel)
        attachFileDealVC = AttachFileDealVC(itemInfo: "FILE ĐÍNH KÈM", detailTransModel: detailTransModel)
        return [contentDealVC!, productDealVC!, attachFileDealVC!]
    }
    
    @IBAction func tickBTAction(_ sender: Any) {
        let secondViewController:ApprovedTransVC = ApprovedTransVC()
        //secondViewController.transModel = transModel
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    func doShowPopoverWithVC(_ vc: UIViewController, from: CGRect, inView: UIView!) {
        
        let popOverVC = WYPopoverController(contentViewController: vc)
        popOverVC?.popoverLayoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        popOverVC?.wantsDefaultContentAppearance = true
        popOverVC?.delegate = self
        
        let direction = isIphoneApp() ? WYPopoverArrowDirection.none : WYPopoverArrowDirection.up
        popOverVC?.presentPopover(from: from,
                                       in: inView,
                                       permittedArrowDirections: direction,
                                       animated: true,
                                       options: WYPopoverAnimationOptions.fade,
                                       completion: {
        })
    }
    
    func presentPopOverVC(viewController: UIViewController!, sender: UIView?, style: WYPopoverArrowDirection) {
        
        popOverVC = WYPopoverController(contentViewController: viewController)
        popOverVC?.popoverLayoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        popOverVC?.wantsDefaultContentAppearance = false
        popOverVC?.delegate = self
        
        if let button = sender {
            popOverVC?.presentPopover(from: button.bounds,
                                      in: button,
                                      permittedArrowDirections: style,
                                      animated: true)
        } else {
            popOverVC?.presentPopoverAsDialog(animated: true)
        }
    }
    
    func popoverControllerDidDismissPopover(_ popoverController: WYPopoverController!) {
        self.popOverVC?.delegate = nil
        self.popOverVC = nil
    }
}
