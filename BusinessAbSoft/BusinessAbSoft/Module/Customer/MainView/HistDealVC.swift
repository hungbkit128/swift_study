//
//  HistDealVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/13/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HistDealVC: UIViewController, UITableViewDataSource, UITableViewDelegate, IndicatorInfoProvider, ServiceManagerProtocol {
    
    @IBOutlet weak var noDataLB: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var lstTrans:[TranModel]?
    var refresher:UIRefreshControl?
    var isDataLoaded:Bool?
    
    var itemInfo = IndicatorInfo(title: "View")
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        self.lstTrans = []
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
        tableView.register(UINib(nibName: "HistDealTBVCell", bundle: Bundle.main), forCellReuseIdentifier: "HistDealTBVCell")
        
        refresher = UIRefreshControl()
        refresher?.addTarget(self, action: #selector(HistDealVC.getData), for: UIControlEvents.valueChanged)
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
        
        let request:SearchHistRequestData = SearchHistRequestData(IdCustomer: "", Token: ServiceManager.token!)
        ServiceManager.delegate = self
        ServiceManager.httpPost(urlString: Constants.SEARCH_HISTORY_URL, jsonData: request.toDictionary())
    }
    
    // tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstTrans!.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistDealTBVCell") as! HistDealTBVCell
        
        cell.nameLB.text = lstTrans![indexPath.row].JobReportTitle == "" ? " " : lstTrans![indexPath.row].JobReportTitle
        cell.noteLB.text = lstTrans![indexPath.row].JobReportNote == "" ? " " : lstTrans![indexPath.row].JobReportNote
        cell.userCreateLB.text = lstTrans![indexPath.row].ImplementerName == "" ? " " : lstTrans![indexPath.row].ImplementerName
        
        let dateString = lstTrans![indexPath.row].WorkDataStr
        cell.createDateLB.text = DateTimeUtils.getDateTimeString(inputString:dateString!, inputFormat:"yyyy-MM-dd'T'HH:mm:ss", outputFormat:"dd/MM/yyyy HH:mm:ss")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell:HistDealTBVCell = tableView.cellForRow(at:indexPath) as! HistDealTBVCell
        
        let secondViewController:DetailDealMainVC = DetailDealMainVC()
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    // Service delegate
    func didFinishService(data: Any, funcName: String) {
        do {
            let transData = try JSONDecoder().decode(TransData.self, from: data as! Data)
            self.lstTrans = transData.LstTrans
            
            //DispatchQueue.main.async() {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                if (self.lstTrans?.count)! > Int(0) {
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
