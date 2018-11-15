//
//  ViewController.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 10/8/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ViewController: BaseButtonBarPagerTabStripViewController<ButtonCell>, UISearchBarDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var abSoftERPVC:ABSoftERPVC? = nil
    var customerVC:CustomerVC? = nil
    var reportMainVC:ReportMainVC? = nil
    var settingVC:SettingVC? = nil
    
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
        
        self.initButtonBarView()
        super.viewDidLoad()
        self.initScreen()
        
        if ServiceManager.token == nil {
            let secondViewController:LoginVC = LoginVC()
            self.present(secondViewController, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        abSoftERPVC?.updateIndayData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initScreen() -> Void {
        revealViewController().panGestureRecognizer()
        revealViewController().tapGestureRecognizer()
        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.navigationController?.navigationBar.barTintColor = ColorManager.barTintColor
        self.navigationItem.title = "Home"
        
//        let searchBar = UISearchBar()
//        searchBar.placeholder = "Search"
//        searchBar.frame = CGRect(x: 0, y: -64, width: (navigationController?.view.bounds.size.width)!, height: 64)
//        searchBar.barStyle = .default
//        searchBar.isTranslucent = false
//        searchBar.barTintColor = UIColor.red
//        searchBar.backgroundImage = UIImage()
//        view.addSubview(searchBar)
    }
    
    func initButtonBarView() -> Void {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = .white
        settings.style.selectedBarHeight = 0.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = {(oldCell: ButtonCell?, newCell: ButtonCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.iconImage.tintColor = .black
            newCell?.iconImage.tintColor = ColorManager.barTintColor
        }
    }
    
    @IBAction func searchBTTapped(_ sender: Any) {
    }
    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        abSoftERPVC = ABSoftERPVC(itemInfo: IndicatorInfo(title:"ABSoft ERP", image: UIImage(named: "ic_home_48pt")))
        customerVC = CustomerVC(itemInfo: IndicatorInfo(title: "Khách hàng", image: UIImage(named: "ic_account_circle")), navItem:self.navigationItem)
        reportMainVC = ReportMainVC(itemInfo: IndicatorInfo(title: "Báo cáo", image: UIImage(named: "ic_assessment_48pt")))
        settingVC = SettingVC(itemInfo: IndicatorInfo(title: "Cài đặt", image: UIImage(named: "ic_settings_48pt")))
        return [abSoftERPVC!, customerVC!, reportMainVC!, settingVC!]
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
                
                navigationItem.title = child.indicatorInfo(for: me).title
            })
        }
    }
}

