//
//  OutOfDateVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 10/27/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import PullToRefreshKit
import NVActivityIndicatorView

let TYPE_VIEW_PRICE = 1
let TYPE_VIEW_CONTRACT = 2
let TYPE_VIEW_ORDER = 3
let TYPE_VIEW_HOME = 4

class OutOfDateVC: UIViewController, UITableViewDataSource, UITableViewDelegate, IndicatorInfoProvider, NVActivityIndicatorViewable {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLB: UILabel!
    
    var itemInfo = IndicatorInfo(title: "View")
    var lstJobWarning:[JobWarningModel] = []
    var refresher:UIRefreshControl?
    var isDataLoaded:Bool?
    var homeService = HomeService()
    var cusService = CustomerService()
    
    var idCus: String?
    var viewType: Int
    
    init(itemInfo: IndicatorInfo, viewType: Int, idCus: String?) {
        self.itemInfo = itemInfo
        self.lstJobWarning = []
        self.viewType = viewType
        self.idCus = idCus
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isDataLoaded = false
        noDataLB.isHidden = true
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "IndayViewCell", bundle: Bundle.main), forCellReuseIdentifier: "IndayViewCell")
        
        refresher = UIRefreshControl()
        refresher?.addTarget(self, action: #selector(OutOfDateVC.getData), for: UIControlEvents.valueChanged)
        tableView.refreshControl = refresher
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (ServiceManager.token != nil && !isDataLoaded!) {
            getData()
        }
    }
    
    @objc func getData() -> Void {
        
        noDataLB.isHidden = true
        refresher?.beginRefreshing()
        
        if viewType == TYPE_VIEW_HOME {
            homeService.getJobWarningUnMake() { (listJob, error) in
                self.refreshUI(listJob: listJob)
            }
        } else if viewType == TYPE_VIEW_PRICE {
            cusService.getTransactions(idCustomer: self.idCus!, businessType: "QUOTATION") { (listJob, error) in
                self.refreshUI(listJob: listJob)
            }
        } else if viewType == TYPE_VIEW_ORDER {
            cusService.getTransactions(idCustomer: self.idCus!, businessType: "ORDER") { (listJob, error) in
                self.refreshUI(listJob: listJob)
            }
        } else if viewType == TYPE_VIEW_CONTRACT {
            cusService.getTransactions(idCustomer: self.idCus!, businessType: "CONTRACT") { (listJob, error) in
                self.refreshUI(listJob: listJob)
            }
        }
    }
    
    func refreshUI(listJob: [JobWarningModel]) {
        if listJob.count > 0  {
            self.lstJobWarning = listJob
            self.isDataLoaded = true
            self.noDataLB.isHidden = true
        } else {
            self.noDataLB.isHidden = false
        }
        
        self.tableView.reloadData()
        self.refresher?.endRefreshing()
    }
    
    // tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstJobWarning.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = lstJobWarning[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "IndayViewCell") as! IndayViewCell
        cell.bindData(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell:IndayViewCell = tableView.cellForRow(at:indexPath) as! IndayViewCell
        
        let size = CGSize(width: 32, height: 32)
        self.startAnimating(size, message: "Đang lấy chi tiết công việc...", type: NVActivityIndicatorType(rawValue: 2)!)
        
        let jobModel = lstJobWarning[indexPath.row]
        homeService.viewDetailRequest(jobId: jobModel.jobId!, jobType: jobModel.jobType!) {
                                        
            (transModel: DetailTransModel?, error: NSError?) in
            self.stopAnimating()
            if error == nil {
                let secondViewController:DetailDealMainVC = DetailDealMainVC()
                secondViewController.detailTransModel = transModel
                secondViewController.jobModel = jobModel
                self.present(secondViewController, animated: true, completion: nil)
            } else {
                UiUtils.showAlert(title:error?.localizedDescription ?? "", viewController:self)
            }
        }
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
