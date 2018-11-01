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

class OutOfDateVC: UIViewController, UITableViewDataSource, UITableViewDelegate, IndicatorInfoProvider, ServiceManagerProtocol, NVActivityIndicatorViewable {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLB: UILabel!
    
    var itemInfo = IndicatorInfo(title: "View")
    var lstJobWarning:[JobData]?
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
        
        let request:RequestCommon = RequestCommon(Token: ServiceManager.token!)
        ServiceManager.delegate = self
        ServiceManager.httpPost(urlString: Constants.GET_JOB_WARNING_UN_MAKE_URL, jsonData: request.toDictionary())
    }
    
    // tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstJobWarning!.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:IndayViewCell = tableView.cellForRow(at:indexPath) as! IndayViewCell
        
        let size = CGSize(width: 32, height: 32)
        self.startAnimating(size, message: "Đang lấy chi tiết công việc...", type: NVActivityIndicatorType(rawValue: 2)!)
        
        let request:ViewDetailRequestData = ViewDetailRequestData(JobId:lstJobWarning![indexPath.row].JobId!, JobType:lstJobWarning![indexPath.row].JobType!, Token: ServiceManager.token!)
        ServiceManager.delegate = self
        ServiceManager.httpPost(urlString: Constants.VIEW_DETAIL_URL, jsonData: request.toDictionary())
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func processJobData(data:Any) -> Void {
        do {
            let jobs = try JSONDecoder().decode(JobWarningData.self, from: data as! Data)
            self.lstJobWarning = jobs.LstJobWarning
            
            //DispatchQueue.main.async() {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
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
    
    func processViewDetailData(data:Any) -> Void {
        do {
            let viewDetailResponseData = try JSONDecoder().decode(ViewDetailResponseData.self, from: data as! Data)
            
            //DispatchQueue.main.async() {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                self.stopAnimating()
                let secondViewController:DetailDealMainVC = DetailDealMainVC()
                self.present(secondViewController, animated: true, completion: nil)
            }
        } catch {
            print(error)
        }
    }
    
    // Service delegate
    func didFinishService(data: Any, funcName: String) {
        if (funcName.elementsEqual(Constants.GET_JOB_WARNING_UN_MAKE_URL)) {
            self.processJobData(data: data)
        } else if (funcName.elementsEqual(Constants.VIEW_DETAIL_URL)) {
            self.processViewDetailData(data: data)
        }
    }
    func didErrorService(errString: String, funcName: String) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            UiUtils.showAlert(title:errString, viewController:self)
            if (funcName.elementsEqual(Constants.GET_JOB_WARNING_UN_MAKE_URL)) {
                self.refresher?.endRefreshing()
            } else if (funcName.elementsEqual(Constants.VIEW_DETAIL_URL)) {
                self.stopAnimating()
            }
        }
    }
}
