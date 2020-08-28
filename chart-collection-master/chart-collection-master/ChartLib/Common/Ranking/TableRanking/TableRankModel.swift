//
//  TableRankModel.swift
//  CBCT-Viettel
//
//  Created by Admin on 4/7/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit

class TableRankModel: NSObject {

    var chartName: String
    var unit: String
    var searchId: Int?
    var visibleColumnsId: [Int]
    var header: [HeaderModel]
    var tableRows: [TableRowModel]
    var searchHint: String
    var objectType: String
    var headerRows: [HeaderRowModel] = []

    init(_ dto: TableRankDTO) {
        chartName = dto.chartName
        unit = dto.unit
        searchId = dto.searchId
        searchHint = dto.searchHint
        objectType = dto.objectType

        visibleColumnsId = []
        for item in dto.visibleColumnsId {
            visibleColumnsId.append(item)
        }

        header = []
        for item in dto.header {

            let colum = HeaderModel(item)

            if visibleColumnsId.count > 0 {
                colum.isVisible = visibleColumnsId.contains(colum.columnId)
            }
            header.append(colum)
        }

        tableRows = []
        for item in dto.tableRows {
            let row = TableRowModel(item)
            row.objectType = objectType
            tableRows.append(row)
        }

        headerRows = []
        for item in dto.headerRows {
            let header = HeaderRowModel(item)
            headerRows.append(header)
        }
    }
}
