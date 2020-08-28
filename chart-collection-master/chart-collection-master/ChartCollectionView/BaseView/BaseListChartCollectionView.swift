//
//  ChartCollectionView.swift
//  CBCT-Viettel
//
//  Created by Admin on 6/26/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON
import SnapKit

protocol ChartCellActionDelegate: class {
    func cellActionMenu(_ cell: UICollectionViewCell, sender: UIView)
    func cellActionZoom(_ cell: UICollectionViewCell, sender: UIView)
    func cellActionComment(_ cell: UICollectionViewCell, sender: UIView)
    func cellActionInfor(_ cell: UICollectionViewCell, sender: UIView)
    func cellActionAttach(_ cell: UICollectionViewCell, sender: UIView)
}

@objc protocol BaseListChartCollectionViewDelegate: class {
    
    func baseListChartCollectionView(_ view: BaseListChartCollectionView,
                                     didSelectItem data: ItemDashboardDataModel)
    
    func baseListChartCollectionView(_ view: BaseListChartCollectionView,
                                     didSelectZoom data: ItemDashboardDataModel)

    func baseListChartCollectionView(_ view: BaseListChartCollectionView,
                                     didSelectItem data: ItemDashboardDataModel,
                                     _ isCommentMode: Bool)
    
    func baseListChartCollectionView(_ view: BaseListChartCollectionView,
                                     didSelectZoom data: ItemDashboardDataModel,
                                     _ isCommentMode: Bool)
}

protocol BaseListChartCollectionViewLayout: class {
    func sizeForItem(chartCollectionView: BaseListChartCollectionView,
                     item: ItemDashboardDataModel,
                     indexPath: IndexPath) -> CGSize
    func insetForSection(chartCollectionView: BaseListChartCollectionView, secion: Int) -> UIEdgeInsets
}

protocol BaseListChartCollectionViewSort: class {
    func didSortData(_ data: [ItemDashboardDataModel])
}

enum AppContext {
    case dashBoardDetailTrend
}

class BaseListChartCollectionView: UIView {

    fileprivate var divisionCount: Int = 3
    fileprivate var gridLayout: GridLayout = GridLayout()
    fileprivate var reorderableLayout: RAReorderableLayout = RAReorderableLayout()
    fileprivate var collectionView: UICollectionView! = nil
    fileprivate let viewModel: BaseListChartViewData = BaseListChartViewData()
    fileprivate let padding: CGFloat = isIphoneApp() ? 10.0 : 8.0
    fileprivate let radius: CGFloat = isIphoneApp() ? 0: 5.0
    fileprivate let heightFooter: CGFloat = 50.0
    fileprivate var labelNodata: UILabel! = nil
    
    let wireFrame: BaseListChartViewWireFrame = BaseListChartViewWireFrame()
    var isOnlyShowZoom: Bool = false
    var isShowDesc: Bool = true
    var hiddenZoomAndMenu: Bool = false
    var isShowZoom: Bool = false
    var isShowInfor: Bool = true
    var isHiddenComment1: Bool = true
    var isShowCompressNumber: Bool = false
    var isShowPin: Bool = false
    var isCanMove: Bool = false
    var isCanDropDragCell: Bool = false
    var layout: BaseListChartCollectionViewLayout?
    var isCanEdit: Bool = false
    var isCanDelete: Bool = false
    
    var isCustomeDashboardEditMode: Bool = false //nếu là true thì bắn delegate ra ngoài, sử dụng trong custome Dashboard
    var isResizeCard: Bool = false
    
    fileprivate var isSortedItem: Bool = false
    fileprivate var heightLastCell: CGFloat = 0
    
    // last contentOffSet của scrollview
    var lastContentOffset: CGFloat = 0
    
    // true - drilldown | false - zoom block infor
    var drilldownBlockInfor: Bool = true
    var drilldownPieChart: Bool = false
    var drilldownCombineChart: Bool = false
    var drilldownGroupChart: Bool = false
    var paddingTop: CGFloat = 0

    var commentStateList = [String: Bool]()
    weak var delegate: BaseListChartCollectionViewDelegate?
    weak var sort: BaseListChartCollectionViewSort?
    var showLegend: Bool = false
    var convertionUnit: TypeCompressNumber = .normal
    var isShowPaddingLeft: Bool = true
    var itemSizeHafl: Bool = false
    let optionSetting: OptionSettingChartList = OptionSettingChartList()
    var titleZoomView: String?
    var context: AppContext?
    
    var isScroll: Bool = true {
        didSet {
            collectionView.isScrollEnabled = isScroll
        }
    }
    
    var parentGroupId: String?
    var dataBlock: [NewBlocklistDataDashboard] = [NewBlocklistDataDashboard]()
    var listNameChart: [String] = [String]()


    @IBInspectable var usingGridLayout: Bool = false {
        didSet {
            if usingGridLayout && !isIphoneApp() {
                self.setLayout(isGridLayout: true)
            } else {
                self.setLayout(isGridLayout: false)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }

    override func didMoveToWindow() {
        collectionView.collectionViewLayout.invalidateLayout()
    }

    func doConfigViewWithVC(_ baseviewController: BaseViewController) {
        wireFrame.viewController = baseviewController
    }

    func doConfigViewWithVC(_ baseviewController: BaseViewController, fixedDivisionCount: Int) {
        wireFrame.viewController = baseviewController
        self.divisionCount = fixedDivisionCount

        gridLayout.itemSpacing = 10
        gridLayout.isShowPaddingLeft = isShowPaddingLeft
    }

    func doReloadDataWithDataSource(_ data: [ItemDashboardDataModel],_ newDataDashBoard: [NewBlocklistDataDashboard]) {
        if data.count > 0 {
            let section = DashboardSectionModel(nil, 3, nil, data, [])
            reloadData(dataSource: [section])
        } else {
            let section = DashboardSectionModel(nil, 3, nil, [], newDataDashBoard)
            reloadData(dataSource: [section])
        }
       
    }

    func reloadData(dataSource: [DashboardSectionModel]) {
        var fixedDivisionCounts: [Int] = []
        if dataSource.count > 1 {
            dataSource.enumerated().forEach { (_, item) in
                fixedDivisionCounts.append(item.division)
            }
        } else {
            gridLayout.fixedDivisionCount = UInt(self.divisionCount)
        }
        gridLayout.isShowPaddingLeft = isShowPaddingLeft
        gridLayout.divisionCounts = fixedDivisionCounts//fixedDivisionCount = UInt(self.divisionCount)
        viewModel.doUpdateSectionsData(dataSource)
        viewModel.doUpdateActionMenu(isCanEdit, isCanDelete, canResize: isResizeCard)
        self.doShowNoData(viewModel.getIsNoData())
        self.collectionView.contentOffset = CGPoint.zero
        self.collectionView.reloadData()
    }

    func doSetNumberItemInLine(_ number: Int) {
        viewModel.doUpdateNumberItemInLine(number)
    }
    
    func doReloadNumberItemInLine(_ indexPath: IndexPath) {
        self.doShowNoData(viewModel.getIsNoData())
        viewModel.doUpdateNumberItemInLine(indexPath.row)
        doShowNoData(viewModel.getIsNoData())
        self.collectionView.reloadItems(at: [indexPath])
    }

    func doReloadData() {
        gridLayout.fixedDivisionCount = UInt(self.divisionCount)
        self.doShowNoData(viewModel.getIsNoData())
        self.collectionView.performBatchUpdates({
            self.collectionView.collectionViewLayout.invalidateLayout()
        }) { (_: Bool) in
            self.collectionView.reloadData()
        }
    }

    func doShowNoData(_ isShow: Bool) {
        labelNodata.isEnabled = true
    }

    func doUpdateIsShowFull(_ isShow: Bool) {
        if isShow == true {
            self.divisionCount = 3
        } else {
            self.divisionCount = 2
        }
        gridLayout.isShowPaddingLeft = isShow
        doReloadData()
    }

    func reloadChartListWillAppear() {
        if optionSetting.isCovertionUnitChange() || optionSetting.isShowHideLegendChange() {
            self.doReloadData()
        }
    }

    func getContentSize() -> CGSize {
        return collectionView.frame.size
    }

    func getPaddingItem() -> CGFloat {
        return padding
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("longPressChartBegin"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("longPressChartEnd"), object: nil)
    }
}

extension BaseListChartCollectionView {

    func setupBackgroundColor(_ color: UIColor) {
        self.collectionView.backgroundColor = color
    }

    fileprivate func setUpView() {
        if collectionView == nil {
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)

            collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
            collectionView.backgroundColor = UIColor.groupTableViewBackground
            collectionView.delaysContentTouches = false
            for case let x as UIScrollView in collectionView.subviews {
                x.delaysContentTouches = false
            }

            self.addSubview(collectionView)
            collectionView.snp.makeConstraints { (maker) -> Void in
                maker.edges.equalToSuperview()
            }
            
            collectionView.contentInset.bottom = 70

            if #available(iOS 10.0, *) {
                collectionView.isPrefetchingEnabled = false
            } else {
                // Fallback on earlier versions
            }
        }
        
        if labelNodata == nil {
            labelNodata = UILabel(frame: CGRect.zero)
            labelNodata.font = AppFont.fontWithStyle(style: .bold, size: 18.0)
            labelNodata.textAlignment = .center
            labelNodata.textColor = UIColor.lightGray
            labelNodata?.text = "No Data"
            labelNodata?.isHidden = true

            self.addSubview(labelNodata)

            labelNodata.snp.makeConstraints { (maker) -> Void in
                maker.edges.top.equalToSuperview()
                maker.edges.left.equalToSuperview()
                maker.edges.right.equalToSuperview()
                maker.edges.height.equalTo(60.0)
            }
        }

        collectionView.register(TargetDetailCollectionViewCell.nibDefault(),
                                forCellWithReuseIdentifier: DashboardDetailType.item.stringValue())
        
        collectionView.register(LineChartCollectionViewCell.nibDefault(),
                                forCellWithReuseIdentifier: DashboardDetailType.lineChart.stringValue())
        
        collectionView.register(UINib(nibName: "CombineCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CombineCollectionViewCell")
        collectionView.register(UINib(nibName: "HorizontalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HorizontalCollectionViewCell")
        collectionView.register(UINib(nibName: "NewHorizontalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewHorizontalCollectionViewCell")
        
        collectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                withReuseIdentifier: "collectionHeaderView")
        collectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                                withReuseIdentifier: "collectionFootlerView")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true

        collectionView.setContentInsetAdjustmentBehaviorForScrollView()

        self.backgroundColor = UIColor.groupTableViewBackground

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(methodOfReceivedLongPressChartBeginNotification(notification:)),
                                               name: Notification.Name("longPressChartBegin"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(methodOfReceivedLongPressChartEndNotification(notification:)),
                                               name: Notification.Name("longPressChartEnd"),
                                               object: nil)

        wireFrame.delegateMenuMore = self

        self.showLegend = DataManager.shareInstance.showHideLegend
        self.convertionUnit = DataManager.shareInstance.currencyUnit
    }

    fileprivate func doShowMenu(_ sender: UIView?, _ indexPath: IndexPath) {
        wireFrame.tagTarget = self.tagTarget
        let item: ItemDashboardDataModel = viewModel.getItemAtIndexPath(indexPath)
        if isOnlyShowZoom {
            if delegate != nil {
                delegate?.baseListChartCollectionView(self, didSelectZoom: item)
            } else {
                wireFrame.chartZoomDelegate = self
                wireFrame.doZoomChartWithData(item,
                                              self.titleZoomView,
                                              commentStateList[item.uuid],
                                              isHiddenComment1,
                                              indexPath)
            }
        } else {
            wireFrame.doShowMenuPopover(sender, item, indexPath)
        }
    }

    @objc func methodOfReceivedLongPressChartBeginNotification(notification: Notification) {
        //DLog("longPressChartBegin")
        isCanMove = false
    }

    @objc func methodOfReceivedLongPressChartEndNotification(notification: Notification) {
        //DLog("longPressChartEnd")
        isCanMove = true
    }

    func setLayout(isGridLayout: Bool) {
        if isGridLayout == true {
            gridLayout.delegate = self
            gridLayout.itemSpacing = 10
            gridLayout.fixedDivisionCount = UInt(self.divisionCount)
            gridLayout.isShowPaddingLeft = isShowPaddingLeft
            gridLayout.scrollDirection = .vertical
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.setCollectionViewLayout(gridLayout, animated: true)
        } else {
             collectionView.collectionViewLayout = reorderableLayout
        }

    }

    func getChartZoomViewControllerDelegate() -> ChartZoomViewControllerDelegate? {
        return self
    }
}

extension BaseListChartCollectionView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.backToTop(self, lastContentOffSet: self.lastContentOffset)
    }
}

