//
//  TableRowDTO.swift
//  CBCT-Viettel
//
//  Created by Admin on 4/7/17.
//  Copyright © 2017 Tung Duong Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class TableRowDTO: NSObject {

    var rowId: Int
    var objectId: String
    var rowData: [RowDataDTO]
    var groupId: String?

    init(_ json: JSON) {
        rowId = json["rowId"].intValue
        objectId = json["objectID"].stringValue
        if objectId.isEmpty {
            objectId = json["objectId"].stringValue
        }
        rowData = []
        for (_, subJson) in json["rowData"] {
            let dto = RowDataDTO(subJson)
            rowData.append(dto)
        }
        groupId = json["groupId"].string
    }
}
