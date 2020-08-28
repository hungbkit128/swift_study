//
//  NewDataColumnDasBoard.swift
//  CBCT-Viettel
//
//  Created by Nguyễn Việt on 6/17/19.
//  Copyright © 2019 Tung Duong Thanh. All rights reserved.
//

import Foundation
import SwiftyJSON

class NewDataColumnDashBoard {
    var columnData: [NewItemBlocklistDataDashboard]
    var columnStyle: NewDataColumnStyleDashBoard?
    var monthLabels: [String]
    var prdIdLabels: [String]
    var stackLabels: [String]
    var title: String?
    
//    init(){}
    init(_ json: JSON) {
        columnData = []
                for (_, subJson) in json["columnData"] {
                    let data = NewItemBlocklistDataDashboard(subJson)
                    columnData.append(data)
                }
        columnStyle = NewDataColumnStyleDashBoard(json["columnStyle"])
        
        monthLabels = []
        for (_, subJson) in json["monthLabels"] {
            monthLabels.append(subJson.string!)
        }
        
        prdIdLabels = []
        for (_, subJson) in json["prdIdLabels"] {
            prdIdLabels.append(subJson.string!)
        }
        
        stackLabels = []
        for (_, subJson) in json["stackLabels"] {
            stackLabels.append(subJson.string!)
        }
        
        title = json["title"].string
        
//        monthLabels
    }
}
//    "monthLabels": [
//    "T12/2018",
//    "T01/2019",
//    "T02/2019",
//    "T03/2019",
//    "T04/2019",
//    "T05/2019"
//    ]