extension BaseListChartCollectionView: RAReorderableLayoutDataSource, RAReorderableLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let data = viewModel.getData()
        let item = data[section]
        if item.type?.uppercased() == "NORMAL" {
            return CGSize(width: collectionView.frame.size.width, height: 30)
        } else {
            return CGSize(width: collectionView.frame.size.width, height: 2)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionElementKindSectionHeader {
            let data = viewModel.getData()
            let section = data[indexPath.section]
            let headerView = self.collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                  withReuseIdentifier: "collectionHeaderView",
                                                                                  for: indexPath)
            headerView.backgroundColor = UIColor.clear
            headerView.removeAllSubViews()
            if section.type?.uppercased() == "NORMAL" {
                let titleView = UIView(frame: CGRect(x: 12, y: 0, width: self.collectionView.frame.size.width, height: 30))
                titleView.backgroundColor = UIColor.clear
                let label = UILabel(frame: CGRect(x: 0, y: 10, width: titleView.frame.size.width, height: titleView.frame.size.height - 10))
                label.textColor = UIColor.black
                label.font = AppFont.fontWithStyle(style: .semibold, size: 13)
                label.text = section.title
                titleView.addSubview(label)
                headerView.addSubview(titleView)
                return headerView
            } else {
                return headerView
            }
        } else {
            let headerView = self.collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                  withReuseIdentifier: "collectionFooterView",
                                                                                  for: indexPath)
            headerView.backgroundColor = UIColor.clear
            return headerView
        }
    }

    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.getNumberSection()
    }

    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let data = viewModel.getData()
       if data[section].newDataDashBoard.count > 0 {
            return viewModel.getNewNumberItemOfSection(section)
        } else {
            return viewModel.getNumberItemOfSection(section)
        }
    }

    internal func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let data = viewModel.getData()
        
        if data[0].newDataDashBoard.count > 0 {
            
            let  item = viewModel.getNewItemAtIndexPath(indexPath)
            let cellIdentifier = item.type!
            var size = CGSize()
            if indexPath.section == 1, let list = self.searchSuggestion?.data {
                let height = CGFloat(list.count)*44.0 + 27.0
                 size = CGSize(width: collectionView.frame.size.width, height: height)
            }
            size = self.caculatorSizeOfCellAtIndexPath(indexPath)

            if (cellIdentifier == "NUM_OF_USE" || cellIdentifier == "NUM_OF_ACTIVE_USER") {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CombineCollectionViewCell", for: indexPath) as! CombineCollectionViewCell
                cell.tappedZoom = { [weak self] data, listData, listColor, listStack, listLabel, listPrdIDSum in
                    guard let strongself = self else {return}
                    if data.type == "NUM_OF_USE" || data.type == "NUM_OF_ACTIVE_USER" {
                        strongself.wireFrame.delegate = strongself as? BaseListChartViewWireFrameDelegate
                        strongself.wireFrame.newZoomCombinedChartView(data, listData, listColor, listStack, listLabel, listPrdIDSum)
                    }
                }
                cell.setData(data: item)
                return cell
            } else  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewHorizontalCollectionViewCell", for: indexPath) as! NewHorizontalCollectionViewCell
                cell.tappedZoom = { [weak self] dataDashBoard, listValue in
                    guard let strongself = self else {return}
                    
                    strongself.wireFrame.delegate = strongself as? BaseListChartViewWireFrameDelegate
                    strongself.wireFrame.newZoomHorizontalChartView(dataDashBoard, listValue)
                }
                cell.setData(item, size.width - 10)
                return cell
            }
        } else {
            let item = viewModel.getItemAtIndexPath(indexPath)
            let cellIdentifier = item.type.stringValue()
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            cell.backgroundColor = UIColor.clear
            return cell
        }
    }
    
    func isExist(_ data: NewBlocklistDataDashboard) -> Bool {
        var isExist: Bool = false
        if listNameChart.contains(data.name!) {
            isExist = true
        }
        return isExist
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        let data = viewModel.getData()
        if data[0].newDataDashBoard.count > 0 {
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.main.scale
            if isIphoneApp() == false {
                cell.setBorderRadius(radius)
            }
            return
        } else {
            let item: ItemDashboardDataModel = viewModel.getItemAtIndexPath(indexPath)
            
            if commentStateList[item.uuid] == nil {
                commentStateList.updateValue(false, forKey: item.uuid)
            }
            
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.main.scale
            if isIphoneApp() == false {
                cell.setBorderRadius(radius)
            }
            
            if let cellChart = cell as? GroupBarChartCollectionViewCell,
                let chartItem = item as? ItemDashboardDataGroupBarChart {
                configCellGroupBarChart(cellChart, chartItem, indexPath)
                
            } else if let cellChart = cell as? LineChartCollectionViewCell,
                let chartItem = item as? ItemDashboardDataLineChart {
                configCellLineChart(cellChart, chartItem, indexPath)
                
            } else if let cellGroupBarChart = cell as? PieChart2CollectionViewCell,
                let chartItem = item as? ItemDashboardDataPieChart {
                configCellPieChart(cellGroupBarChart, chartItem, indexPath)
                
            } else if let cellAreaChart = cell as? AreaChartCollectionViewCell,
                let chartItem = item as? ItemDashboardDataAreaChart {
                configCellAriaChart(cellAreaChart, chartItem, indexPath)
                
            } else if let cellStackBarChart = cell as? StackBarChartCollectionViewCell,
                let chartItem = item as? ItemDashboardDataStackBarChart {
                configCellStackBarChart(cellStackBarChart, chartItem, indexPath)
                
            } else if let itemCell = cell as? TargetDetailCollectionViewCell,
                let itemDetail = item as? ItemDashboardDataItem {
                itemCell.bindingData(model: itemDetail.data)
                itemCell.btnInfor.isHidden = !isShowInfor
                itemCell.btnPin.isHidden = !isShowPin
                itemCell.delegate = self
                
            } else if let cellReport = cell as? DashboardReportCollectionViewCell,
                let reportData = item as? ItemDashBoardReportModel {
                configCellReport(cellReport, reportData, indexPath)
                
            } else if let cellHorizontalStackBarChart = cell as? HorizontalStackBarChartCollectionViewCell,
                let chartItem = item as? ItemDashboardDataHorizontalStackBarChart {
                configCellHorizontalStackBarChart(cellHorizontalStackBarChart, chartItem, indexPath)
                
            } else if let combineCell = cell as? CombineChartCollectionViewCell,
                let data = item as? ItemDashboardDataCombineBarChart {
                configCellCombineChart(combineCell, data, indexPath)
                
            } else if let rankingCell = cell as? RankingCollectionViewCell,
                let data = item as? ItemDashboardDataRankingModel {
                configCellTableChart(rankingCell, data, indexPath)
                
            } else if let classReportCell = cell as? ClassReportCollectionViewCell,
                let data = item as? ItemClassReportModel {
                configClassReportChart(classReportCell, data, indexPath)
                
            } else if let radarCell = cell as? RadarChartCollectionViewCell,
                let data = item as? ItemDashboardDataRadarChart {
                configCellRadarChart(radarCell, data, indexPath)
                
            } else if let rankingInfoCell = cell as? RankingInfoCollectionViewCell,
                let data = item as? ItemDashboardDataRankingInfo {
                configRankingInfo(rankingInfoCell, data, indexPath)
                
            } else if let rankingInfoCell = cell as? AspectInfoCollectionViewCell,
                let data = item as? ItemDashboardDataAspectInfo {
                configAspectInfo(rankingInfoCell, data, indexPath)
            } else if let treemapCell = cell as? TreemapCollectionViewCell,
                let data = item as? ItemDashboardDataTreeMap {
                //binding cell
                configTreemapCell(treemapCell, data, indexPath)
                
            } else if let cellCandleChart = cell as? CandleStickChartCollectionViewCell,
                let chartItem = item as? ItemDashboardDataCandleStickChart {
                configCellCandleStickChart(cellCandleChart, chartItem, indexPath)
            } else if let guageChartCell = cell as? GaugeChartCollectionViewCell,
                let data = item as? GuageChartDataDTO {
                configGuageChart(guageChartCell, data, indexPath)
            }
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, allowMoveAt indexPath: IndexPath) -> Bool {
        if isCanDropDragCell {
            return isCanMove
        } else {
            return false
        }
    }

    func configGuageChart(_ cell: GaugeChartCollectionViewCell,
                          _ chartItem: GuageChartDataDTO,
                          _ indexPath: IndexPath) {

        cell.draw(data: chartItem.data,
                  legendTitleNumberOfLines: viewModel.getNumberLegendInLine(),
                  legendMaxRow: viewModel.getMaxLineLegend(),
                  drawPercentInsidePie: false,
                  drawPieValues: true, isShowDesc: isShowDesc)

        cell.chart.drillDown = self.drilldownPieChart
        cell.chart.delegate = self
        cell.delegate = self
        if hiddenZoomAndMenu {
            cell.menuButton.isHidden = hiddenZoomAndMenu
            cell.menuButton.snp.makeConstraints({ (maker) in
                maker.width.equalTo(0)
            })
            cell.zoomButton.isHidden = hiddenZoomAndMenu
        } else {
            cell.menuButton.isHidden = isOnlyShowZoom
            cell.zoomButton.isHidden = !isOnlyShowZoom
        }

        cell.btnInfor.isHidden = true

        cell.btnInforWithConstrain?.constant = cell.btnInfor.isHidden ? 0 : cell.btnInfor.frame.size.height
        cell.btnPin.isHidden = !isShowPin

        //config title and desc in base chart
        if !cell.chart.contentView.isShowMenu {
            cell.chart.contentView.isShowMenu = !hiddenZoomAndMenu
        }
        if !cell.chart.contentView.isShowInfo {
            cell.chart.contentView.isShowInfo = !cell.btnInfor.isHidden
        }
        if !cell.chart.contentView.isShowPin {
            cell.chart.contentView.isShowPin = !cell.btnPin.isHidden
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        at: IndexPath,
                        willMoveTo toIndexPath: IndexPath) {

    }

    func collectionView(_ collectionView: UICollectionView,
                        at atIndexPath: IndexPath,
                        didMoveTo toIndexPath: IndexPath) {
        if atIndexPath != toIndexPath, atIndexPath.section == 0 {
            let model: ItemDashboardDataModel = viewModel.getItemAtIndexPath(atIndexPath)
            viewModel.doRemoveItemAtIndexPath(atIndexPath)
            viewModel.doInsertItem(model, at: toIndexPath)
            isSortedItem = true
        }
    }

    func collectionView(_ collectionView: UICollectionView, collectionView layout: RAReorderableLayout, didEndDraggingItemTo indexPath: IndexPath) {
        if collectionView.numberOfSections == 1 {
            if isSortedItem {
                self.sort?.didSortData(viewModel.getDataInSection(indexPath.section))
            }
            isSortedItem = false
        }
    }

    func scrollTrigerEdgeInsetsInCollectionView(_ collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsets(top: 100.0, left: 100.0, bottom: 100.0, right: 100.0)
    }

    func collectionView(_ collectionView: UICollectionView, reorderingItemAlphaInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 0.3
        }
    }

    func scrollTrigerPaddingInCollectionView(_ collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsetsMake(collectionView.contentInset.top, 0, collectionView.contentInset.bottom, 0)
    }

    // MARK: 
    // MARK: CELL
    fileprivate func configCellGroupBarChart(_ cell: GroupBarChartCollectionViewCell,
                                             _ chartItem: ItemDashboardDataGroupBarChart,
                                             _ indexPath: IndexPath ) {
        cell.keyCommentListSingleColumn = (chartItem.data?.keyCommentListPoints)!
        cell.dateListSingleColumn = (chartItem.data?.dateListPoints)!
        cell.commentStateList = commentStateList
        cell.changeCommentImageForTheFirstTime(isActive: commentStateList[chartItem.uuid], isHavingComment: chartItem.data?.haveComment)
        cell.changeLabel(isActive: commentStateList[chartItem.uuid]!, item: chartItem)
        cell.draw(chartItem.data,
                  legendTitleNumberOfLines: viewModel.getNumberLegendInLine(),
                  legendMaxRow: viewModel.getMaxLineLegend(),
                  isShowDesc: isShowDesc)

        cell.chart.delegate = self
        cell.delegate = self
        if hiddenZoomAndMenu {
            cell.menuButton.snp.makeConstraints({ (maker) in
                maker.width.equalTo(0)
            })
            cell.zoomButton.isHidden = hiddenZoomAndMenu
            cell.comment1Button.isHidden = isHiddenComment1
            cell.comment2Button.isHidden = true
        } else {
            cell.menuButton.isHidden = isOnlyShowZoom
            cell.zoomButton.isHidden = !isOnlyShowZoom
            cell.comment1Button.isHidden = isHiddenComment1
            cell.comment2Button.isHidden = true
        }

        cell.btnInfor.isHidden = true
        if !cell.chart.contentView.isShowMenu {
            cell.chart.contentView.isShowMenu = !isHiddenComment1
            cell.chart.contentView.isShowMenu = !hiddenZoomAndMenu
        }
        if !cell.chart.contentView.isShowInfo {
            cell.chart.contentView.isShowInfo = !cell.btnInfor.isHidden
        }

        if let appContext = context,
            appContext == AppContext.dashBoardDetailTrend {
            cell.chart.chartView.hoverDelegate = self
            cell.chart.chartView.isDrillDownWhenTap = drilldownGroupChart
            cell.chart.chartView.indexPath = indexPath
        }

    }

    fileprivate func configCellLineChart(_ cell: LineChartCollectionViewCell,
                                         _ chartItem: ItemDashboardDataLineChart,
                                         _ indexPath: IndexPath) {
        cell.keyCommentListLines = (chartItem.data?.keyCommentListPoints)!
        cell.dateListLines = (chartItem.data?.dateListPoints)!
        cell.commentStateList = commentStateList
        cell.changeCommentImageForTheFirstTime(isActive: commentStateList[chartItem.uuid], isHavingComment: chartItem.data?.haveComment)
        cell.changeLabel(isActive: commentStateList[chartItem.uuid]!, item: chartItem)
        cell.draw(chartItem.data,
                  legendTitleNumberOfLines: viewModel.getNumberLegendInLine(),
                  legendMaxRow: viewModel.getMaxLineLegend(),
                  isShowDesc: isShowDesc)

        cell.chart.delegate = self
        cell.delegate = self
        if hiddenZoomAndMenu {
            cell.menuButton.isHidden = hiddenZoomAndMenu
            cell.menuButton.snp.makeConstraints({ (maker) in
                maker.width.equalTo(0)
            })
            cell.zoomButton.isHidden = hiddenZoomAndMenu
            cell.comment1Button.isHidden = isHiddenComment1
            cell.comment2Button.isHidden = true
        } else {
            cell.menuButton.isHidden = isOnlyShowZoom
            cell.zoomButton.isHidden = !isOnlyShowZoom
            cell.comment1Button.isHidden = isHiddenComment1
            cell.comment2Button.isHidden = true
        }
        cell.btnInfor.isHidden = true

        cell.btnInforWithConstrain?.constant = cell.btnInfor.isHidden ? 0 : cell.btnInfor.frame.size.height
        cell.btnPin.isHidden = !isShowPin

        //config title and desc in base chart
        if !cell.chart.contentView.isShowMenu {
            cell.chart.contentView.isShowMenu = !isHiddenComment1
            cell.chart.contentView.isShowMenu = !hiddenZoomAndMenu
        }
        if !cell.chart.contentView.isShowInfo {
            cell.chart.contentView.isShowInfo = !cell.btnInfor.isHidden
        }
        if !cell.chart.contentView.isShowPin {
            cell.chart.contentView.isShowPin = !cell.btnPin.isHidden
        }
        if let appContext = context, appContext == AppContext.dashBoardDetailTrend {
            cell.chart.lineChart.hoverDelegate = self
            cell.chart.lineChart.indexPath = indexPath
        }
    }

    fileprivate func configCellCandleStickChart(_ cell: CandleStickChartCollectionViewCell,
                                         _ chartItem: ItemDashboardDataCandleStickChart,
                                         _ indexPath: IndexPath) {
        cell.draw(chartItem.data,
                  legendTitleNumberOfLines: viewModel.getNumberLegendInLine(),
                  legendMaxRow: viewModel.getMaxLineLegend(),
                  isShowDesc: isShowDesc)

        cell.chart.delegate = self
        cell.delegate = self
        if hiddenZoomAndMenu {
            cell.menuButton.isHidden = hiddenZoomAndMenu
            cell.menuButton.snp.makeConstraints({ (maker) in
                maker.width.equalTo(0)
            })
            cell.zoomButton.isHidden = hiddenZoomAndMenu
        } else {
            cell.menuButton.isHidden = isOnlyShowZoom
            cell.zoomButton.isHidden = !isOnlyShowZoom
        }
        cell.btnInfor.isHidden = true

        cell.btnInforWithConstrain?.constant = cell.btnInfor.isHidden ? 0 : cell.btnInfor.frame.size.height
        cell.btnPin.isHidden = !isShowPin

        //config title and desc in base chart
        if !cell.chart.contentView.isShowMenu {
            cell.chart.contentView.isShowMenu = !hiddenZoomAndMenu
        }
        if !cell.chart.contentView.isShowInfo {
            cell.chart.contentView.isShowInfo = !cell.btnInfor.isHidden
        }
        if !cell.chart.contentView.isShowPin {
            cell.chart.contentView.isShowPin = !cell.btnPin.isHidden
        }
    }

    fileprivate func configCellPieChart(_ cell: PieChart2CollectionViewCell,
                                        _ chartItem: ItemDashboardDataPieChart,
                                        _ indexPath: IndexPath ) {
        cell.draw(chartItem.data,
                  legendTitleNumberOfLines: viewModel.getNumberLegendInLine(),
                  legendMaxRow: viewModel.getMaxLineLegend(),
                  drawPercentInsidePie: false,
                  drawPieValues: true,
                  isShowDesc: isShowDesc)
        
        cell.chart.drillDown = chartItem.data?.objectType == .group ? true : self.drilldownPieChart
        cell.chart.delegate = self
        cell.delegate = self
        if hiddenZoomAndMenu {
            cell.menuButton.isHidden = hiddenZoomAndMenu
            cell.menuButton.snp.makeConstraints({ (maker) in
                maker.width.equalTo(0)
            })
            cell.zoomButton.isHidden = hiddenZoomAndMenu
        } else {
            cell.menuButton.isHidden = isOnlyShowZoom
            cell.zoomButton.isHidden = !isOnlyShowZoom
        }

        cell.btnInfor.isHidden = true

        cell.btnInforWithConstrain?.constant = cell.btnInfor.isHidden ? 0 : cell.btnInfor.frame.size.height
        cell.btnPin.isHidden = !isShowPin

        //config title and desc in base chart
        if !cell.chart.contentView.isShowMenu {
            cell.chart.contentView.isShowMenu = !hiddenZoomAndMenu
        }
        if !cell.chart.contentView.isShowInfo {
            cell.chart.contentView.isShowInfo = !cell.btnInfor.isHidden
        }
        if !cell.chart.contentView.isShowPin {
            cell.chart.contentView.isShowPin = !cell.btnPin.isHidden
        }
    }

    fileprivate func configCellAriaChart(_ cell: AreaChartCollectionViewCell,
                                         _ chartItem: ItemDashboardDataAreaChart,
                                         _ indexPath: IndexPath ) {
        cell.keyCommentListSingleColumn = (chartItem.data?.keyCommentListPoints)!
        cell.dateListSingleColumn = (chartItem.data?.dateListPoints)!
        cell.commentStateList = commentStateList
        cell.changeCommentImageForTheFirstTime(isActive: commentStateList[chartItem.uuid], isHavingComment: chartItem.data?.haveComment)
        cell.changeLabel(isActive: commentStateList[chartItem.uuid]!, item: chartItem)
        cell.draw(chartItem,
                  legendTitleNumberOfLines: viewModel.getNumberLegendInLine(),
                  legendMaxRow: viewModel.getMaxLineLegend(),
                  isShowDesc: isShowDesc)

        cell.chart.delegate = self
        cell.delegate = self
        if hiddenZoomAndMenu {
            cell.menuButton.isHidden = hiddenZoomAndMenu
            cell.menuButton.snp.makeConstraints({ (maker) in
                maker.width.equalTo(0)
            })
            cell.zoomButton.isHidden = hiddenZoomAndMenu
            cell.comment1Button.isHidden = isHiddenComment1
            cell.comment2Button.isHidden = true
        } else {
            cell.menuButton.isHidden = isOnlyShowZoom
            cell.zoomButton.isHidden = !isOnlyShowZoom
            cell.comment1Button.isHidden = isHiddenComment1
            cell.comment2Button.isHidden = true
        }

        cell.btnInfor.isHidden = true
        //config title and desc in base chart
        if !cell.chart.contentView.isShowMenu {
            cell.chart.contentView.isShowMenu = !isHiddenComment1
            cell.chart.contentView.isShowMenu = !hiddenZoomAndMenu
        }
        if !cell.chart.contentView.isShowInfo {
            cell.chart.contentView.isShowInfo = !cell.btnInfor.isHidden
        }
        if let appContext = context, appContext == AppContext.dashBoardDetailTrend {
            cell.chart.chart.hoverDelegate = self
            cell.chart.chart.indexPath = indexPath
        }
    }

    fileprivate func configCellStackBarChart(_ cell: StackBarChartCollectionViewCell,
                                             _ chartItem: ItemDashboardDataStackBarChart,
                                             _ indexPath: IndexPath ) {
        cell.chartView.delegate = self
        cell.delegate = self
        cell.keyCommentListSingleColumn = (chartItem.data?.keyCommentListPoints)!
        cell.dateListSingleColumn = (chartItem.data?.dateListPoints)!
        cell.commentStateList = commentStateList
        cell.changeCommentImageForTheFirstTime(isActive: commentStateList[chartItem.uuid], isHavingComment: chartItem.data?.haveComment)
        cell.changeLabel(isActive: commentStateList[chartItem.uuid]!, item: chartItem)
        cell.draw(chartItem,
                  legendTitleNumberOfLines: viewModel.getNumberLegendInLine(),
                  legendMaxRow: viewModel.getMaxLineLegend(),
                  isShowDesc: isShowDesc)
        if hiddenZoomAndMenu {
            cell.menuButton.isHidden = hiddenZoomAndMenu
            cell.menuButton.snp.makeConstraints({ (maker) in
                maker.width.equalTo(0)
            })
            cell.zoomButton.isHidden = hiddenZoomAndMenu
            cell.comment1Button.isHidden = isHiddenComment1
            cell.comment2Button.isHidden = true
        } else {
            cell.menuButton.isHidden = isOnlyShowZoom
            cell.zoomButton.isHidden = !isOnlyShowZoom
            cell.comment1Button.isHidden = isHiddenComment1
            cell.comment2Button.isHidden = true
        }

        cell.btnInfor.isHidden = true
        cell.btnInforWithConstrain?.constant = cell.btnInfor.isHidden ? 0 : cell.btnInfor.frame.size.height
        cell.btnPin.isHidden = !isShowPin

        //config title and desc in base chart
        if !cell.chartView.contentView.isShowMenu {
            cell.chartView.contentView.isShowMenu = !isHiddenComment1
            cell.chartView.contentView.isShowMenu = !hiddenZoomAndMenu
        }
        if !cell.chartView.contentView.isShowInfo {
            cell.chartView.contentView.isShowInfo = !cell.btnInfor.isHidden
        }
        if !cell.chartView.contentView.isShowPin {
            cell.chartView.contentView.isShowPin = !cell.btnPin.isHidden
        }
        if let appContext = context, appContext == AppContext.dashBoardDetailTrend {
            cell.chartView.chartView.hoverDelegate = self
            cell.chartView.chartView.indexPath = indexPath
        }

    }

    fileprivate func configCellReport(_ cell: DashboardReportCollectionViewCell,
                                      _ reportData: ItemDashBoardReportModel,
                                      _ indexPath: IndexPath ) {
        if hiddenZoomAndMenu {
            cell.menuButton.isHidden = hiddenZoomAndMenu//
            cell.menuButton.snp.makeConstraints({ (maker) in
                maker.width.equalTo(0)
            })
            cell.btnZoom.isHidden = hiddenZoomAndMenu
        } else {
            cell.btnZoom.isHidden = true
            cell.menuButton.isHidden = !cell.btnZoom.isHidden
        }
        if isShowZoom {
            cell.menuButton.isHidden = isShowZoom
            cell.btnZoom.isHidden = !isShowZoom
        }
        cell.itemReportModel = reportData
        cell.isShowDesc = self.isShowDesc
        cell.bindingData(reportData.data)
        cell.delegate = self

        if isShowCompressNumber {
            cell.btnComresssData.isHidden = false
        } else {
            cell.btnComresssData.isHidden = true
        }

        cell.withButtonCompressLayout?.constant = cell.btnComresssData.isHidden ? 0 : cell.btnComresssData.frame.size.height
        cell.btnPin.isHidden = !isShowPin
        cell.btnPinWithConstrain?.constant = cell.btnPin.isHidden ? 0 : cell.btnPin.frame.size.height

    }

    fileprivate func configCellHorizontalStackBarChart(_ cell: HorizontalStackBarChartCollectionViewCell,
                                                       _ data: ItemDashboardDataHorizontalStackBarChart,
                                                       _ indexPath: IndexPath ) {
        cell.chartView.delegate = self
        cell.delegate = self
        cell.draw(data.data,
                  legendTitleNumberOfLines: viewModel.getNumberLegendInLine(),
                  legendMaxRow: viewModel.getMaxLineLegend(),
                  isShowDesc: isShowDesc)
        if hiddenZoomAndMenu {
            cell.menuButton.isHidden = hiddenZoomAndMenu
            cell.menuButton.snp.makeConstraints({ (maker) in
                maker.width.equalTo(0)
            })
            cell.zoomButton.isHidden = hiddenZoomAndMenu
        } else {
            cell.menuButton.isHidden = isOnlyShowZoom
            cell.zoomButton.isHidden = !isOnlyShowZoom
        }

        cell.btnInfor.isHidden = true
        //config title and desc in base chart
        if !cell.chartView.contentView.isShowMenu {
            cell.chartView.contentView.isShowMenu = !hiddenZoomAndMenu
        }
        if !cell.chartView.contentView.isShowInfo {
            cell.chartView.contentView.isShowInfo = !cell.btnInfor.isHidden
        }
    }

    fileprivate func configCellCombineChart(_ cell: CombineChartCollectionViewCell,
                                            _ data: ItemDashboardDataCombineBarChart,
                                            _ indexPath: IndexPath ) {

        cell.delegate = self
        cell.chart.delegate = self
        cell.keyCommentListSingleColumn = data.keyCommentListSingleColumn
        cell.dateListSingleColumn = data.dateListSingleColumn
        cell.commentStateList = commentStateList
        cell.changeCommentImageForTheFirstTime(isActive: commentStateList[data.uuid], isHavingComment: data.haveComment)
        cell.changeLabel(isActive: commentStateList[data.uuid]!, item: data)
        cell.draw(data: data,
                  legendTitleNumberOfLines: viewModel.getNumberLegendInLine(),
                  legendMaxRow: viewModel.getMaxLineLegend(),
                  isShowDesc: isShowDesc)

        if hiddenZoomAndMenu {
            cell.menuButton.isHidden = hiddenZoomAndMenu
            cell.menuButton.snp.makeConstraints({ (maker) in
                maker.width.equalTo(0)
            })
            cell.zoomButton.isHidden = hiddenZoomAndMenu
            cell.comment1Button.isHidden = isHiddenComment1
            cell.comment2Button.isHidden = true
        } else {
            cell.menuButton.isHidden = isOnlyShowZoom
            cell.zoomButton.isHidden = !isOnlyShowZoom
            cell.comment1Button.isHidden = isHiddenComment1
            cell.comment2Button.isHidden = true
        }
        if parentGroupId == DASHBOARD_CBBT_GROUP_ID {
            cell.comment1Button.isHidden = true
            cell.comment2Button.isHidden = true
        }
        cell.btnInfor.isHidden = true
        cell.btnInforWithConstrain?.constant = cell.btnInfor.isHidden ? 0 : cell.btnInfor.frame.size.height
        cell.btnPin.isHidden = !isShowPin

        //config title and desc in base chart
        if !cell.chart.contentView.isShowMenu {
            cell.chart.contentView.isShowMenu = !isHiddenComment1
            cell.chart.contentView.isShowMenu = !hiddenZoomAndMenu
        }
        if !cell.chart.contentView.isShowInfo {
            cell.chart.contentView.isShowInfo = !cell.btnInfor.isHidden
        }
        if !cell.chart.contentView.isShowPin {
            cell.chart.contentView.isShowPin = !cell.btnPin.isHidden
        }

        if let appContext = context, appContext == AppContext.dashBoardDetailTrend {
            cell.chart.chartView.hoverDelegate = self
            cell.chart.chartView.isDrillDownWhenTap = drilldownCombineChart
            cell.chart.chartView.indexPath = indexPath
        }
    }

    fileprivate func configCellTableChart(_ cell: RankingCollectionViewCell,
                                          _ data: ItemDashboardDataRankingModel,
                                          _ indexPath: IndexPath ) {
        
        cell.isLastTable = ((viewModel.getData()).count == indexPath.section + 1) && (viewModel.getData()[indexPath.section].listBlock.count == indexPath.row + 1 )
        cell.draw(data)
        cell.delegate = self
        cell.delegateSheetView = self
        cell.backgroundColor = UIColor.white
        cell.attachButton.isHidden = !isShowPin
        cell.btnInfor.isHidden = true
        cell.viewController = wireFrame.viewController

        cell.btnInforWithConstrain?.constant = cell.btnInfor.isHidden ? 0 : cell.btnInfor.frame.size.height
        cell.btnAttachWithConstrain?.constant = cell.attachButton.isHidden ? 0 : cell.attachButton.frame.size.height
        if fromScreen == LeftMenu.advanceSearch {
            data.moreMenuAction = data.moreMenuAction.filter({ $0.type != .defineService })
        }
        if hiddenZoomAndMenu  {
            cell.btnMenu.isHidden = hiddenZoomAndMenu
            cell.btnMenu.snp.makeConstraints({ (maker) in
                maker.width.equalTo(0)
            })
            cell.btnZoom.isHidden = hiddenZoomAndMenu
        } else {
            cell.btnMenu.isHidden = isOnlyShowZoom
            cell.btnZoom.isHidden = !isOnlyShowZoom
        }
    }

    fileprivate func configCellRadarChart(_ cell: RadarChartCollectionViewCell,
                                          _ data: ItemDashboardDataRadarChart,
                                          _ indexPath: IndexPath ) {

        cell.delegate = self
        cell.draw(data: data.getChartData(),
                  legendTitleNumberOfLines: viewModel.getNumberLegendInLine(),
                  legendMaxRow: viewModel.getMaxLineLegend(),
                  isShowDesc: isShowDesc)
        cell.backgroundColor = UIColor.white
        cell.btnPin.isHidden = !isShowPin
        cell.btnInfor.isHidden = true

        cell.btnInforWithConstrain?.constant = cell.btnInfor.isHidden ? 0 : cell.btnInfor.frame.size.height

        if hiddenZoomAndMenu {
            cell.menuButton.isHidden = hiddenZoomAndMenu
            cell.menuButton.snp.makeConstraints({ (maker) in
                maker.width.equalTo(0)
            })
            cell.zoomButton.isHidden = hiddenZoomAndMenu
        } else {
            cell.menuButton.isHidden = isOnlyShowZoom
            cell.zoomButton.isHidden = !isOnlyShowZoom
        }
    }

    fileprivate func configClassReportChart(_ cell: ClassReportCollectionViewCell,
                                            _ data: ItemClassReportModel,
                                            _ indexPath: IndexPath ) {
        cell.billData(data)
        cell.lblDesc.isHidden = !isShowDesc
    }

    fileprivate func configRankingInfo(_ cell: RankingInfoCollectionViewCell,
                                       _ data: ItemDashboardDataRankingInfo,
                                       _ indexPath: IndexPath ) {
        cell.bindingData(data: data)
    }

    fileprivate func configAspectInfo(_ cell: AspectInfoCollectionViewCell,
                                      _ data: ItemDashboardDataAspectInfo,
                                      _ indexPath: IndexPath ) {
        cell.delegateAspest = self
        cell.bindingData(data)
    }

    fileprivate func configTreemapCell(_ cell: TreemapCollectionViewCell,
                                       _ data: ItemDashboardDataTreeMap,
                                       _ indexPath: IndexPath ) {
        cell.cellDelegate = self
        cell.delegate = self
        cell.indexPath = indexPath
        cell.bindingData(data)
        cell.btnPin.isHidden = !isShowPin
        cell.btnInfor.isHidden = true

        cell.btnInforWithConstrain?.constant = cell.btnInfor.isHidden ? 0 : cell.btnInfor.frame.size.height
        cell.btnAttachWithConstrain?.constant = cell.btnPin.isHidden ? 0 : cell.btnPin.frame.size.height

        if hiddenZoomAndMenu {
            cell.menuButton.isHidden = hiddenZoomAndMenu
            cell.menuButton.snp.makeConstraints({ (maker) in
                maker.width.equalTo(0)
            })
            cell.zoomButton.isHidden = hiddenZoomAndMenu
        } else {
            cell.menuButton.isHidden = isOnlyShowZoom
            cell.zoomButton.isHidden = !isOnlyShowZoom
        }
    }
}

