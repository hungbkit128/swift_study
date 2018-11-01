//
//  ButtonBarVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 10/12/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ButtonBarVC: BaseButtonBarPagerTabStripViewController<ButtonCell> {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        buttonBarItemSpec = ButtonBarItemSpec.nibFile(nibName: "ButtonCell", bundle: Bundle(for: ButtonCell.self), width: { _ in
            return 55.0
        })
    }
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.barTintColor = ColorManager.barTintColor
        
        // change selected bar color
        settings.style.buttonBarBackgroundColor = ColorManager.redColor
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = UIColor(red: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1.0)
        settings.style.selectedBarHeight = 0.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { (oldCell: ButtonCell?, newCell: ButtonCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.iconImage.tintColor = ColorManager.barTintColor
            newCell?.iconImage.tintColor = .white
        }
        super.viewDidLoad()
        
        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.navigationItem.title = "Button Bar"
    }
    
    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = TableChildExampleViewController(style: .plain, itemInfo: IndicatorInfo(title: " HOME", image: UIImage(named: "ic_account_circle")))
        let child_2 = TableChildExampleViewController(style: .plain, itemInfo: IndicatorInfo(title: " TRENDING", image: UIImage(named: "ic_account_circle")))
        let child_3 = ChildExampleViewController(itemInfo: IndicatorInfo(title: " ACCOUNT", image: UIImage(named: "ic_account_circle")))
        let child_4 = ChildExampleViewController(itemInfo: IndicatorInfo(title: " ACCOUNT", image: UIImage(named: "ic_account_circle")))
        let child_5 = ChildExampleViewController(itemInfo: IndicatorInfo(title: " ACCOUNT", image: UIImage(named: "ic_account_circle")))
        return [child_1, child_2, child_3, child_4, child_5]
    }
    
    override func configure(cell: ButtonCell, for indicatorInfo: IndicatorInfo) {
        cell.iconImage.image = indicatorInfo.image?.withRenderingMode(.alwaysTemplate)
    }
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        if indexWasChanged && toIndex > -1 && toIndex < viewControllers.count {
            let child = viewControllers[toIndex] as! IndicatorInfoProvider // swiftlint:disable:this force_cast
            UIView.performWithoutAnimation({ [weak self] () -> Void in
                guard let me = self else { return }
                me.navigationItem.leftBarButtonItem?.title =  child.indicatorInfo(for: me).title
            })
        }
    }
}
