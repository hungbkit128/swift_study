//
//  AppEnum.swift
//  chart-collection-master
//
//  Created by Tran Van Hung on 8/26/20.
//  Copyright © 2020 hba. All rights reserved.
//

import UIKit

enum CompletedType {
    case contrary
    case unknown

    static func typeFromServer(_ stringValue: String) -> CompletedType {
        if stringValue == "CONTRARY" {
            return .contrary
        }
        return .unknown
    }
}

enum TypeCompressNumber {
    case compress
    case normal

    func saveString() -> String {
        switch self {
        case .compress:
            return "COMPRESS"
        case .normal:
            return "NORMAL"
        }
    }

    func imageDisplay() -> UIImage? {
        switch self {
        case .compress:
            return #imageLiteral(resourceName: "ic-switch-value").imageWithColor(color: AppColor.coolBlue())
        case .normal:
            return #imageLiteral(resourceName: "ic-switch-value")
        }
    }
    static func enumFromKey(_ strKey: String) -> TypeCompressNumber {
        if strKey == "COMPRESS" {
            return .compress
        } else if strKey == "NORMAL" {
            return .normal
        }
        return .normal
    }
}

enum GroupDashboardType {
    case ranking
    case tableAspect
    case aspectInfo
    case userAnalystic
    case userAnalysticTD
    case unknown

    static func typeFromServer(_ strValue: String) -> GroupDashboardType {
        if strValue == "RANKING" {
            return .ranking
        }
        if strValue == "TABLE_ASPECT_INFO" {
            return .tableAspect
        }
        if strValue == "ASPECT_INFO" {
            return .aspectInfo
        }
        if strValue == "USER_ANALYSTIC" {
            return .userAnalystic
        }
        if strValue == "USER_ANALYSTIC_TD" {
            return .userAnalysticTD
        }
        return .unknown
    }

    func toValue() -> String {
        switch self {
        case .ranking:
            return "RANKING"
        case .tableAspect:
            return "TABLE_ASPECT_INFO"
        case .aspectInfo:
            return "ASPECT_INFO"
        case .userAnalystic:
            return "USER_ANALYSTIC"
        case .userAnalysticTD:
            return "USER_ANALYSTIC_TD"
        default:
            return ""
        }
    }
}

enum AnalysisSegmentType: Int {
    case target = 0
    case ranking
    case map
}

enum ReportInfo {
    case perform
    case delta
    case unknow

    func stringValue() -> String {
        switch self {
        case .perform:
            return "PERFORM_INFO"
        case .delta:
            return "DELTA_INFO"
        default:
            return "unknow"
        }
    }

    static func fromString(_ str: String) -> ReportInfo {
        if str == "PERFORM_INFO" {
            return ReportInfo.perform
        }

        if str == "DELTA_INFO" {
            return ReportInfo.delta
        }

        return ReportInfo.unknow
    }
}


enum ChartTimeType {
    case singleDay
    case multiDay
    case unknown

    static func typeFromServer(_ strValue: String) -> ChartTimeType {
        if strValue == "SINGLE_DAY_CHART" {
            return .singleDay
        }
        if strValue == "MULTI_DAY_CHART" {
            return .multiDay
        }
        return .unknown
    }

    func displayString() -> String {
        switch self {
        case .singleDay:
            return "Theo gia tri"
        case .multiDay:
            return "Theo thoi gian"
        default:
            return ""
        }
    }

    func toValue() -> String {
        switch self {
        case .singleDay:
            return "SINGLE_DAY_CHART"
        case .multiDay:
            return "MULTI_DAY_CHART"
        default:
            return ""
        }
    }
}

enum DashboardDetailType {
    case item
    case lineChart
    case pieChart
    case groupBarChart
    case areaChart
    case stackBarChart
    case combineChart
    case horizontalStackBarChart
    case report
    case ranking
    case combineLineChart
    case classReport
    case combineLineChart30DAY
    case combineChartLine100
    case combineChartTrends
    case radarChart
    case rankingInfo
    case tableTrends
    case trendLineChart
    case aspectInfo
    case tableViewMuliDays
    case combineStackChart
    case treemap
    case candleStickChart
    case guageChart
    case NUM_OF_USE
    case NUM_OF_ACTIVE_USER
    case TOP_NUM_OF_USE_EMPLOYEE
    case TOP_NUM_OF_USE_AREA
    case unknown

    func stringValue() -> String {
        switch self {
        case .item:
            return "ITEM_DASHBOARD"
        case .lineChart:
            return "LINE_CHART"
        case .combineLineChart:
            return "COMBINE_LINE_CHART"
        case .pieChart:
            return "CIRCLE_CHART"
        case .groupBarChart:
            return "COLUMN_CHART"
        case .areaChart:
            return "AREA_CHART"
        case .stackBarChart:
            return "VERTICAL_STACK_COLUMN_CHART"
        case .combineChart:
            return "COMBINE_CHART"
        case .horizontalStackBarChart:
            return "HORIZONTAL_STACK_RANKING_UNIT"
        case .report:
            return "SERVICE_REPORT"
        case .ranking:
            return "TABLE_VIEW"
        case .classReport:
            return "CLASS_REPORT"
        case .combineLineChart30DAY:
            return "COMBINE_30_DAYS"
        case .combineChartLine100:
            return "COMBINE_CHART_LINE100"
        case .combineChartTrends:
            return "COMBINE_CHART_TRENDS"
        case .radarChart:
            return "RADAR_CHART"
        case .rankingInfo:
            return "RANKING_INFO"
        case .tableTrends:
            return "TABLE_TRENDS"
        case .trendLineChart:
            return "TRENDS_LINE"
        case .aspectInfo:
            return "ASPECT_INFO"
        case .tableViewMuliDays:
            return "TABLE_VIEW_MULTI_DAYS"
        case .combineStackChart:
            return "COMBINE_VERTICAL_STACK_CHART"
        case .treemap:
            return "TREE_MAP"
        case .candleStickChart:
            return "CANDLE_CHART"
        case .guageChart:
            return "GAUGE_CHART"
        case .NUM_OF_USE:
            return "NUM_OF_USE"
        case .NUM_OF_ACTIVE_USER:
            return "NUM_OF_ACTIVE_USER"
        case .TOP_NUM_OF_USE_EMPLOYEE:
            return "TOP_NUM_OF_USE_EMPLOYEE"
        case .TOP_NUM_OF_USE_AREA:
            return "TOP_NUM_OF_USE_AREA"
        default:
            return "unknown"
        }
    }

