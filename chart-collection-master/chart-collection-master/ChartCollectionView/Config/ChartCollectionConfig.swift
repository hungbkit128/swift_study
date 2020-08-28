//
//  ChartCollectionConfig.swift
//  chart-collection-master
//
//  Created by Tran Van Hung on 8/26/20.
//  Copyright © 2020 hba. All rights reserved.
//

import UIKit

class ChartCollectionConfig: NSObject {

    class func viewControllerIPhone() -> DashboardListViewController {
        let storyboardName = "DashboardListViewController"
        let storyboardId = "DashboardListViewController_iPhone"
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: storyboardId) as? DashboardListViewController

        let presenter = DashboardListPresenter()
        let viewModel = DashboardListViewModel()
        let interactor = DashboardListInteractor()

        presenter.viewModel = viewModel
        presenter.interactor = interactor
        presenter.view = view

        view?.presenter = presenter
        view?.viewModel = viewModel
        interactor.presenter = presenter

        let wireFrame = DashboardListWireFrame()
        wireFrame.viewController = view
        wireFrame.presenter = presenter
        presenter.wireFrame = wireFrame
        return view!
    }

    class func viewControllerIPad(bridgeOutput: DashboardListWireFrameBrigeOutput?) -> (view: DashboardListViewController, bridgeInput: DashboardListWireFrameBrigeInput) {
        let view = DashboardListViewController.initWithDefautlStoryboard()
        let presenter = DashboardListPresenter()
        let viewModel = DashboardListViewModel()
        let interactor = DashboardListInteractor()

        presenter.viewModel = viewModel
        presenter.interactor = interactor
        presenter.view = view

        view.presenter = presenter
        view.viewModel = viewModel
        interactor.presenter = presenter

        let wireFrame = DashboardListWireFrameIPad()
        wireFrame.viewController = view
        wireFrame.presenter = presenter
        presenter.wireFrame = wireFrame
        wireFrame.bridgeOutput = bridgeOutput
        return (view, wireFrame)
    }
}

//===================== VIEW ============================
//=======================================================
// MARK:
// MARK: VIEW
protocol DashboardListViewControllerInput: class {
    func doShowNoDataView(message: String)
    func doShowNoNetWork()
    func doRefreshView()
    func doShowSuggestion(_ suggestions: [SuggestionItemModel], _ message: String?)
    func doRefreshCollectionView()
    func getIsCanEdit() -> Bool
    func doUpdateCycleAndTimeDefaut()
}

protocol DashboardListViewControllerOutput: class {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func doShowSelectDashboarGroup()
    func doPullToRefresh()
    func doShowFilter(_ viewController: BaseViewController?, _ sender: UIView?)
    func doCallRequestGetGroup()
    func doSearchConfigPressed()
    func doSearchConfigPressedWithFilter()
    func doShowAlertConfirmDelete(_ data: ItemDashboardDataModel)
    func doSortData(_ data: [ItemDashboardDataModel])
    func doEditBlock(_ data: ItemDashboardDataModel)
    func doShowGroupDashboardToSharedFromNotify()
    func doSelectSuggestion(_ filter: DashboardFilterModel, _ groupId: String)
    func doGetTableTrend(_ group: GroupDashboardType)
    func doShowTrendDetail(_ data: ItemDashboardDataRankingModel, _ rowData: TableRowModel)
    func doClearData()
    func doGetDataForRanking()
    func doUpdateItem(_ item: ItemDashboardDataModel)
    func doFilterWidthCycle(_ cycle: FinancialCycle)
    func doFilterWithGroupId(_ searchModel: DashboardSearchCritieria, _ groupId: String?, _ title: String?, _ headerView: UIView)
    func doShowGuidelineView()
}

//========================= VIEW MODEL =================
//=======================================================
// MARK:
// MARK: VIEW MODEL
protocol DashboardListViewModelInput: class {
    func doUpdateTitle(_ title: String)
    func doUpdateFilterCacheSearch(_ filter: FilterTargetModel?)
    func doChangeShowSearchStatus()
    func doUpdateData(data: GetListReportDashboardResponse?)
    func doUpdateIsFilter(_ filter: Bool)
    func doUpdateFilter(_ filter: DashboardFilterModel?)
    func doUpdateGroup(_ group: GroupReportModel)
    func doDeleteBlock(_ blockId: String)
    func doUpdateDataSorted(_ data: [ItemDashboardDataModel])
    func doUpdateFilterMetaData(_ filter: FilterMetadataModel)
    func doChangeShowNotify()
    func doUpdateRankingFilter(_ filter: RankingFilterModel?)
    func doUpdateGroupOfSuggest(_ group: GroupReportModel)
    func doUpdateGroupTrendType(_ type: String)
    func doUpdateFilterTarget(_ filter: FilterTargetModel?)
    func doUpdateCurrentCycleTrend(_ cycle: FinancialCycle?)
    func setCycle(_ cycle: [FinancialCycle]?)
    func doUpdateCycleAndTimeDefaut()
}