extension BaseListChartCollectionView: GBaseChartViewDelegate {
    internal func didSelectedLegend(legend: LegendModel, searchItem: DashboardSearchCritieria?) {
        if drillDownDelegate != nil {
            drillDownDelegate?.baseListChartCollectionView(self, didDrillDownLegend: legend, searchItem: searchItem)
        } else if delegate != nil {
            delegate?.baseListChartCollectionView(self, didSelectLegend: legend, searchItem: searchItem)
        } else {
            wireFrame.doDrillDownChart(legend, searchItem)
        }
    }
}

extension BaseListChartCollectionView: GBaseCombineChartViewDelegate {
    
    func didShowNewHoverViewAtGroupIndex(chart: CombinedChartView, listLb: [String], listVale: [Double], nameChart: String) {
        //do nothing
    }
    
    func callApiFromCombine(commentDataDTO: CommentDataDTO, cycleTime: String, completion: @escaping ([CommentItem]?,Error?) -> Void) {
        drillDownDelegate?.callApiController(commentDataDTO: commentDataDTO, cycleTime: cycleTime, completion: { (reponse,error) in
            completion(reponse,error)
        })
    }

    func didShowHoverViewAtGroupIndex(chart: GBaseCombineChartView, data: [EntryDataModel]) {

    }

