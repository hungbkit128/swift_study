//
//  ItemDashboardDataModel.swift
//  CBCT-Viettel
//
//  Created by Hoang on 4/24/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

class ItemDashboardDataModel: NSObject {

    var uuid: String = ""
    var type: DashboardDetailType = .unknown
    var searchItem: DashboardSearchCritieria?
    var size: String?
    var groupId: String = ""

    public override init() {

    }

    public init(_ dto: DashboardDataDetailDTO) {

        type = dto.type
        uuid = dto.groupId
        size = dto.size
        groupId = dto.groupId
        
        super.init()
        moreMenuAction.append(MoreDropMenuModel(type: .zoom, serviceID: ""))

        if dto.type == .report {
            let unitConversion =  MoreDropMenuModel.init(.unitConversion)
            moreMenuAction.append(unitConversion)
        }

        if let filterMetadata = self.getFilterMetaData() {
            searchItem = DashboardSearchCritieria.initWithFilterMetadataModel(filterMetadata)

            if searchItem?.isServiceDefine() == true {
                let defineService = MoreDropMenuModel.init(.defineService)
                moreMenuAction.append(defineService)
            }
            let groupTypeChart = [DashboardDetailType.combineLineChart,.lineChart,.combineLineChart30DAY,.stackBarChart,.combineChart, .treemap, .radarChart, .pieChart]
            let serviceType = filterMetadata.serviceType
            
            let numberGroupArea = filterMetadata.unit?.group?.arrayFromStringSeperatorCommas().count
            
            let isOneArea = numberGroupArea == 1
            
            if (serviceType == .all
                || serviceType == .ranking
                || filterMetadata.serviceType == .group) && type != .ranking && type != .tableTrends {
                if !(groupTypeChart.contains(type) && serviceType == .group && !isOneArea) {
                    let targets = MoreDropMenuModel.initWithFilter(filterMetadata: filterMetadata)
                    for item in targets {
                        moreMenuAction.append(item)
                    }
                }
            }
        }
        
        //Filtter MoreMenuAction
        var listAction: [MoreDropMenuModel] = []
        moreMenuAction.forEach { (action) -> () in
            if !listAction.contains(where: { (obj) -> Bool in
                return obj.serviceName == action.serviceName
            }){
                listAction.append(action)
            }
        }
        moreMenuAction = listAction
    }

    class func dataModelFromDTO(_ dto: DashboardDataDetailDTO) -> ItemDashboardDataModel? {
        switch dto.type {
        case .item:
            let model = ItemDashboardDataItem(dto)
            model.uuid = dto.blockId ?? ""
            if model.data == nil {
                return nil
            } else {
                return model
            }
        case .guageChart:
            let guageChartData = GuageChartDataDTO(dto)
            guageChartData.uuid = dto.blockId ?? ""
            return guageChartData.data != nil ? guageChartData : nil
        case .lineChart, .trendLineChart:
            let lineChartData = ItemDashboardDataLineChart(dto)
            lineChartData.uuid = dto.blockId ?? ""
            return lineChartData
        case .candleStickChart:
            let candleStickChartData = ItemDashboardDataCandleStickChart(dto)
            candleStickChartData.uuid = dto.blockId ?? ""
            return candleStickChartData
        case .combineLineChart:
            let lineChartData = ItemDashboardDataLineChart(combineLineDTO: dto)
            lineChartData.uuid = dto.blockId ?? ""
            return lineChartData
        case .pieChart:
            let pieChart = ItemDashboardDataPieChart(dto)
                pieChart.uuid = dto.blockId ?? ""
            return pieChart
        case .groupBarChart:
            let data = ItemDashboardDataGroupBarChart(dto)
            data.uuid = dto.blockId ?? ""
            return data
        case .areaChart:
            let data = ItemDashboardDataAreaChart(dto)
            data.uuid = dto.blockId ?? ""
            return data
        case .stackBarChart:
            let item = ItemDashboardDataStackBarChart(dto)
            item.uuid = dto.blockId ?? ""
            return item
        case .combineChart, .combineLineChart30DAY,
             .combineChartLine100, .combineChartTrends,
             .combineStackChart:
            let item = ItemDashboardDataCombineBarChart(dto)
            if dto.type == .combineChartLine100 {
                item.typeOfChart = ObjectComment.COMBINE_CHART_LINE100
            } else {
              item.typeOfChart = nil
            }
            item.uuid = dto.blockId ?? ""
            if let number = item.columnChartData?.entryLabel.count {
                if number == 0 {
                    let lineChartData = ItemDashboardDataLineChart(combineChartData: item)
                    return lineChartData
                }
            }
            return item
        case .horizontalStackBarChart:
            let item = ItemDashboardDataHorizontalStackBarChart(dto)
            item.uuid = dto.blockId ?? ""
            return item
        case .report:
            let model = ItemDashBoardReportModel(dto)
            model.uuid = dto.blockId ?? ""
            if model.data == nil {
                return nil
            } else {
                return model
            }
        case .ranking,
             .tableTrends,
             .tableViewMuliDays:
            let item = ItemDashboardDataRankingModel(dto)
            item.uuid = dto.blockId ?? ""
            if dto.type == .tableTrends {
                if let listRow = item.rankingData?.listRow {
                    if listRow.count < 3 {
                        item.size = "CARD3_1"
                    } else if listRow.count > 10 {
                        item.size = "CARD3_3"
                    } else {
                        item.size = "CARD3_2"
                    }
                } else {
                    item.size = "CARD3_3"
                }
            }
            return item
        case .classReport:
            let model = ItemClassReportModel(dto)
            model.uuid = dto.blockId ?? ""
            if model.data == nil {
                return nil
            } else {
                return model
            }
        case .radarChart:
            let model = ItemDashboardDataRadarChart(dto)
            model.uuid = dto.blockId ?? ""
            return model
        case .rankingInfo:
            let model = ItemDashboardDataRankingInfo(dto)
            model.uuid = dto.blockId ?? ""
            return model
        case .aspectInfo:
            let model = ItemDashboardDataAspectInfo(dto)
            model.uuid = dto.blockId ?? ""
            return model
        case .treemap:
            return ItemDashboardDataTreeMap(dto)
        default:
            break
        }
        return ItemDashboardDataModel(dto)
    }