protocol DashboardListViewModelOutput: class {
    func getTitle() -> String?
    func getResultResponse() -> GetListReportDashboardResponse?
    func getIsShowSearch() -> Bool
    func getSearchTitle() -> String?
    func getListItem() -> [ItemDashboardDataModel]
    func getSearchItem() -> GroupReportModel?
    func getCurrentGroupReport() -> GroupReportModel?
    func getListGroupReport() -> [GroupReportModel]
    func getIsFilter() -> Bool
    func getFilter() -> DashboardFilterModel?
    func getAdvanceSearchFitler() -> FilterTargetModel?
    func getIsShowNotify() -> Bool
    func getNotifyMessage() -> String
    func getRankingFilter() -> RankingFilterModel?
    func getGroupOfSuggest() -> GroupReportModel?
    func getShowButtonSwitchTableTrend() -> Bool
    func getGroupTrendType() -> String?
    func getFilterTarget() -> FilterTargetModel?
    func getIsGroupTypeTableTrend() -> Bool
    func getIsChangeCurrentGroup(_ groupNew: GroupReportModel) -> Bool
    func getCycleAvailableList() -> [FinancialCycle]
    func getCycleAvailableListFilter() -> [FinancialCycle]
    func getCycleCurrent() -> FinancialCycle
    func isExistInListGroupDashboard(_ groupId: String?) -> Bool
    func getFilterCacheSearch() -> FilterTargetModel?
}

//==================== INTERACTOR =======================
//=======================================================
// MARK:
// MARK: INTERACTOR
protocol DashboardListInteractorInput: class {
    func doFilter(_ item: GroupReportModel?, _ filter: DashboardFilterModel?, _ isSearch: Bool)
    func doSearchDefault(_ item: GroupReportModel?,
                         _ filter: DashboardFilterModel?,
                         _ filterRanking: RankingFilterModel?,
                         _ filterTarget: FilterTargetModel?,
                         _ action: ViewMoreMenu,
                         groupTypeTrend: String?,
                         groupId: String?)
    func doSaveFilterDashboard(_ group: GroupReportModel, _ filter: DashboardFilterModel)
    func doDeleleBlock(_ itemDashboard: ItemDashboardDataModel, _ group: GroupReportModel)
    func doSortItemDashboard(_ listBlock: [ItemDashboardDataModel])
    func doUpdateCardSize(item: ItemDashboardDataModel)
}

protocol DashboardListInteractorOutput: class {
    func didSearch(response: GetListReportDashboardResponse?, action: ViewMoreMenu)
    func didFilter(response: GetListReportDashboardResponse?, filter: DashboardFilterModel?, isFilter: Bool)
    func didFailse(error: NSError?)
    func didDeleteBlock(_ blockId: String)
    func didSortBlock(_ listBlock: [ItemDashboardDataModel])
    func didDeleteItemDashboard(_ filter: FilterMetadataModel)
    func didFilterSuggestResponse(_ suggest: DashboardSuggestionModel, _ groupCurrent: GroupReportModel?)
}

//==================== WIRE FRAME =======================
//=======================================================
// MARK:
// MARK: WIRE FRAME
protocol DashboardListWireFrameInput: class {
    func doShowSelectDashboardGroup(current: GroupReportModel?, list: [GroupReportModel])
    func doUpdateListGroupReport(current: GroupReportModel?)
    func doShowProgress()
    func doHideProgress()
    func doShowToast(message: String)
    func doShowMessageSuccess(action: ViewMoreMenu)
    func doShowFilter(_ viewController: BaseViewController?, _ sender: UIView?, _ filter: DashboardFilterModel?)
    func doCallRequestGetGroup()
    func doShowFilterScreen(_ group: GroupReportModel?, _ filterRanking: RankingFilterModel?, _ filterTarget: FilterTargetModel?)
    func doShowFilterScreen(_ group: GroupReportModel?, _ filter: FilterTargetModel, _ filterRanking: RankingFilterModel?, _ filterTarget: FilterTargetModel?)
    func doShowAlertDeleteBlock(_ data: ItemDashboardDataModel, _ group: GroupReportModel)
    func doShowMessageDeleteBlockSuccess()
    func doEditBlock(_ data: ItemDashboardDataModel, _ group: GroupReportModel)
    func doShowSuggestion(_ suggest: DashboardSuggestionModel)
    func doShowSelectDashboardGroupFromNotify(current: GroupReportModel?, list: [GroupReportModel])
    func doShowTrendDetail(_ data: ItemDashboardDataRankingModel, _ rowData: TableRowModel, _ group: GroupReportModel?)
    func doShowSectorDetailTrend(_ searchModel: DashboardSearchCritieria, _ groupId: String?, _ title: String?)
    func doShowGuidelineView()
}

protocol DashboardListWireFrameOutput: class {
    func doUpdateViewModelCacheFilter(_ filter: FilterTargetModel?)
    func didSelectItem(_ selecteItem: GroupReportModel, _ action: ViewMoreMenu)
    func didSetFilter(_ filter: DashboardFilterModel?, _ isSearch: Bool)
    func didSetGroup(_ group: GroupReportModel)
    func didConfirmDeleteBlock(_ data: ItemDashboardDataModel, _ group: GroupReportModel)
    func didSelectSuggestion(_ filter: DashboardFilterModel, _ groupId: String)
    func didFiterRanking(_ filter: RankingFilterModel)
    func doShowFilterFrom()
    func didFiterTargetModel(_ filter: FilterTargetModel)
}

//==================== WIRE FRAME BRIDGE =======================
//=======================================================
// MARK:
// MARK: WIRE FRAME BRIDGE
protocol DashboardListWireFrameBrigeInput: class {
    func doUpdateSearchItem(_ item: GroupReportModel, _ action: ViewMoreMenu)
    func doAddDashboard()
    func doShowFilterFrom(_ sender: UIView)
    func doShowGuideline(_ sender: UIView)
}

protocol DashboardListWireFrameBrigeOutput: class {
    func doShowSearch(_ viewController: UIViewController?)
    func doUpdateListGroupReport(current: GroupReportModel?)
    func doCallRequestGetGroup()
    func doShowGroupFromNotify(_ viewController: UIViewController?)
}
