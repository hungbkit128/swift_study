//
//  ProductDealVC.swift
//  BusinessAbSoft
//
//  Created by Tran Van Hung on 11/15/17.
//  Copyright © 2017 hungtv. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ProductDealVC: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var noDataLB: UILabel!
    
    var itemInfo = IndicatorInfo(title: "View")
    var dataModel: DetailTransModel?
    let viewModel: ProductViewModel = ProductViewModel()
    
    init(itemInfo: IndicatorInfo, detailTransModel: DetailTransModel?) {
        self.itemInfo = itemInfo
        self.dataModel = detailTransModel
        if let list = dataModel?.lstProductModel {
            viewModel.setListProduct(list)
        } else {
            viewModel.setListProduct([ProductModel]())
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        self.productTableView.register(ReleaseNoteTableViewCell.nibDefault(),
//                                forCellReuseIdentifier: ReleaseNoteTableViewCell.classString())
        self.productTableView.separatorStyle = .none
        
    }
    
    func doRefreshView() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .calculationModePaced, animations: {
            self.productTableView.reloadData()
        }, completion: { (finished: Bool) in
            print("Animation Finished")
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

extension ProductDealVC: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let itemModel: ProductModel = viewModel.getProductWithSection(section)
        if itemModel.isCollapse {
            return 200.0
        }
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: ProductHeaderView = ProductHeaderView.initWithDefaultNib()
        let itemModel: ProductModel = viewModel.getProductWithSection(section)
        headerView.binddingCellWithModel(itemModel, section, itemModel.isCollapse)
        weak var weakSelf = self
        headerView.actionCollapse = { () in
            weakSelf?.viewModel.updateCollapse(section)
            weakSelf?.doRefreshView()
        }
        
        return headerView
    }
}

extension ProductDealVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.updateCollapse(indexPath.section)
        self.doRefreshView()
    }
}