    static func fromString(_ str: String) -> DashboardDetailType {
        if str == "ITEM_DASHBOARD" {
            return DashboardDetailType.item
        }
        if str == "LINE_CHART" {
            return DashboardDetailType.lineChart
        }
        if str == "COMBINE_LINE_CHART" {
            return DashboardDetailType.combineLineChart
        }
        if str == "CIRCLE_CHART" {
            return DashboardDetailType.pieChart
        }
        if str == "COLUMN_CHART" {
            return DashboardDetailType.groupBarChart
        }
        if str == "AREA_CHART" {
            return DashboardDetailType.areaChart
        }
        if str == "VERTICAL_STACK_COLUMN_CHART" {
            return DashboardDetailType.stackBarChart
        }
        if str == "COMBINE_CHART" {
            return DashboardDetailType.combineChart
        }
        if str == "HORIZONTAL_STACK_RANKING_UNIT" {
            return DashboardDetailType.horizontalStackBarChart
        }
        if str == "SERVICE_REPORT" {
            return DashboardDetailType.report
        }
        if str == "TABLE_VIEW" {
            return DashboardDetailType.ranking
        }
        if str == "CLASS_REPORT" {
            return DashboardDetailType.classReport
        }
        if str == "COMBINE_30_DAYS" {
            return DashboardDetailType.combineLineChart30DAY
        }
        if str == "COMBINE_CHART_LINE100" {
            return DashboardDetailType.combineChartLine100
        }
        if str == "COMBINE_CHART_TRENDS" {
            return DashboardDetailType.combineChartTrends
        }
        if str == "RADAR_CHART" {
            return DashboardDetailType.radarChart
        }
        if str == "RANKING_INFO" {
            return DashboardDetailType.rankingInfo
        }
        if str == "TABLE_TRENDS" {
            return DashboardDetailType.tableTrends
        }
        if str == "TRENDS_LINE" {
            return DashboardDetailType.trendLineChart
        }
        if str == "ASPECT_INFO" {
            return DashboardDetailType.aspectInfo
        }
        if str == "TABLE_VIEW_MULTI_DAYS" {
            return DashboardDetailType.tableViewMuliDays
        }
        if str == "COMBINE_VERTICAL_STACK_CHART" {
            return DashboardDetailType.combineStackChart
        }
        if str == "TREE_MAP" {
            return DashboardDetailType.treemap
        }
        if str == "CANDLE_CHART" {
            return DashboardDetailType.candleStickChart
        }
        if str == "GAUGE_CHART" {
            return DashboardDetailType.guageChart
        }
        if str == "NUM_OF_USE" {
            return DashboardDetailType.NUM_OF_USE
        }
        if str == "NUM_OF_ACTIVE_USER" {
            return DashboardDetailType.NUM_OF_ACTIVE_USER
        }
        if str == "TOP_NUM_OF_USE_EMPLOYEE" {
            return DashboardDetailType.TOP_NUM_OF_USE_EMPLOYEE
        }
        if str == "TOP_NUM_OF_USE_AREA" {
            return DashboardDetailType.TOP_NUM_OF_USE_AREA
        }
        return DashboardDetailType.unknown
    }

    func icon(color: UIColor = .white) -> UIImage {
        var image: UIImage
        switch self {
        case .item:
            image = UIImage()
        case .lineChart:
            image = icLineChart
        case .combineLineChart:
            image = icCombineLineChart
        case .pieChart:
            image = donutChart
        case .groupBarChart:
            image = UIImage()
        case .areaChart:
            image = UIImage()
        case .stackBarChart:
            image = icStackVerticalChart
        case .combineChart:
            image = icCombineChart
        case .combineLineChart30DAY:
            image = icCombineChart30Day
        case .horizontalStackBarChart:
            image = UIImage()
        case .report:
            image = infoBlock
        case .ranking,
             .tableViewMuliDays:
            image = table
        case .tableTrends:
            image = tableTrend
        case .radarChart:
            image = icRadarChart
        case .treemap:
            image = icTreeMap
        case .candleStickChart:
            image = icStackVerticalChart
        case .guageChart:
            image = donutChart
        default:
            image = UIImage()
        }

        if image.imageAsset != nil {
            image = image.withRenderingMode(.alwaysTemplate)
            if let imageSelected = image.imageWithColor(color: color) {
                image = imageSelected
            }
        }
        return image
    }
}