    func getFilterMetaData() -> FilterMetadataModel? {
        var filterMetaData: FilterMetadataModel?
            switch type {
            case .areaChart:
                let d = self as? ItemDashboardDataAreaChart
                filterMetaData = d?.getfilterMetaData()
            case .combineChart, .combineLineChart30DAY,
                 .combineChartLine100, .combineChartTrends,
                 .combineStackChart:
                let d = self as? ItemDashboardDataCombineBarChart
                filterMetaData = d?.getfilterMetaData()
            case .groupBarChart:
                let d = self as? ItemDashboardDataGroupBarChart
                filterMetaData = d?.getfilterMetaData()
            case .horizontalStackBarChart:
                let d = self as? ItemDashboardDataHorizontalStackBarChart
                filterMetaData = d?.getfilterMetaData()
            case .lineChart, .combineLineChart, .trendLineChart:
                let d = self as? ItemDashboardDataLineChart
                filterMetaData = d?.getfilterMetaData()
            case .pieChart:
                let d = self as? ItemDashboardDataPieChart
                filterMetaData = d?.getfilterMetaData()
            case .report:
                let d = self as? ItemDashBoardReportModel
                filterMetaData = d?.getfilterMetaData()
            case .stackBarChart:
                let d = self as? ItemDashboardDataStackBarChart
                filterMetaData = d?.getfilterMetaData()
            case .ranking, .tableTrends, .tableViewMuliDays:
                let d = self as? ItemDashboardDataRankingModel
                filterMetaData = d?.filterMetadata
            case .radarChart:
                let d = self as? ItemDashboardDataRadarChart
                filterMetaData = d?.getfilterMetaData()
            case .rankingInfo:
                let d = self as? ItemDashboardDataRankingInfo
                filterMetaData = d?.getfilterMetaData()
            case .aspectInfo:
                let d = self as? ItemDashboardDataAspectInfo
                filterMetaData = d?.getFilterMetaData()
            default:
                break
            }
        return filterMetaData
    }

    func getBlockChartTitle() -> String? {
        var title: String?
        switch type {
        case .areaChart:
            let d = self as? ItemDashboardDataAreaChart
            title = d?.data?.title
        case .combineChart,
             .combineChartLine100,
             .combineChartTrends,
             .combineStackChart:
            let d = self as? ItemDashboardDataCombineBarChart
            title = d?.chartName
        case .groupBarChart:
            let d = self as? ItemDashboardDataGroupBarChart
            title = d?.data?.title
        case .horizontalStackBarChart:
            let d = self as? ItemDashboardDataHorizontalStackBarChart
            title = d?.data?.title
        case .lineChart,
             .combineLineChart:
            let d = self as? ItemDashboardDataLineChart
            title = d?.data?.chartTitle
        case .pieChart:
            let d = self as? ItemDashboardDataPieChart
            title = d?.data?.chartName
        case .report:
            let d = self as? ItemDashBoardReportModel
            title = d?.data?.reportName
        case .stackBarChart:
            let d = self as? ItemDashboardDataStackBarChart
            title = d?.data?.title
        case .ranking,
             .tableTrends:
            let d = self as? ItemDashboardDataRankingModel
            title = d?.rankingData?.chartName
        case .radarChart:
            let d = self as? ItemDashboardDataRadarChart
            title = d?.data?.chartData.chartName
        case .rankingInfo:
            let d = self as? ItemDashboardDataRankingInfo
            title = d?.data?.reportName
        case .aspectInfo:
            let d = self as? ItemDashboardDataAspectInfo
            title = d?.data?.chartTitle
        default:
            break
        }
        return title
    }

    func addActionMenu(_ canEdit: Bool, _ canDelete: Bool, canResize: Bool) {
        var listMenuAction: [MoreDropMenuModel] = []
        if canEdit && moreMenuAction.index(where: {$0.type == .edit}) == nil {
            listMenuAction.append(MoreDropMenuModel(type: .edit, serviceID: ""))
        }
        if canDelete && moreMenuAction.index(where: {$0.type == .delete}) == nil {
            listMenuAction.append(MoreDropMenuModel(type: .delete, serviceID: ""))
        }
        if let index = moreMenuAction.index(where: {$0.type == .defineService}) {
            moreMenuAction.insert(contentsOf: listMenuAction, at: index + 1)
        } else if let index = moreMenuAction.index(where: {$0.type == .unitConversion}) {
            moreMenuAction.insert(contentsOf: listMenuAction, at: index + 1)
        } else if let index = moreMenuAction.index(where: {$0.type == .zoom}) {
            moreMenuAction.insert(contentsOf: listMenuAction, at: index + 1)
        }
        moreMenuAction.enumerated().forEach { (idx, item) in
            if item.type == .resize {
                moreMenuAction.remove(at: idx)
            }
        }
        if canResize == true && canEdit {
            let menuItem = MoreDropMenuModel(type: .resize, serviceID: "")
            let resizeCards = DataManager.shareInstance.resizeCards
            resizeCards.enumerated().forEach({ (_, item) in
                menuItem.child.append(item)
            })
            moreMenuAction.append(menuItem)
        }
    }
}
