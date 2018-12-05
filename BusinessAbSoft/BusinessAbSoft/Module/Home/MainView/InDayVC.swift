//
//  InDayVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 10/27/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView

class InDayVC: UIViewController, UITableViewDataSource, UITableViewDelegate, IndicatorInfoProvider, NVActivityIndicatorViewable {
    
    @IBOutlet weak var noDataLB: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var itemInfo = IndicatorInfo(title: "View")
    var refresher:UIRefreshControl?
    var isDataLoaded:Bool?
    
    var homeService:HomeService = HomeService()
    var lstJobWarning:[JobWarningModel] = []
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        self.lstJobWarning = []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        isDataLoaded = false
        noDataLB.isHidden = true
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "IndayViewCell", bundle: Bundle.main), forCellReuseIdentifier: "IndayViewCell")
        
        refresher = UIRefreshControl()
        refresher?.addTarget(self, action: #selector(InDayVC.getData), for: UIControlEvents.valueChanged)
        tableView.refreshControl = refresher
        tableView.addSubview(refresher!)
        tableView.bringSubview(toFront: refresher!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initData()
    }
    
    func initData() -> Void {
        if (ServiceManager.token != nil && !isDataLoaded!) {
            getData()
        }
    }
    
    @objc func getData() -> Void {
        noDataLB.isHidden = true
        refresher?.layoutIfNeeded()
        refresher?.beginRefreshing()
        
        homeService.getWarningInDay { (listModel, error) in
            if error == nil {
                self.lstJobWarning = listModel
                DispatchQueue.main.async() {
                    if self.lstJobWarning.count > 0 {
                        self.isDataLoaded = true
                        self.noDataLB.isHidden = true
                    } else {
                        self.noDataLB.isHidden = false
                    }
                    self.tableView.reloadData()
                    self.refresher?.endRefreshing()
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                    UiUtils.showAlert(title:(error?.localizedDescription)!, viewController:self)
                    self.refresher?.endRefreshing()
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = lstJobWarning[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "IndayViewCell") as! IndayViewCell
        cell.bindData(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstJobWarning.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152
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