    func disableComment() {

    }

    internal func didDrillDownWhenTapAtGroupIndex(chart: GBaseCombineChartView, data: EntryDataModel) {
        if drillDownDelegate != nil {
            drillDownDelegate?.baseListChartCollectionView(self, didDrillDownCombineChart: data, searchItem: nil)
        }
    }
    internal func navicationAddCommentController(sender: Any,
                                                      _ location: CGPoint,
                                                      _ comments: [CommentDTO],
                                                      _ listObjectCmt: [[ObjectComment]],
                                                      _ chartEntry: SingleModelComment,
                                                      _ cycleTime: String) {
        if drillDownDelegate != nil {
            drillDownDelegate?.navicationAddCommentController(sender:sender, location, comments, listObjectCmt, chartEntry, cycleTime)
        }
    }

    func reloadData(indexPath: IndexPath) {
        doReloadNumberItemInLine(indexPath)
    }
}

extension BaseListChartCollectionView: GBaseLineChartViewDelegate {
    func callApiFromLineChart(commentDataDTO: CommentDataDTO, cycleTime: String, completion: @escaping ([CommentItem]?, Error?) -> Void) {
        drillDownDelegate?.callApiController(commentDataDTO: commentDataDTO, cycleTime: cycleTime, completion: { (reponse,error) in
            completion(reponse,error)
        })
    }

