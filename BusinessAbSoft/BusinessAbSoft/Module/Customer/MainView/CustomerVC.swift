//
//  CustomerVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/9/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import ExpandingMenu

class CustomerVC: UIViewController, UITableViewDataSource, UITableViewDelegate, IndicatorInfoProvider, ServiceManagerProtocol, UISearchBarDelegate {
    
    @IBOutlet weak var customerTBV: UITableView!
    @IBOutlet weak var noDataLB: UILabel!
    
    var itemInfo: IndicatorInfo = "View"
    var lstCustomerModel:[CustomerModel]?
    var refresher:UIRefreshControl?
    var isDataLoaded:Bool?
    var navItem:UINavigationItem?
    
    init(itemInfo:IndicatorInfo, navItem:UINavigationItem) {
        self.navItem = navItem
        self.itemInfo = itemInfo
        self.lstCustomerModel = []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        isDataLoaded = false
        noDataLB.isHidden = true
        
        self.customerTBV.tableFooterView = UIView()
        self.customerTBV.delegate = self
        self.customerTBV.dataSource = self
        self.customerTBV.register(UINib(nibName: "CustomerTBCell", bundle: Bundle.main), forCellReuseIdentifier: "CustomerTBCell")
        
        refresher = UIRefreshControl()
        refresher?.addTarget(self, action: #selector(CustomerVC.getData), for: UIControlEvents.valueChanged)
        customerTBV.refreshControl = refresher
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        if (ServiceManager.token != nil && !isDataLoaded!) {
            getData()
            initExpandingMenuButton()
        }
    }
    
    @objc func getData() -> Void {
        
        noDataLB.isHidden = true
        refresher?.beginRefreshing()
        
        let request:RequestCommon = RequestCommon(Token: ServiceManager.token!)
        ServiceManager.delegate = self
        ServiceManager.httpPost(urlString: Constants.DO_GET_CUSTOMER_URL, jsonData: request.toDictionary())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func initExpandingMenuButton() {
        let menuButtonSize: CGSize = CGSize(width: 64.0, height: 64.0)
        let menuButton = ExpandingMenuButton(frame: CGRect(origin: CGPoint.zero, size: menuButtonSize), image: UIImage(named: "chooser-button-tab")!, rotatedImage: UIImage(named: "chooser-button-tab-highlighted")!)
        menuButton.center = CGPoint(x: self.view.bounds.width - 32.0, y: self.view.bounds.height - 32.0)
        menuButton.playSound = false
        self.view.addSubview(menuButton)
        
        let item1 = ExpandingMenuItem(size: menuButtonSize, title: "Thêm mới", image: UIImage(named: "ic_person_add")!, highlightedImage: UIImage(named: "ic_person_add")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            
            let secondViewController:AddNewCusVC = AddNewCusVC()
            self.present(secondViewController, animated: true, completion: nil)
        }
        
        let item2 = ExpandingMenuItem(size: menuButtonSize, title: "Giao dịch", image: UIImage(named: "ic_sync")!, highlightedImage: UIImage(named: "ic_sync")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            
            let secondViewController:MainDealVC = MainDealVC()
            self.present(secondViewController, animated: true, completion: nil)
        }
        
        let item3 = ExpandingMenuItem(size: menuButtonSize, title: "Báo giá", image: UIImage(named: "ic_monetization_on")!, highlightedImage: UIImage(named: "ic_monetization_on")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            
            //... ShowPriceMainVC
            let secondViewController:ShowPriceMainVC = ShowPriceMainVC()
            self.present(secondViewController, animated: true, completion: nil)
        }
        
        menuButton.addMenuItems([item1, item2, item3])
        menuButton.willPresentMenuItems = { (menu) -> Void in
            print("MenuItems will present.")
        }
        menuButton.didDismissMenuItems = { (menu) -> Void in
            print("MenuItems dismissed.")
        }
    }
    
    // tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lstCustomerModel!.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerTBCell") as! CustomerTBCell
        
        cell.nameLB.text = lstCustomerModel![indexPath.row].CustomerName == "" ? " " : lstCustomerModel![indexPath.row].CustomerName
        cell.phoneLB.text = lstCustomerModel![indexPath.row].PhoneNumber == "" ? " " : lstCustomerModel![indexPath.row].PhoneNumber
        cell.mailLB.text = lstCustomerModel![indexPath.row].Email == "" ? " " : lstCustomerModel![indexPath.row].Email
        cell.locationLB.text = lstCustomerModel![indexPath.row].Address == "" ? " " : lstCustomerModel![indexPath.row].Address
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell:CustomerTBCell = customerTBV.cellForRow(at:indexPath) as! CustomerTBCell
        
        if let lstCus = lstCustomerModel {
            let model = lstCus[indexPath.row]
            
            
        }
        
        
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    // Service delegate
    func didFinishService(data: Any, funcName: String) {
        do {
            let dataResult = try JSONDecoder().decode(CustomerModelData.self, from: data as! Data)
            self.lstCustomerModel = dataResult.LstCustomerModel
            
            //DispatchQueue.main.async() {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                if (self.lstCustomerModel?.count)! > Int(0) {
                    self.isDataLoaded = true
                    self.noDataLB.isHidden = true
                } else {
                    self.noDataLB.isHidden = false
                }
                
                self.customerTBV.reloadData()
                self.refresher?.endRefreshing()
            }
        } catch {
            print(error)
        }
    }
    func didErrorService(errString: String, funcName: String) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            UiUtils.showAlert(title:errString, viewController:self)
            self.refresher?.endRefreshing()
        }
    }
}
