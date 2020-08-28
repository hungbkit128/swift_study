//
//  ItemDashboardDataCombineBarChart.swift
//  CBCT-Viettel
//
//  Created by Admin on 5/17/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class ItemDashboardDataCombineBarChart: ItemDashboardDataModel {
    
    var typeOfChart: String?
    var lineChartDTO: LineChartDTO?
    var lineChartData: LineChartModel?
    
    var columnChartData: GGroupBarChartViewData?
    var stackChartData: GVerticalStackBarChartData?
    
    var chartName: String?
    var legends: [LegendModel] = []
    var unitDescription: String?
    var separatorIndex: [Int] = []
    var showLabel: Bool
    var compareValue: Double?
    var sizeSingleColums: Int?
    var showLeftAxis: Bool?
    var showRightAxis: Bool?

    public override init(_ dto: DashboardDataDetailDTO) {
       
        chartName = dto.data["chartName"].string
        showLabel = dto.data["showLabel"].boolValue

        var style: [PieceStyleModel] = []
        for subJson in dto.data["columnPieceStyles"].arrayValue {
            let dto = PieceStyleDTO(subJson)
            let model = PieceStyleModel(dto)
            style.append(model)
        }

        // hungtv64 them phan hien thi cot hiden
        var hiddenColumnStyles: [HiddenColumnStyleModel] = []
        for subJson in dto.data["hiddenColumnStyles"].arrayValue {
            let dto = HiddenColumnStyleDTO(subJson)
            let model = HiddenColumnStyleModel(dto)
            hiddenColumnStyles.append(model)
        }

        compareValue = dto.data["compareValue"].double
        let groupChartDTO = GroupBarChartDTO(dto.data["columnChartData"])
        let stackChartDTO = GroupColumnChartDTO(dto.data["stackBarChartData"])

        if dto.data["columnChartData"].isNull == false {
            
            if groupChartDTO.columns.count > 0 {
                sizeSingleColums = groupChartDTO.columns[0].singleColumn.count
                keyCommentListSingleColumn = groupChartDTO.columns[0].keyCommentList
                dateListSingleColumn = groupChartDTO.columns[0].dateList
            }
        } else if dto.data["stackBarChartData"].isNull == false {
            sizeSingleColums = stackChartDTO.columns.count
            for item in stackChartDTO.columns {
                keyCommentListSingleColumn.append(item.keyComment)
                dateListSingleColumn.append(item.label)
            }
        }

        if dto.type == .combineChartLine100 || dto.type == .combineChartTrends {
            columnChartData = GCombineChartMapping.mappingDataFromDTOLine100(groupChartDTO, style, hiddenColumnStyles, 0)
        } else if dto.type == .combineStackChart {
            stackChartData = GVerticalStackBarChartViewMapping.mappingDataFromDTO(stackChartDTO,
                                                                                  nil, nil, nil,
                                                                                  combineStack: true)
            stackChartData?.commentData = self.commentData
            stackChartData?.haveComment = self.haveComment
        } else {
            columnChartData = GCombineChartMapping.mappingDataFromDTO(groupChartDTO)
        }

        let lineDTO = LineChartDTO(dto.data["lineChartData"])
        lineChartDTO = lineDTO

        lineChartData = GCombineChartMapping.mappingFromLineChartDTO(lineDTO,
                                                                     barChartData: columnChartData,
                                                                     type: dto.type)

        if dto.type == .combineChartLine100 {
            if let value = self.compareValue {
                columnChartData = GCombineChartMapping.mappingDataFromDTOLine100(groupChartDTO, style, hiddenColumnStyles, value)
            } else if let value = lineChartData?.data?.getYMax() {
                columnChartData = GCombineChartMapping.mappingDataFromDTOLine100(groupChartDTO, style, hiddenColumnStyles, value)
            }
        }

        if let data = columnChartData?.legend {
            legends.append(contentsOf: data)
        }

        if let data = stackChartData?.legend {
            legends.append(contentsOf: data)
        }

        if dto.type != .combineChartLine100 {
            if let data = lineChartData?.legends {
                legends.append(contentsOf: data)
            }
        }

        separatorIndex = GLineChartViewMapping.getSeparatorIndex(lineDTO.lines)
        if separatorIndex.count == 0 {
            separatorIndex = GCombineChartMapping.getSeparatorIndex(groupChartDTO)
        }

        if let filter = filterMetaData {
            unitDescription = filter.getUnitDescription()
        }

        //Sprint-8
        showLeftAxis = dto.data["showLeftAxis"].boolValue
        showRightAxis = dto.data["showRightAxis"].boolValue

        super.init(dto)
        self.type = dto.type
    }

    func getEntryDataDefault() -> [EntryDataModel] {
        var isTrend: Bool = false
        //var result: [EntryDataModel] = []

        if type == .combineChartTrends || type == .combineChartLine100 {
            isTrend = true
        }
        if let lineEntry = lineChartData?.getEntryDataDefault(),
            let groupEntry = columnChartData?.getDataAtEntryDefault(isTrend:isTrend) {
            if self.type == .combineChartLine100 {
                return [groupEntry]
            } else if type == .combineChartTrends {
                return [lineEntry, groupEntry]
            }
           return [lineEntry, groupEntry]
        }
        if let groupEntry = columnChartData?.getDataAtEntryDefault(isTrend:isTrend) {
            return [groupEntry]
        }
        if let stackEntry = stackChartData?.getDefaultEntryLegendData(),
            let lineEntry = lineChartData?.getEntryDataDefault() {
            return [stackEntry, lineEntry]
        }
        if let stackEntry = stackChartData?.getDefaultEntryLegendData() {
            return [stackEntry]
        }
        if self.type != .combineChartLine100 {
            if let lineEntry = lineChartData?.getEntryDataDefault(isTrend:isTrend) {
                return [lineEntry]
            }
        }
        return []
    }
    
    func getPoinDTO(index: Int) -> PointDTO? {
        if let lines = lineChartDTO?.lines {
            for line in lines {
                return line.points[index]
            }
        }
        return nil
    }
}
