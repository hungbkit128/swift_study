//
//  NewBlocklistDataDashboard.swift
//  CBCT-Viettel
//
//  Created by Nguyễn Việt on 6/10/19.
//  Copyright © 2019 Tung Duong Thanh. All rights reserved.
//

import Foundation
import SwiftyJSON

class NewBlocklistDataDashboard: NSObject {
    var blockId: String?
    var name: String?
    var type: String?
    var data: NewDataColumnDashBoard?
    var id: Int?
    var size: String?
    
    
    init(_ json: JSON) {
        blockId = json["blockId"].string
        name = json["name"].string
        type = json["type"].string
//        data = []
//        for (_, subJson) in json["data"] {
//            let dto = NewItemBlocklistDataDashboard(subJson)
//            data.append(dto)
//        }
        data = NewDataColumnDashBoard(json["data"])
        id = json["id"].int
        size = json["size"].string
    }
}
//"blockId": null,
//"name": "NUM_OF_USES",
//"type": "COLUMN_CHART",
//"data": [
//{
//"prdId": 201904,
//"donVi": "TD",
//"sumTH": 10
//},
//{
//"prdId": 201904,
//"donVi": "TD",
//"sumTH": 20
//},
//{
//"prdId": 201903,
//"donVi": "TD",
//"sumTH": 30
//},
//{
//"prdId": 201903,
//"donVi": "TD",
//"sumTH": 40
//}
//],
//"id": null,
//"size": null