    func reloadDataLine(indexPath: IndexPath) {
        doReloadNumberItemInLine(indexPath)
    }

    func navigateCommentLineChart(sender: Any, _ location: CGPoint, _ comments: [CommentDTO], _ listObjectCmt: [[ObjectComment]], _ chartEntry: SingleModelComment, _ cycleTime: String) {
        drillDownDelegate?.navicationAddCommentController(sender:sender, location, comments, listObjectCmt, chartEntry, cycleTime)
    }

    func didShowHoverViewWithData(chart: GBaseLineChartView, data: [EntryDataModel]) {
        DLog("Even@@@")
    }
}
extension BaseListChartCollectionView: GBaseAreaLineChartViewDelegate {
    func callApiFromAreaLine(commentDataDTO: CommentDataDTO, cycleTime: String, completion: @escaping ([CommentItem]?,Error?) -> Void) {
        drillDownDelegate?.callApiController(commentDataDTO: commentDataDTO, cycleTime: cycleTime, completion: { (reponse,error) in
            completion(reponse,error)
        })
    }

    func reloadDataAreaLineChart(indexPath: IndexPath) {
        doReloadNumberItemInLine(indexPath)
    }

    func didShowHoverViewWithAreaData(chart: GBaseAreaLineChartView, data: EntryDataModel?) {

    }

