//
//  GroupColumnChartDTO.swift
//  CBCT-Viettel
//
//  Created by Admin on 4/7/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class GroupColumnChartDTO: NSObject {
    var viewMore: Bool
    var chartName: String
    var unit: String
    var titleUnit: String
    var objectType: String
    var columnPieceStyles: [PieceStyleDTO]
    var columns: [ColumnDTO]
    
    var keyCommentList: [String]
    var dateList: [String]

    init(_ json: JSON) {
        viewMore = json["viewMore"].boolValue
        chartName = json["chartName"].stringValue
        unit = json["unit"].stringValue
        titleUnit = json["titleUnit"].stringValue
        objectType = json["objectType"].stringValue
        columnPieceStyles = []
        for (_, subJson) in json["columnPieceStyles"] {
            let dto = PieceStyleDTO(subJson)
            columnPieceStyles.append(dto)
        }
        columns = []
        keyCommentList = []
        dateList = []
        for (_, subJson) in json["columns"] {
            let dto = ColumnDTO(subJson)
            columns.append(dto)
            keyCommentList.append(dto.keyComment)
            dateList.append(dto.label)
        }
    }
}
