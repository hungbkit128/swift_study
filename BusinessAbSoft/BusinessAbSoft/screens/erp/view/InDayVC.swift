//
//  InDayVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 10/27/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class InDayVC: UIViewController, UITableViewDataSource, UITableViewDelegate, IndicatorInfoProvider, ServiceManagerProtocol {
    
    @IBOutlet weak var noDataLB: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var lstJobWarning:[JobData]?
    var itemInfo = IndicatorInfo(title: "View")
    var refresher:UIRefreshControl?
    var isDataLoaded:Bool?
    
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
        
        let inDayRequest:RequestCommon = RequestCommon(Token: ServiceManager.token!)
        ServiceManager.delegate = self
        ServiceManager.httpPost(urlString: Constants.GET_WARNING_IN_DAY_URL, jsonData: inDayRequest.toDictionary())
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IndayViewCell") as! IndayViewCell
        
        cell.indexLB.text = String(indexPath.row + 1)
        cell.cusLB.text = lstJobWarning![indexPath.row].CustomerName == "" ? " " : lstJobWarning![indexPath.row].CustomerName
        cell.contentLB.text = lstJobWarning![indexPath.row].Content == "" ? " " : lstJobWarning![indexPath.row].Content
        cell.staffLB.text = lstJobWarning![indexPath.row].UserImplement == "" ? " " : lstJobWarning![indexPath.row].UserImplement
        
        let dateString = lstJobWarning![indexPath.row].DateWarning
        cell.dateLB.text = DateTimeUtils.getDateTimeString(inputString:dateString!, inputFormat:"yyyy-MM-dd'T'HH:mm:ss", outputFormat:"dd/MM/yyyy HH:mm:ss")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstJobWarning!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:IndayViewCell = tableView.cellForRow(at:indexPath) as! IndayViewCell
        
        let secondViewController:DetailDealMainVC = DetailDealMainVC()
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Service delegate
    func didFinishService(data: Any, funcName: String) {
        do {
            let jobs = try JSONDecoder().decode(JobWarningData.self, from: data as! Data)
            self.lstJobWarning = jobs.LstJobWarning
            
            DispatchQueue.main.async() {
            //DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                if (self.lstJobWarning?.count)! > Int(0) {
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