    func navigateCommentAreaLineChart(sender: Any, _ location: CGPoint, _ comments: [CommentDTO], _ listObjectCmt: [[ObjectComment]], _ chartEntry: SingleModelComment, _ cycleTime: String) {
        drillDownDelegate?.navicationAddCommentController(sender:sender, location, comments, listObjectCmt, chartEntry, cycleTime)
    }

}

extension BaseListChartCollectionView: GBaseVerticalStackBarChartViewDelegate {
    func callApiFromVerticalStack(commentDataDTO: CommentDataDTO, cycleTime: String, completion: @escaping ([CommentItem]?, Error?) -> Void) {
        drillDownDelegate?.callApiController(commentDataDTO: commentDataDTO, cycleTime: cycleTime, completion: { (reponse,error) in
            completion(reponse, error)
        })
    }

    func reloadDataVerticalStackBar(indexPath: IndexPath) {
        doReloadNumberItemInLine(indexPath)
    }

    func didShowHoverViewAtStackIndex(chart: GBaseVerticalStackBarChartView, groupIndex: Int, data: EntryDataModel?) {
    }

    func navigateCommentVerticalStackBarChart(sender: Any, _ location: CGPoint, _ comments: [CommentDTO], _ listObjectCmt: [[ObjectComment]], _ chartEntry: SingleModelComment, _ cycleTime: String) {
        drillDownDelegate?.navicationAddCommentController(sender:sender, location, comments, listObjectCmt, chartEntry, cycleTime)
    }

}

extension BaseListChartCollectionView: GBaseGroupBarChartViewDelegate {
    func callApiFromGroupBar(commentDataDTO: CommentDataDTO, cycleTime: String, completion: @escaping ([CommentItem]?, Error?) -> Void) {
        drillDownDelegate?.callApiController(commentDataDTO: commentDataDTO, cycleTime: cycleTime, completion: { (reponse,error) in
            completion(reponse,error)
        })
    }

    func reloadDataGroupBar(indexPath: IndexPath) {
        doReloadNumberItemInLine(indexPath)
    }

    func navigateCommentGroupBarChart(sender: Any, _ location: CGPoint, _ comments: [CommentDTO], _ listObjectCmt: [[ObjectComment]], _ chartEntry: SingleModelComment, _ cycleTime: String) {
        drillDownDelegate?.navicationAddCommentController(sender:sender, location, comments, listObjectCmt, chartEntry, cycleTime)
    }

    func didShowHoverViewAtGroupIndex(chart: GBaseGroupBarChartView, groupIndex: Int, data: EntryDataModel?) {
        //...
    }

    func didDrillDownWhenTapAtGroupIndex(groupChart: GBaseGroupBarChartView, data: EntryDataModel) {
        if drillDownDelegate != nil {
            drillDownDelegate?.baseListChartCollectionView(self, didDrillDownCombineChart: data, searchItem: nil)
        }
    }
}

extension BaseListChartCollectionView: UICollectionViewDelegate {
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = viewModel.getData()
        
        if data[0].newDataDashBoard.count == 0 {
        let item: ItemDashboardDataModel = viewModel.getItemAtIndexPath(indexPath)
        if delegate != nil {
            if let data = item as? ItemDashBoardReportModel, !self.drilldownBlockInfor {
                wireFrame.doZoomChartWithData(data, self.titleZoomView, commentStateList[item.uuid], isHiddenComment1, indexPath)
            } else {

                var isCommentMode = false
                if let isCommentModeValue = commentStateList[item.uuid] {
                    isCommentMode = isCommentModeValue
                }
                delegate?.baseListChartCollectionView(self, didSelectItem: item, isCommentMode)

            }
        } else {
            if let data = item as? ItemDashBoardReportModel {
                if data.getfilterMetaData()?.serviceType == .all
                    || data.getfilterMetaData()?.serviceType == .unknow
                    || data.getfilterMetaData()?.serviceType == .group {
                    data.getFilterMetaData()?.searchCritieria?.serviceId = data.getFilterMetaData()?.serviceId
                    if self.drilldownBlockInfor {
                        if data.getfilterMetaData()?.serviceType == .group {
                            wireFrame.doShowTrendDetail(data.getFilterMetaData(), serviceId: nil,
                                                        wireFrame: self.wireFrame)
                        } else {
                            wireFrame.doShowTargetDetail(data.getFilterMetaData()?.searchCritieria) // dong doing 1
                        }
                    } else {
                        wireFrame.doZoomChartWithData(data, self.titleZoomView,
                                                      commentStateList[item.uuid], isHiddenComment1, indexPath)
                    }
                }
            } else if let guageData = item as? GuageChartDataDTO, let data = guageData.data {
                if data.filterMetadata?.serviceType == .all
                    || data.filterMetadata?.serviceType == .unknow
                    || data.filterMetadata?.serviceType == .group {
                    if true {
                        if data.filterMetadata?.serviceType == .group {
                            if self.drilldownBlockInfor {
                                if data.filterMetadata?.serviceType == .group {
                                    wireFrame.doShowTrendDetail(data.filterMetadata,
                                                                serviceId: nil,
                                                                wireFrame: self.wireFrame)
                                } else {
                                    wireFrame.doShowTargetDetail(data.filterMetadata?.searchCritieria)
                                }
                            } else {
                                wireFrame.doZoomChartWithData(guageData, self.titleZoomView,
                                                              commentStateList[item.uuid], isHiddenComment1, indexPath)
                            }
                        } else {
                            wireFrame.doShowTargetDetail(data.filterMetadata?.searchCritieria)
                        }
                    }
                }
            } else if let data = item as? ItemDashboardDataRankingInfo {
                if let filter = data.getfilterMetaData() {
                    if let searchCriterria = filter.searchCritieria?.clone() {
                        if searchCriterria.targets.count > 0 {
                            let filterRanking = RankingFilterModel(searchModel: searchCriterria)
                            filterRanking.doUpdateRankingType(filter.filterRanking)
                            wireFrame.doShowRankingViewController(filterRanking)
                        }
                    }
                }
            } else if item is ItemDashboardDataLineChart {
                if let appContext = context,
                    appContext == AppContext.dashBoardDetailTrend,
                    item.getFilterMetaData()?.filterRanking != nil {
                    wireFrame.chartZoomDelegate = self
                    wireFrame.doZoomChartWithDataAndContext(item, self.titleZoomView, appContext,
                                                            commentStateList[item.uuid],
                                                            isHiddenComment1, indexPath)
                } else {
                    if item.type != .ranking {
                        wireFrame.chartZoomDelegate = self
                        wireFrame.doZoomChartWithData(item, self.titleZoomView, commentStateList[item.uuid], isHiddenComment1, indexPath)
                    }
                }
            } else if item is ItemDashboardDataGroupBarChart {
                if let appContext = context,
                    appContext == AppContext.dashBoardDetailTrend,
                    item.getFilterMetaData()?.filterRanking != nil {
                    wireFrame.chartZoomDelegate = self
                    wireFrame.doZoomChartWithDataAndContext(item, self.titleZoomView, appContext,
                                                            commentStateList[item.uuid],
                                                            isHiddenComment1, indexPath)
                } else {
                    if item.type != .ranking {
                        wireFrame.chartZoomDelegate = self
                        wireFrame.doZoomChartWithData(item, self.titleZoomView, commentStateList[item.uuid], isHiddenComment1, indexPath)
                    }
                }
            } else if item is ItemDashboardDataAreaChart {
                if let appContext = context,
                    appContext == AppContext.dashBoardDetailTrend,
                    item.getFilterMetaData()?.filterRanking != nil {
                    wireFrame.chartZoomDelegate = self
                    wireFrame.doZoomChartWithDataAndContext(item, self.titleZoomView, appContext,
                                                            commentStateList[item.uuid], isHiddenComment1,
                                                            indexPath)
                } else {
                    if item.type != .ranking {
                        wireFrame.chartZoomDelegate = self
                        wireFrame.doZoomChartWithData(item, self.titleZoomView, commentStateList[item.uuid], isHiddenComment1, indexPath)
                    }
                }
            } else if item is ItemDashboardDataStackBarChart {
                if let appContext = context,
                    appContext == AppContext.dashBoardDetailTrend,
                    item.getFilterMetaData()?.filterRanking != nil {
                    wireFrame.chartZoomDelegate = self
                    wireFrame.doZoomChartWithDataAndContext(item, self.titleZoomView, appContext,
                                                            commentStateList[item.uuid], isHiddenComment1,
                                                            indexPath)
                } else {
                    if item.type != .ranking {
                        wireFrame.chartZoomDelegate = self
                        wireFrame.doZoomChartWithData(item, self.titleZoomView, commentStateList[item.uuid], isHiddenComment1, indexPath)
                    }
                }
            } else if item is ItemDashboardDataCombineBarChart {
                if let appContext = context,
                    appContext == AppContext.dashBoardDetailTrend,
                    item.getFilterMetaData()?.filterRanking != nil {
                    wireFrame.chartZoomDelegate = self
                    wireFrame.doZoomChartWithDataAndContext(item, self.titleZoomView, appContext,
                                                            commentStateList[item.uuid], isHiddenComment1, indexPath)
                } else {
                    if item.type != .ranking {
                        wireFrame.chartZoomDelegate = self
                        wireFrame.doZoomChartWithData(item, self.titleZoomView, commentStateList[item.uuid], isHiddenComment1, indexPath)
                    }
                }
            } else {
                if let appContext = context,
                    appContext == AppContext.dashBoardDetailTrend,
                    item.getFilterMetaData()?.filterRanking != nil {
                    wireFrame.doZoomChartWithDataAndContext(item, self.titleZoomView, appContext, commentStateList[item.uuid], isHiddenComment1, indexPath)
                } else {
                    if item.type != .ranking {
                        var searchColumnIndex: Int?
                        if parentGroupId == DASHBOARD_CBBT_GROUP_ID {
                            searchColumnIndex = 1
                            (item as? ItemDashboardDataRankingModel)?.rankingData?.searchHint = "Tên chỉ số"
                        }
                        wireFrame.doZoomChartWithData(item, self.titleZoomView,
                                                      commentStateList[item.uuid], isHiddenComment1, indexPath, searchColumnIndex)
                    }
                }
            }
        }
        }
        
    }
}

