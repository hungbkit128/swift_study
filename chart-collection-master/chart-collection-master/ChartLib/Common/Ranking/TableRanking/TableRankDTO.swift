//
//  TableRankDTO.swift
//  CBCT-Viettel
//
//  Created by Admin on 4/7/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class TableRankDTO: NSObject {

    var chartName: String
    var unit: String
    var searchId: Int?
    var visibleColumnsId: [Int]
    var header: [HeaderDTO]
    var tableRows: [TableRowDTO]
    var searchHint: String
    var objectType: String
    var headerRows: [HeaderRowDTO]

    init(_ json: JSON) {
        chartName = json["chartName"].stringValue
        unit = json["unit"].stringValue
        searchId = json["searchId"].intValue
        searchHint = json["searchHint"].stringValue
        objectType = json["objectType"].stringValue

        visibleColumnsId = []
        for item in json["visibleColumnsId"] {
            visibleColumnsId.append(item.1.intValue)
        }

        header = []
        for (_, subJson) in json["header"] {
            let dto = HeaderDTO(subJson)
            header.append(dto)
        }

        tableRows = []
        for (_, subJson) in json["tableRows"] {
            let dto = TableRowDTO(subJson)
            tableRows.append(dto)
        }

        headerRows = []
        for (_, subJson) in json["groups"] {
            let dto = HeaderRowDTO(subJson)
            headerRows.append(dto)
        }
    }
}
