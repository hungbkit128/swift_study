//
//  ReportMainVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/18/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ReportMainVC: UIViewController, UITableViewDataSource, UITableViewDelegate, IndicatorInfoProvider, ServiceManagerProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLB: UILabel!
    
    var itemInfo: IndicatorInfo = "View"
    var lstGroupReport:[GroupReport]?
    var groupReportArr:NSMutableArray?
    var refresher:UIRefreshControl?
    var isDataLoaded:Bool?
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        self.lstGroupReport = []
        self.groupReportArr = NSMutableArray()
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
        
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ReportTBVCell", bundle: Bundle.main), forCellReuseIdentifier: "ReportTBVCell")
        
        refresher = UIRefreshControl()
        refresher?.addTarget(self, action: #selector(ReportMainVC.getData), for: UIControlEvents.valueChanged)
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
        
        let request:RequestCommon = RequestCommon(Token: ServiceManager.token!)
        ServiceManager.delegate = self
        ServiceManager.httpPost(urlString: Constants.INIT_GROUP_REPORT_URL, jsonData: request.toDictionary())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lstGroupReport!.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTBVCell") as! ReportTBVCell
        
        cell.nameLB.text = lstGroupReport![indexPath.row].Value == "" ? " " : lstGroupReport![indexPath.row].Value
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:ReportTBVCell = tableView.cellForRow(at:indexPath) as! ReportTBVCell
        
        let idValue = lstGroupReport![indexPath.row].Key
        let secondViewController:ReportTypeDetailVC = ReportTypeDetailVC(idValue!)
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    // Service delegate
    func didFinishService(data: Any, funcName: String) {
        do {
            let dataResult = try JSONDecoder().decode(GroupReportData.self, from: data as! Data)
            self.lstGroupReport = dataResult.LstGroupReport
            //self.groupReportArr = NSMutableArray(array:dataResult.LstGroupReport!)
            
            //DispatchQueue.main.async() {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                if (self.lstGroupReport?.count)! > Int(0) {
                    self.isDataLoaded = true
                    self.noDataLB.isHidden = true
                } else {
                    self.noDataLB.isHidden = false
                }
                
                self.tableView.reloadData()
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