extension BaseListChartCollectionView: UICollectionViewDelegateFlowLayout {
    internal func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 insetForSectionAt section: Int) -> UIEdgeInsets {

        if section == 1 {
            return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        }

        if let edgeInset = layout?.insetForSection(chartCollectionView: self, secion: section) {
            return edgeInset
        }

        if isIphoneApp() {
            return UIEdgeInsets(top: paddingTop, left: 0, bottom: 0, right: 0)
        }

        return UIEdgeInsets(top: padding, left: isShowPaddingLeft ? padding : 0, bottom: padding, right: padding)
    }

    internal func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath.section == 1, let list = self.searchSuggestion?.data {
            let height = CGFloat(list.count)*44.0 + 27.0
            let size: CGSize = CGSize(width: collectionView.frame.size.width, height: height)
            self.heightLastCell = size.height
            return size
        }
        
        let data = viewModel.getData()
        
        if data[0].newDataDashBoard.count == 0 {
            let item: ItemDashboardDataModel = viewModel.getItemAtIndexPath(indexPath)
            if item.type == .unknown {
                return CGSize.zero
            }
            
            if let size = layout?.sizeForItem(chartCollectionView: self, item: item, indexPath: indexPath) {
                self.heightLastCell = size.height
                return size
            }
        }

        let size: CGSize = self.caculatorSizeOfCellAtIndexPath(indexPath)
        self.heightLastCell = size.height
        return size
    }

    internal func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                 minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }

    func caculatorSizeOfCellAtIndexPath(_ indexPath: IndexPath) -> CGSize {
        
        if viewModel.getData()[0].newDataDashBoard.count == 0 {
            let item: ItemDashboardDataModel = viewModel.getItemAtIndexPath(indexPath)
            if isIphoneApp() {
                let width = collectionView.frame.size.width
                if item.type == .item ||
                    item.type == .report ||
                    item.type == .classReport ||
                    item.type == .rankingInfo ||
                    item.type == .aspectInfo {
                    return CGSize(width: width, height: GHeightItemCollection)
                } else if let data = item as? ItemDashboardDataRankingModel {
                    var height: CGFloat
                    // dashboard_cbbt detail table_view visible maximum 10 rows
                    if let count = data.rankingData?.listRow.count,
                        count > 10,
                        data.type == .ranking,
                        parentGroupId == DASHBOARD_CBBT_GROUP_ID {
                        height = RankingCollectionViewCell.heightFor10Rows()
                    } else {
                        height = RankingCollectionViewCell.height(
                            data,
                            isLastTable: viewModel.getDataInSection(indexPath.section).count == indexPath.row + 1
                        )
                    }

                    if height > collectionView.frame.size.height {
                        if data.type == .tableTrends {
                            height = collectionView.frame.size.height
                        } else {
                            height = collectionView.frame.size.height - padding
                        }
                    }
                    return CGSize(width: width, height: height)
                }
                
                let height = collectionView.frame.size.width + 60.0
                return CGSize(width: width, height: height)
            }
        }

        if itemSizeHafl {
            let width = (collectionView.frame.size.width  - (padding*3))/2
            let height = collectionView.frame.size.height - (padding*2)
            return CGSize(width: width, height: height)
        } else {
            let edge = self.collectionView(collectionView,
                                           layout: self.collectionView.collectionViewLayout,
                                           insetForSectionAt: indexPath.section)

            let numberItemInLine = CGFloat(viewModel.getNumberItemInLine())
            let maxLine     = CGFloat(viewModel.getMaxLine())
            let maxWidth    = collectionView.frame.size.width - edge.left - edge.right
            let maxHeight   = collectionView.frame.size.height - edge.top - edge.bottom
            let width      = (maxWidth - (numberItemInLine - 1)*padding)/numberItemInLine - 1.0
            let height      = (maxHeight - (maxLine - 1)*padding)/maxLine

            return CGSize(width: width, height: height)
        }
    }
}

extension BaseListChartCollectionView: ChartZoomViewControllerDelegate {
    
    func disableComment(uuid: String?, indexPath: IndexPath) {
        if let block = uuid {
            if block.isEmpty == false {
                if commentStateList[block] != nil {
                    commentStateList.updateValue(false, forKey: block)
                    doReloadNumberItemInLine(indexPath)
                }
            } else {
                DLog("uuid empty, contact server")
            }
        } else {

        }
    }
    
    /// dongChangeState
    func changeCommentState(uuid: String?, indexPath: IndexPath) {
        if let block = uuid, block.isEmpty == false {
                if let commentState = commentStateList[block] {
                    commentStateList.updateValue(!commentState, forKey: block)
                    doReloadNumberItemInLine(indexPath)
                }
        }
    }
    
    func reloadCommentData(indexPath: IndexPath, commentData: CommentDataDTO?) {
        if viewModel.getItemAtIndexPath(indexPath) is ItemDashboardDataCombineBarChart {
            let data = viewModel.getItemAtIndexPath(indexPath) as! ItemDashboardDataCombineBarChart
            if let comment = commentData {
                data.commentData = comment
            }
        }
        doReloadNumberItemInLine(indexPath)
    }
}

extension BaseListChartCollectionView: ChartCellActionDelegate {
    func cellActionAttach(_ cell: UICollectionViewCell, sender: UIView) {

        if let indexPath = self.collectionView.indexPath(for: cell) {
            let item: ItemDashboardDataModel = viewModel.getItemAtIndexPath(indexPath)
            if isCustomeDashboardEditMode {
                wireFrame.doEditBlock(item, sender)
            } else {
                wireFrame.doShowGroups(item, sender)
            }
        }
    }

    func cellActionMenu(_ cell: UICollectionViewCell, sender: UIView) {
        if let indexPath = self.collectionView.indexPath(for: cell) {
            wireFrame.tagTarget = self.tagTarget
            let item: ItemDashboardDataModel = viewModel.getItemAtIndexPath(indexPath)
            wireFrame.doShowMenuPopover(sender, item, indexPath)
        }
    }

    func cellActionZoom(_ cell: UICollectionViewCell, sender: UIView) {
        if let indexPath = self.collectionView.indexPath(for: cell) {
            wireFrame.tagTarget = self.tagTarget
            let item: ItemDashboardDataModel = viewModel.getItemAtIndexPath(indexPath)

            if delegate != nil {

                var isCommentMode = false
                if let isCommentModeValue = commentStateList[item.uuid] {
                    isCommentMode = isCommentModeValue
                }
                delegate?.baseListChartCollectionView(self, didSelectZoom: item, isCommentMode)

            } else {
                if let appContext = context,
                    appContext == AppContext.dashBoardDetailTrend,
                    item.getFilterMetaData()?.filterRanking != nil {
                    wireFrame.chartZoomDelegate = self
                    wireFrame.doZoomChartWithDataAndContext(item, self.titleZoomView,
                                                            appContext,
                                                            commentStateList[item.uuid],
                                                            isHiddenComment1,
                                                            indexPath)
                } else {
                    wireFrame.chartZoomDelegate = self
                    wireFrame.doZoomChartWithData(item,
                                                  self.titleZoomView,
                                                  commentStateList[item.uuid],
                                                  isHiddenComment1,
                                                  indexPath)
                }
            }
        }
    }

