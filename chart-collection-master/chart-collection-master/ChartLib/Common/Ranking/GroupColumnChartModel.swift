//
//  GroupColumnChartModel.swift
//  CBCT-Viettel
//
//  Created by Admin on 4/7/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

class GroupColumnChartModel: NSObject {
    var viewMore: Bool
    var chartName: String
    var unit: String
    var titleUnit: String
    var objectType: AppObjectType = .unknow
    var columnPieceStyles: [PieceStyleModel]
    var columns: [ColumnModel]
    
    init(_ dto: GroupColumnChartDTO) {
        viewMore = dto.viewMore
        chartName = dto.chartName
        unit = dto.unit
        titleUnit = dto.titleUnit
        objectType = AppObjectType.typeFromServer(dto.objectType)
        columnPieceStyles = []
        for subDTO in dto.columnPieceStyles {
            columnPieceStyles.append(PieceStyleModel(subDTO))
        }
        columns = []
        for subDTO in dto.columns {
            columns.append(ColumnModel(subDTO))
        }
    }

    func getMaxPercent() -> Double {
        var totals: [Double] = []
        for column in columns {
            let total = column.getTotalPercentOfColum()
            totals.append(total)
        }

        if let max = totals.max() {
            return max
        }
        return 0.0
    }

    func getMinPercent() -> Double {
        var totals: [Double] = []
        for column in columns {
            let total = column.getTotalPercentOfColum()
            totals.append(total)
        }

        if let min = totals.min() {
            return min
        }
        return 0.0

    }
}