    func cellActionComment(_ cell: UICollectionViewCell, sender: UIView) {
        if let indexPath = self.collectionView.indexPath(for: cell) {
            wireFrame.tagTarget = self.tagTarget
            let item: ItemDashboardDataModel = viewModel.getItemAtIndexPath(indexPath)
            if let lineCell = cell as? LineChartCollectionViewCell, let data = item as? ItemDashboardDataLineChart {
                lineCell.checkAndChangeComment(sender: sender,
                                               isActive: !commentStateList[data.uuid]!,
                                               isHavingComment: data.data?.haveComment, completion:{ (isActive) in
                                                self.commentStateList.updateValue(isActive, forKey: item.uuid)
                                                lineCell.commentStateList = self.commentStateList
                                                lineCell.updateCommentStateListInSon()
                                                lineCell.changeLabel(isActive: isActive, item: data)
                                                
                })
                
            } else if let groupBarCell = cell as? GroupBarChartCollectionViewCell, let data = item as? ItemDashboardDataGroupBarChart {
                groupBarCell.checkAndChangeComment(sender: sender,
                                                   isActive: !commentStateList[item.uuid]!,
                                                   isHavingComment: data.data?.haveComment, completion:{ (isActive) in
                                                    self.commentStateList.updateValue(isActive, forKey: item.uuid)
                                                    groupBarCell.commentStateList = self.commentStateList
                                                    groupBarCell.updateCommentStateListInSon()
                                                    groupBarCell.changeLabel(isActive: isActive, item: data)
                })
            } else if let areaCell = cell as? AreaChartCollectionViewCell, let data = item as? ItemDashboardDataAreaChart {
                areaCell.checkAndChangeComment(sender: sender,
                                               isActive: !commentStateList[item.uuid]!,
                                               isHavingComment: data.data?.haveComment, completion:{ (isActive) in
                                                self.commentStateList.updateValue(isActive, forKey: item.uuid)
                                                areaCell.commentStateList = self.commentStateList
                                                areaCell.updateCommentStateListInSon()
                                                areaCell.changeLabel(isActive: isActive, item: data)
                })
            } else if let stackBarCell = cell as? StackBarChartCollectionViewCell, let data = item as? ItemDashboardDataStackBarChart {
                stackBarCell.checkAndChangeComment(sender: sender,
                                                   isActive: !commentStateList[item.uuid]!,
                                                   isHavingComment: data.data?.haveComment, completion:{ (isActive) in
                                                    self.commentStateList.updateValue(isActive, forKey: item.uuid)
                                                    stackBarCell.commentStateList = self.commentStateList
                                                    stackBarCell.updateCommentStateListInSon()
                                                    stackBarCell.changeLabel(isActive: isActive, item: data)
                                                    
                })
            } else if let combineCell = cell as? CombineChartCollectionViewCell, let data = item as? ItemDashboardDataCombineBarChart {
                combineCell.checkAndChangeComment(sender: sender,
                                                  isActive: !commentStateList[item.uuid]!,
                                                  isHavingComment: data.haveComment, completion:{ (isActive) in
                                                    self.commentStateList.updateValue(isActive, forKey: item.uuid)
                                                    combineCell.commentStateList = self.commentStateList
                                                    combineCell.updateCommentStateListInSon()
                                                    combineCell.changeLabel(isActive: isActive, item: data)
                })
            }
            DLog("comment clicked \(commentStateList[item.uuid]!)")

        }
    }

    func cellActionInfor(_ cell: UICollectionViewCell, sender: UIView) {
        if let indexPath = self.collectionView.indexPath(for: cell) {
            let item: ItemDashboardDataModel = viewModel.getItemAtIndexPath(indexPath)
            wireFrame.doShowTargetDefine(item, sender: sender)
        }
    }
}

extension BaseListChartCollectionView: BaseListSuggestionCollectionViewCellDelegate {
    func cell(cell: BaseListSuggestionCollectionViewCell, didSelectSuggestion filter: FilterTargetModel) {
        chooseSuggestionHandler?.baseListChartCollectionView(self, didSelectFilterSuggestion: filter)
    }
}

extension BaseListChartCollectionView: BaseListChartViewWireFrameMenuMoreDelegate {
    func didActionMenuMore(_ type: ViewMoreMenu,
                           _ indexPath: IndexPath) {
        if type == .unitConversion {
            if let cell = self.collectionView.cellForItem(at: indexPath) as? DashboardReportCollectionViewCell {
                cell.doUnitConversion()
            }
        }
    }
}

extension BaseListChartCollectionView: RankingCollectionViewCellDelegate {
    func didSelectRowOfTable(readSheet: GSPReadSheetView,
                             rowData: TableRowModel,
                             data: ItemDashboardDataRankingModel) {
        wireFrame.doSelectRowInTableRanking(data, rowData)
    }

    func didSelectHeaderRow(readSheet: GSPReadSheetView, headerRowData: HeaderRowModel, data: ItemDashboardDataRankingModel, headerView: UIView) {
        wireFrame.doSelectHeaderRowInTableRanking(data, headerRowData, headerView)
    }
}

extension BaseListChartCollectionView: AspectInfoCollectionViewCellDelegate {
    func didSelectAspestItem(_ data: ItemDashboardDataAspectInfo,
                             _ item: AspectInfoItemModel) {
        wireFrame.doSelectAspectItem(data, item)
    }
}

extension BaseListChartCollectionView: GridLayoutDelegate {

    func scaleForItem(inCollectionView collectionView: UICollectionView,
                      withLayout layout: UICollectionViewLayout,
                      atIndexPath indexPath: IndexPath) -> Scale {
        if viewModel.getData()[0].newDataDashBoard.count > 0 {
            let newItem: NewBlocklistDataDashboard = viewModel.getNewItemAtIndexPath(indexPath)
            
            if let size = newItem.size {
                return size.getScaleFromString()
            } else {
                return  Scale(1, 1)
            }
        
        } else {
          
        let item: ItemDashboardDataModel = viewModel.getItemAtIndexPath(indexPath)
        if let size = item.size {
            return size.getScaleFromString()
        } else {
            return  Scale(1, 1)
        }
        }
    }

    func itemFlexibleDimension(inCollectionView collectionView: UICollectionView,
                               withLayout layout: UICollectionViewLayout,
                               fixedDimension: CGFloat,
                               atIndexPath indexPath: IndexPath) -> CGFloat {

        let maxLine     = CGFloat(viewModel.getMaxLine())
        let maxHeight   = collectionView.frame.size.height + 100.0
        let height      = (maxHeight - (maxLine - 1)*10)/maxLine

        return height - 2
    }

    func headerFlexibleDimension(inCollectionView collectionView: UICollectionView,
                                 withLayout layout: UICollectionViewLayout,
                                 fixedDimension: CGFloat, section: Int) -> CGFloat {
        let data = viewModel.getData()
        let item = data[section]
        if item.type?.uppercased() == "NORMAL" {
            return 30
        } else {
            return 2
        }
    }
}

extension BaseListChartCollectionView: TreemapCollectionViewDeleage {
    
    func treemapCollectionViewCell(_ cell: TreemapCollectionViewCell,
                                   cellIndex: IndexPath,
                                   longpressedAtIndex index: Int,
                                   point: CGPoint,
                                   gesture: UILongPressGestureRecognizer) {
        
        if let model = viewModel.getItemAtIndexPath(cellIndex) as? ItemDashboardDataTreeMap {
            let treemap = model.data?.treemaps[index]
            guard let entry = model.data?.convertToEntryDataModel(index: index) else {
                return
            }
            guard let windown = UIApplication.shared.windows.first else {
                return
            }
            let location = gesture.location(in: cell)
            if let styleId = treemap?.styleId {
                let style = model.data?.getStyleWithId(styleId)
                let name = LegendModel(style?.color, (treemap?.title) ?? "", "")
                entry.data.insert(name, at: 0)
            }

            ChartLegendPopOverView.share.showInLocation(location: location,
                                                        fromView: cell, toView: windown,
                                                        chartTitle: model.data?.chartTitle,
                                                        chartDesc: nil,
                                                        listDataEntry: [entry])
        }
    }

    func treemapCollectionViewCell(_ cell: TreemapCollectionViewCell, movedAtIndex index: IndexPath, position: Int) {
        if position == 3 {
            if viewModel.getNumberItemOfSection(index.section) > 1 {
                if index.row < (viewModel.getNumberItemOfSection(index.section) - 1) {
                    DLog("index= \(index)")
                    collectionView.scrollToItem(at: IndexPath(row: index.row + 1, section: index.section), at: .bottom, animated: true)
                }
            }
        } else {
            if index.row == 0 {
                collectionView.scrollBackToTop(self)
            } else {
                collectionView.scrollToItem(at: IndexPath(row: index.row - 1, section: index.section), at: .bottom, animated: true)
            }
        }
    }

    func treemapCollectionViewCell(_ cell: TreemapCollectionViewCell, tappedAtIndex index: IndexPath) {

        if let model = viewModel.getItemAtIndexPath(index) as? ItemDashboardDataTreeMap {
            guard let filterMetadata = model.data?.filterMetadata else {
                return
            }

            if let treemap = model.data?.treemaps[index.row] {
                wireFrame.doSelectTreemap(treemap, filterMetadata: filterMetadata)
            }
        }
    }

    func treemapCollectionViewCell(_ cell: TreemapCollectionViewCell, endLongpressedAtIndex index: IndexPath) {
         ChartLegendPopOverView.share.hide()
    }
}
